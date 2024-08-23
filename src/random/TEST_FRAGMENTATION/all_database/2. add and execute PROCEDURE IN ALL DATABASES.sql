






-- Declare a cursor to iterate through all databases
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
    -- Build the SQL command to create the procedure
    SET @SQL = '
    USE [' + @DatabaseName + '];

    IF OBJECT_ID(''dbo.TestTable'', ''U'') IS NOT NULL
    BEGIN
        DROP TABLE dbo.TestTable;
    END
    
    CREATE TABLE dbo.TestTable (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(50),
        Value INT
    );

    DECLARE @i INT = 1;

    WHILE @i <= 1000
    BEGIN
        INSERT INTO dbo.TestTable (Name, Value)
        VALUES (CONCAT(''Name'', @i), CAST(RAND() * 100 AS INT));
        
        SET @i = @i + 1;
    END

    CREATE NONCLUSTERED INDEX IDX_Value ON dbo.TestTable(Value);

    UPDATE dbo.TestTable
    SET Value = Value + 10
    WHERE ID % 2 = 0;

    DELETE FROM dbo.TestTable
    WHERE ID % 10 = 0;

    DECLARE @j INT = 1;

    WHILE @j <= 500
    BEGIN
        INSERT INTO dbo.TestTable (Name, Value)
        VALUES (CONCAT(''NewName'', @j), CAST(RAND() * 100 AS INT));
        
        SET @j = @j + 1;
    END

    /*SELECT 
        OBJECT_NAME(IPS.OBJECT_ID) AS TableName,
        IX.name AS IndexName,
        IPS.index_id AS IndexID,
        IPS.avg_fragmentation_in_percent AS FragmentationPercent
    FROM 
        sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, ''LIMITED'') IPS
        JOIN sys.indexes IX ON IPS.object_id = IX.object_id AND IPS.index_id = IX.index_id
    WHERE 
        OBJECTPROPERTY(IX.object_id, ''IsUserTable'') = 1
    ORDER BY 
        FragmentationPercent DESC;*/
    ';

    -- Execute the SQL command in the current database
    EXEC sp_executesql @SQL;

    -- Fetch the next database
    FETCH NEXT FROM db_cursor INTO @DatabaseName;
END

-- Clean up
CLOSE db_cursor;
DEALLOCATE db_cursor;








