


-- Declare variables for cursor and dynamic SQL
DECLARE @DatabaseName NVARCHAR(255);
DECLARE @SQL NVARCHAR(MAX);

-- Define the cursor to select database names
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE' -- Exclude offline databases
AND name NOT IN ('master', 'tempdb', 'model', 'msdb'); -- Exclude system databases

-- Open the cursor
OPEN db_cursor;

-- Fetch the first database
FETCH NEXT FROM db_cursor INTO @DatabaseName;

-- Loop through the databases
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Build the SQL command to execute the procedure
    SET @SQL = '
    USE [' + @DatabaseName + '];
    
    IF OBJECT_ID(''dbo.TestIndexFragmentation'', ''P'') IS NOT NULL
    BEGIN
        EXEC dbo.TestIndexFragmentation;
    END
    ELSE
    BEGIN
        PRINT ''Procedure TestIndexFragmentation does not exist in database ' + @DatabaseName + ''';
    END
    ';

    -- Execute the SQL command in the current database
    EXEC sp_executesql @SQL;

    -- Fetch the next database
    FETCH NEXT FROM db_cursor INTO @DatabaseName;
END

-- Clean up
CLOSE db_cursor;
DEALLOCATE db_cursor;











