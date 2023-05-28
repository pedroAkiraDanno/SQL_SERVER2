DECLARE
	 @Database	SYSNAME		= NULL	-- Filter by a specific database. Leave NULL for all databases.


SET NOCOUNT ON;

-- Variable declaration
DECLARE @user NVARCHAR(MAX), @loginExists BIT, @saName SYSNAME, @ownedSchemas NVARCHAR(MAX);

-- Find the actual name of the "sa" login
SELECT @saName = [name] FROM sys.server_principals WHERE sid = 0x01;

IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp;
CREATE TABLE #tmp (DBName SYSNAME NULL, UserName NVARCHAR(MAX), LoginExists BIT, OwnedSchemas NVARCHAR(MAX));
exec sp_MsforEachDB 'IF DATABASEPROPERTYEX(''?'', ''Status'') = ''ONLINE'' AND DATABASEPROPERTYEX(''?'', ''Updateability'') = ''READ_WRITE''
INSERT INTO #tmp
SELECT ''?'', dp.name AS user_name
, CASE WHEN dp.name IN (SELECT name COLLATE database_default FROM sys.server_principals) THEN 1 ELSE 0 END AS LoginExists
, OwnedSchemas = (
SELECT ''ALTER AUTHORIZATION ON SCHEMA::'' + QUOTENAME(sch.name) + N'' TO [dbo]; ''
FROM [?].sys.schemas AS sch
WHERE sch.principal_id = dp.principal_id
FOR XML PATH ('''')
)
FROM [?].sys.database_principals AS dp 
LEFT JOIN sys.server_principals AS sp ON dp.SID = sp.SID 
WHERE sp.SID IS NULL 
AND authentication_type_desc IN (''INSTANCE'',''WINDOWS'')
AND DATABASEPROPERTYEX(''?'',''Updateability'') = ''READ_WRITE'';'

IF EXISTS (SELECT NULL FROM #tmp WHERE DBName = @Database OR @Database IS NULL)
BEGIN
	DECLARE Orphans CURSOR FOR
	SELECT DBName, UserName, LoginExists, OwnedSchemas
	FROM #tmp
	WHERE DBName = @Database OR @Database IS NULL;

	OPEN Orphans
	FETCH NEXT FROM Orphans INTO @Database, @user, @loginExists, @ownedSchemas

	WHILE @@FETCH_STATUS = 0
	BEGIN
	 DECLARE @Command NVARCHAR(MAX)

	 IF @user = 'dbo'
		SET @Command = N'USE ' + QUOTENAME(@Database) + N'; ALTER AUTHORIZATION ON DATABASE::' + QUOTENAME(@Database) + N' TO ' + QUOTENAME(@saName) + N' -- assign orphaned [dbo] to [sa]'
	 ELSE IF @loginExists = 0
		SET @Command = N'USE ' + QUOTENAME(@Database) + N'; ' + ISNULL(@ownedSchemas, N'') + N' DROP USER ' + QUOTENAME(@user) + N' -- no existing login found'
	 ELSE
		SET @Command = N'USE ' + QUOTENAME(@Database) + N'; ALTER USER ' + QUOTENAME(@user) + N' WITH LOGIN = ' + QUOTENAME(@user) + N' -- existing login found'
 
	 PRINT @Command;
	 --EXEC (@Command);

	FETCH NEXT FROM Orphans INTO @Database, @user, @loginExists, @ownedSchemas
	END

	CLOSE Orphans
	DEALLOCATE Orphans
END
ELSE
	PRINT N'No orphan users found!'