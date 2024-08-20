-- Step 1: Create a table to store database names
IF OBJECT_ID('tempdb..#DatabasesToDrop') IS NOT NULL
    DROP TABLE #DatabasesToDrop;

CREATE TABLE #DatabasesToDrop (
    DatabaseName NVARCHAR(128)
);

-- Step 2: Insert names of databases created today into the table
INSERT INTO #DatabasesToDrop (DatabaseName)
SELECT name
FROM sys.databases
WHERE create_date >= CAST(CONVERT(date, GETDATE()) AS DATETIME)
AND name NOT IN ('master', 'tempdb', 'model', 'msdb'); -- Exclude system databases

-- Step 3: Generate the DROP DATABASE commands
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql + 'DROP DATABASE [' + DatabaseName + '];' + CHAR(13)
FROM #DatabasesToDrop;

-- Print the generated SQL commands (for review)
PRINT @sql;

-- Uncomment the line below to execute the DROP DATABASE commands
-- EXEC sp_executesql @sql;

-- Cleanup
DROP TABLE #DatabasesToDrop;







