------------------------------------------------------------------
-- Random SQL Server 
------------------------------------------------------------------


if db_id('big_log4') is not null
    drop database big_log4
go

      
--create database to test 
CREATE DATABASE big_log4;
GO
      
      


-- Select the rigth database 
USE big_log4;
GO


---------------------------------------------------------------------------------------------------------------------------------------------------
--RANDOM 1 


    

-- Create a temp table to hold some random data
if object_id('t1') is not null drop table t1    
CREATE TABLE t1(ID INT IDENTITY(1,1),
stringData VARCHAR(255),
intData INT)
GO


-- Add a GUID String & a Random Number between 1 & 100
INSERT t1
SELECT
CONVERT(varchar(255), NEWID()),
FLOOR(RAND()*(100)+1);
GO 100000 -- run 1000 times for 1000 rows of data


-- Select all data in the table 
SELECT * FROM t1 ORDER BY ID ; 
SELECT COUNT(*) FROM t1 ; 



--put scheduler name: random_every_time
USE big_log4;
DECLARE @cnt INT = 0;
WHILE @cnt < 1000
BEGIN
      INSERT t1
      SELECT
      CONVERT(varchar(255), NEWID()),
      FLOOR(RAND()*(100)+1);

   SET @cnt = @cnt + 1;
END;
GO

   


   

---------------------------------------------------------------------------------------------------------------------------------------------------

--RANDOM 2 


CREATE Table tblAuthors
(
   Id int identity primary key,
   Author_name nvarchar(50),
   country nvarchar(50)
)
CREATE Table tblBooks
(
   Id int identity primary key,
   Auhthor_id int foreign key references tblAuthors(Id),
   Price int,
   Edition int
)








Declare @Id int
Set @Id = 1

While @Id <= 12000
Begin 
   Insert Into tblAuthors values ('Author - ' + CAST(@Id as nvarchar(10)),
              'Country - ' + CAST(@Id as nvarchar(10)) + ' name')
   Print @Id
   Set @Id = @Id + 1
End









Declare @RandomAuthorId int
Declare @RandomPrice int
Declare @RandomEdition int

Declare @LowerLimitForAuthorId int
Declare @UpperLimitForAuthorId int

Set @LowerLimitForAuthorId = 1
Set @UpperLimitForAuthorId = 12000


Declare @LowerLimitForPrice int
Declare @UpperLimitForPrice int

Set @LowerLimitForPrice = 50 
Set @UpperLimitForPrice = 100 

Declare @LowerLimitForEdition int
Declare @UpperLimitForEdition int

Set @LowerLimitForEdition = 1
Set @UpperLimitForEdition = 10


Declare @count int
Set @count = 1

While @count <= 20000
Begin 

   Select @RandomAuthorId = Round(((@UpperLimitForAuthorId - @LowerLimitForAuthorId) * Rand()) + @LowerLimitForAuthorId, 0)
   Select @RandomPrice = Round(((@UpperLimitForPrice - @LowerLimitForPrice) * Rand()) + @LowerLimitForPrice, 0)
   Select @RandomEdition = Round(((@UpperLimitForEdition - @LowerLimitForEdition) * Rand()) + @LowerLimitForEdition, 0)


   Insert Into tblBooks values (@RandomAuthorId, @RandomPrice, @RandomEdition)
   Print @count
   Set @count = @count + 1
End





---------------------------------------------------------------------------------------------------------------------------------------------------
--RANDOM 3


Create Table RandomDataTable
  (ID int IDENTITY(1,1) NOT NULL Primary Key,
   CustomerID int NOT NULL,
   SalesPersonID varchar(10) NOT NULL,
   Quantity smallint NOT NULL,
   NumericValue numeric(18, 2) NOT NULL,
   Today date NOT NULL)
Go

--Inserting the data mass into the RandomDataTable --
Declare @Texto Char(130), 
        @Posicao TinyInt, 
@RowCount Int

Set @Texto = '0123456789@ABCDEFGHIJKLMNOPQRSTUVWXYZ\_abcdefghijklmnopqrstuvwxyzŽŸ¡ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåæçèéêëìíîïðñòóôõöùúûüýÿ' --There are 130 characters in this text--

Set @RowCount = Rand()*100000 -- Set the amount of lines to be inserted --

While (@RowCount >=1)
Begin

 Set @Posicao=Rand()*130

 If @Posicao <=125
  Begin
   Insert Into RandomDataTable (CustomerID, SalesPersonID, Quantity, NumericValue, Today)
   Values(@RowCount, 
                 Concat(SubString(@Texto,@Posicao+2,2),SubString(@Texto,@Posicao-4,4),SubString(@Texto,@Posicao+2,4)),
                 Rand()*1000, 
             Rand()*100+5, 
             DATEADD(d, 1000*Rand() ,GetDate()))
  End
  Else
  Begin
    Insert Into RandomDataTable (CustomerID, SalesPersonID, Quantity, NumericValue, Today)
    Values(@RowCount, 
                  Concat(SubString(@Texto,@Posicao-10,1),SubString(@Texto,@Posicao+4,6),SubString(@Texto,@Posicao-12,3)),
                  Rand()*1000, 
              Rand()*100+5, 
              DATEADD(d, 1000*Rand() ,GetDate()))
   End

   Set @RowCount = @RowCount - 1
End

Select ID, CustomerID, SalesPersonID, Quantity, NumericValue, Today 
From RandomDataTable
Go



---REFE: https://www.sqlservercentral.com/scripts/entering-random-data-into-a-table





---------------------------------------------------------------------------------------------------------------------------------------------------
-- RANDOM 4 


CREATE DATABASE ShoppingCart;
GO

USE ShoppingCart;
GO

CREATE TABLE Orders
(
  OrderId INT,
  CustomerId INT,
  Amount INT,
  OrderDate DATETIME
)
GO

CREATE TABLE OrdersHistory
(
  OrderId INT,
  CustomerId INT,
  Amount INT,
  OrderDate DATETIME
)
GO



INSERT INTO Orders VALUES (101, 100001, 10000, GETDATE())
INSERT INTO Orders VALUES (102, 100003, 10000, GETDATE())
INSERT INTO Orders VALUES (103, 100001, 30000, GETDATE())
INSERT INTO Orders VALUES (104, 100005, 50000, GETDATE())
INSERT INTO Orders VALUES (105, 100003, 70000, GETDATE())



--SCHEDULER  name: random_every_time_history
INSERT INTO OrdersHistory SELECT * FROM ORDERS;

--SCHEDULER  name: random_every_time_delete
DELETE FROM OrdersHistory; 







--REFERENCE: https://dotnettutorials.net/lesson/how-to-schedule-job-in-sql-server/

---------------------------------------------------------------------------------------------------------------------------------------------------
-- WITH JOB SCHEDULER 














---------------------------------------------------------------------------------------------------------------------------------------------------

-- FINISH TEST 



--DELETE DATABASE WITH (Graphical user interface) MODE
--or 

-- Excluindo dados de teste
use master;
drop database big_log4;
GO








