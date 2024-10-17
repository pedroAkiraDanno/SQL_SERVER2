


-- test index fragmentation in SQL Server


/*
1. **Create a Table**
2. **Add Random Data**
3. **Create an Index**
4. **Update, Delete, and Insert Data**
5. **Check Index Fragmentation**

Here’s a step-by-step guide:

### 1. Create a Table

Let's start by creating a sample table:
*/


CREATE TABLE TestTable (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50),
    Value INT
);


-- ### 2. Add Random Data

-- We’ll insert some random data into the table. For simplicity, I'll use a loop to insert data:


DECLARE @i INT = 1;

WHILE @i <= 1000
BEGIN
    INSERT INTO TestTable (Name, Value)
    VALUES (CONCAT('Name', @i), RAND() * 100);
    
    SET @i = @i + 1;
END


--### 3. Create an Index
--Now, create an index on the `Value` column to test fragmentation:
CREATE NONCLUSTERED INDEX IDX_Value ON TestTable(Value);


--### 4. Update, Delete, and Insert Data
--Perform some operations to fragment the index. You can use a variety of commands to do this:



--#### Update Data
UPDATE TestTable
SET Value = Value + 10
WHERE ID % 2 = 0;


--#### Delete Data
DELETE FROM TestTable
WHERE ID % 10 = 0;


-- #### Insert More Data
DECLARE @j INT = 1;

WHILE @j <= 500
BEGIN
    INSERT INTO TestTable (Name, Value)
    VALUES (CONCAT('NewName', @j), RAND() * 100);
    
    SET @j = @j + 1;
END


-- ### 5. Check Index Fragmentation
-- You can use the following query to check the fragmentation level of your index:


-- Check index fragmentation
SELECT 
    OBJECT_NAME(IPS.OBJECT_ID) AS TableName,
    IX.name AS IndexName,
    IPS.index_id AS IndexID,
    IPS.avg_fragmentation_in_percent AS FragmentationPercent
FROM 
    sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED') IPS
    JOIN sys.indexes IX ON IPS.object_id = IX.object_id AND IPS.index_id = IX.index_id
WHERE 
    OBJECTPROPERTY(IX.object_id, 'IsUserTable') = 1
ORDER BY 
    FragmentationPercent DESC;


--This query provides information about the level of fragmentation for each index.
-- ### Summary

-- By following these steps, you'll have a table with a non-clustered index, and you'll perform various data manipulation operations that should cause fragmentation. You can then check the fragmentation level to see how your index is affected.

-- Let me know if you need further details or assistance!







