------------------------------------------------------------------
-- Random SQL Server 
------------------------------------------------------------------


if db_id('big_log4') is not null
    drop database big_log4
go

      
--create database to test 
CREATE DATABASE big_log4;
GO



--Autogrowth
USE [master]
GO
ALTER DATABASE [big_log4]
MODIFY FILE ( NAME = N'big_log4', FILEGROWTH = 512MB )
GO
ALTER DATABASE [big_log4]
MODIFY FILE ( NAME = N'big_log4_log', FILEGROWTH = 256MB )
GO



      


-- Select the rigth database 
USE big_log4;
GO



/* Switch on statistics time */
SET STATISTICS TIME ON; 
 
 



    
---------------------------------------------------------------------------------------------------------------------------------------------------
--RANDOM 1 


    

-- Create a temp table to hold some random data
if object_id('t1') is not null drop table t1    
CREATE TABLE t1(
    ID INT IDENTITY(1,1),
    stringData VARCHAR(255),
    intData INT,
    tempo  datetime
    )
GO

    

-- Add a GUID String & a Random Number between 1 & 100
INSERT t1
SELECT
CONVERT(varchar(255), NEWID()),
FLOOR(RAND()*(100)+1), getdate() ;
GO 100000 -- run 1000 times for 1000 rows of data


    
-- Select all data in the table and count
SELECT top(10) * FROM t1 ORDER BY ID ; 

DECLARE @CompatibilityLevel INT
SET @CompatibilityLevel = (SELECT compatibility_level FROM sys.databases
WHERE name = 'big_log4')

IF @CompatibilityLevel < 150
BEGIN
    -- Execute a query for compatibility level 100
    SELECT COUNT(*) AS QTD FROM t1;
END
ELSE IF @CompatibilityLevel >= 150
BEGIN
    -- Execute a query for compatibility level 150
    SELECT APPROX_COUNT_DISTINCT(ID) AS QTD_APPROX  FROM t1;
END




    



--put scheduler name: random_every_time
USE big_log4;
DECLARE @cnt INT = 0;
WHILE @cnt < 10000
BEGIN
      INSERT t1
      SELECT
      CONVERT(varchar(255), NEWID()),
      FLOOR(RAND()*(100)+1), getdate();

   SET @cnt = @cnt + 1;
END;
GO

   







    
---------------------------------------------------------------------------------------------------------------------------------------------------
--RANDOM 2 


    

-- Create a temp table to hold some random data
if object_id('t1') is not null drop table t1    
CREATE TABLE t1(
    ID INT IDENTITY(1,1),
    intData INT,
    tempo  datetime)
GO




--put scheduler name: random_every_time
USE big_log4;
DECLARE @cnt INT = 0;
WHILE @cnt < 100000
BEGIN
    INSERT INTO t1 
    VALUES (@cnt, getdate());

   SET @cnt = @cnt + 1;
END;
GO

    

    

   
-- Select all data in the table and count
SELECT top(10) * FROM t1 ORDER BY ID ; 

DECLARE @CompatibilityLevel INT
SET @CompatibilityLevel = (SELECT compatibility_level FROM sys.databases
WHERE name = 'big_log4')

IF @CompatibilityLevel < 150
BEGIN
    -- Execute a query for compatibility level 100
    SELECT COUNT(*) AS QTD FROM t1;
END
ELSE IF @CompatibilityLevel >= 150
BEGIN
    -- Execute a query for compatibility level 150
    SELECT APPROX_COUNT_DISTINCT(ID) AS QTD_APPROX  FROM t1;
END




    





   




    
   


---------------------------------------------------------------------------------------------------------------------------------------------------
-- WITH JOB SCHEDULER 














---------------------------------------------------------------------------------------------------------------------------------------------------

-- FINISH TEST 

/* Switch off statistics time */
SET STATISTICS TIME OFF; 


    

--DELETE DATABASE WITH (Graphical user interface) MODE
--or 

-- Excluindo dados de teste
use master;
drop database big_log4;
GO







