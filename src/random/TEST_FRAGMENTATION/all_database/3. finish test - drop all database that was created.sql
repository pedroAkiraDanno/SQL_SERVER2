-- Declare variables for dynamic SQL and cursor
DECLARE @dbname NVARCHAR(128);
DECLARE @sql NVARCHAR(MAX);

-- Cursor to select databases created today
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE create_date >= CAST(GETDATE() AS DATE)
AND create_date < DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
AND name like 'DB_TF_%'
AND name NOT IN ('master', 'tempdb', 'model', 'msdb'); -- Exclude system databases

-- Open the cursor
OPEN db_cursor;

-- Fetch the first database name
FETCH NEXT FROM db_cursor INTO @dbname;

-- Loop through all databases
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Build the SQL command to drop the database
    --SET @sql = 'DROP DATABASE [' + @dbname + ']; ';
    -- Build the SQL command to drop the database
    SET @sql = 'use master;
				GO
				DROP DATABASE [' + @dbname + ']; 
				GO';

    
    -- Print the SQL command (for debugging purposes)
    PRINT @sql;

    -- Execute the SQL command
    --EXEC sp_executesql @sql;

    -- Fetch the next database name
    FETCH NEXT FROM db_cursor INTO @dbname;
END

-- Clean up
CLOSE db_cursor;
DEALLOCATE db_cursor;
