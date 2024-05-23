

/*
Creating a large log file in SQL Server using T-SQL can be done in a few steps. Here's a step-by-step guide to create a database, configure its log file size, and populate it with enough data to make the log file large.
*/




/*
Step 1: Create a New Database
First, create a new database where you will configure the log file size.
*/

CREATE DATABASE LargeLogDB
ON PRIMARY 
(
    NAME = LargeLogDB_Data,
    FILENAME = 'C:\SQLData\LargeLogDB_Data.mdf',
    SIZE = 50MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = LargeLogDB_Log,
    FILENAME = 'C:\SQLData\LargeLogDB_Log.ldf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
);




/*Step 2: Configure Recovery Model
Set the recovery model to FULL to ensure every transaction is logged.*/

ALTER DATABASE LargeLogDB SET RECOVERY FULL;




/*Step 3: Create a Table and Insert Data
Create a table and insert a large amount of data to increase the log file size. Using transactions will help generate more log entries.*/

USE LargeLogDB;

CREATE TABLE LargeTable (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Data CHAR(8000) DEFAULT REPLICATE('A', 8000)
);

-- Insert data in a loop to generate a large log file
DECLARE @counter INT = 0;

BEGIN TRANSACTION
WHILE @counter < 10000 -- Adjust the number to generate the desired log file size
BEGIN
    INSERT INTO LargeTable DEFAULT VALUES;
    SET @counter = @counter + 1;
    -- Commit every 1000 rows to keep log file growth manageable
    IF @counter % 1000 = 0
    BEGIN
        COMMIT TRANSACTION;
        BEGIN TRANSACTION;
    END
END
COMMIT TRANSACTION;







/*

To insert data that will generate a log file of approximately 1 GB in size, we need to ensure that the data and transactions are large enough to create the desired log file size. The script provided inserts rows into a table with each row containing 8000 characters, but it may need adjustments to reach 1 GB precisely.

Here's a revised version of the script with an increased number of rows to ensure the log file grows to about 1 GB:

*/


USE LargeLogDB;

-- Step 1: Create the table
CREATE TABLE LargeTable (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Data CHAR(8000) DEFAULT REPLICATE('A', 8000)
);

-- Step 2: Insert data in a loop to generate a large log file
-- Each row is 8000 bytes, and we need 131072 rows to approximate 1 GB (1024 * 1024 * 1024 bytes)
DECLARE @counter INT = 0;
DECLARE @batchSize INT = 1000;

BEGIN TRANSACTION;
WHILE @counter < 131072
BEGIN
    INSERT INTO LargeTable DEFAULT VALUES;
    SET @counter = @counter + 1;
    
    -- Commit every 1000 rows to keep log file growth manageable
    IF @counter % @batchSize = 0
    BEGIN
        COMMIT TRANSACTION;
        BEGIN TRANSACTION;
    END
END
COMMIT TRANSACTION;















/*Step 4: Check Log File Size
To check the current size of the log file, use the following query:*/

/*
USE LargeLogDB;

SELECT 
    Name AS [File Name],
    Physical_Name AS [Physical Name], 
    size/128 AS [Total Size in MB],
    max_size/128 AS [Max Size in MB],
    growth/128 AS [Growth in MB]
FROM sys.master_files
WHERE type_desc = 'LOG' AND database_id = DB_ID('LargeLogDB');
*/


USE LargeLogDB;

SELECT 
    Name AS [File Name],
    Physical_Name AS [Physical Name], 
    size/128 AS [Total Size in MB],
    size/128/1024 AS [Total Size in GB],
    max_size/128 AS [Max Size in MB],
    max_size/128/1024 AS [Max Size in GB],
    growth/128 AS [Growth in MB],
    growth/128/1024 AS [Growth in GB]
FROM sys.master_files
WHERE type_desc = 'LOG' AND database_id = DB_ID('LargeLogDB');





--[COUNT]
SELECT COUNT(*) FROM LargeTable;
GO





--[OPTION]
/*Step 5: Optional - Manually Increase Log File Size
If you want to manually set the log file to a large size:*/

USE [master];

ALTER DATABASE LargeLogDB
MODIFY FILE
(
    NAME = N'LargeLogDB_Log',
    SIZE = 10240MB -- Set desired size in MB
);









/*Clean Up (Optional)
After you've created and verified the large log file, you might want to clean up by removing the database:*/

  USE [master];
DROP DATABASE LargeLogDB;


/*
Notes:
Ensure the paths in the FILENAME options point to valid directories on your server.
Adjust the loop counter and insert frequency as needed to reach your desired log file size.
This example assumes you have sufficient disk space and permissions to perform these operations.
By following these steps, you should be able to create a large log file in SQL Server using T-SQL.
*/





















