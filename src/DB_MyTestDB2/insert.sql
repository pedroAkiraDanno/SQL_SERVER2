--put scheduler name: random_every_time
USE MyTestDB2;


DECLARE @cnt INT = 0;
WHILE @cnt < 100000
BEGIN
    INSERT INTO UserTab 
    VALUES (@cnt, CONVERT(varchar(255), NEWID()),@cnt );

   SET @cnt = @cnt + 1;
END;
GO



SELECT TOP 10 * FROM UserTab;
GO 

