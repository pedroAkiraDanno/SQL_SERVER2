

USE DATABASENAME; -- CHANGE TO DATABASE NAME YOU WANT 
GO





CREATE OR ALTER  PROCEDURE TestIndexFragmentationAgain
AS
BEGIN

    
    -- 2. Add Random Data
    PRINT 'Adding Random Data ... '
    DECLARE @i INT = 1;

    WHILE @i <= 50000
    BEGIN
        INSERT INTO dbo.TestTable (Name, Value)
        VALUES (CONCAT('Name', @i), CAST(RAND() * 100 AS INT));
        
        SET @i = @i + 1;
    END


    -- 4. Update, Delete, and Insert Data
    -- Update Data
    PRINT 'Updating Data ... '        
    UPDATE dbo.TestTable
    SET Value = Value + 10
    WHERE ID % 2 = 0;

    -- Delete Data
    PRINT 'Delete Data ... '        
    DELETE FROM dbo.TestTable
    WHERE ID % 10 = 0;

    -- Insert More Data
    PRINT 'Inserting Data ... '        
    DECLARE @j INT = 1;

    WHILE @j <= 50000
    BEGIN
        INSERT INTO dbo.TestTable (Name, Value)
        VALUES (CONCAT('NewName', @j), CAST(RAND() * 100 AS INT));
        
        SET @j = @j + 1;
    END

    -- 5. Check Index Fragmentation
    PRINT 'Checking Index Fragmentation ... '                
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
END;












--EXEC TestIndexFragmentationAgain;



