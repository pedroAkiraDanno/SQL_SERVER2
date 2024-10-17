
-- Create 100 databases with random names and print the commands
DECLARE @i INT = 1;
WHILE @i <= 10
BEGIN
    -- Generate a random name using a combination of 'DB_' and a number
    DECLARE @dbname NVARCHAR(50) = CONCAT('DB_', @i);
    
    -- Construct the SQL statement to create the database
    DECLARE @sql NVARCHAR(MAX) = CONCAT('CREATE DATABASE ', @dbname, ';');
    
    -- Print the SQL statement
    PRINT @sql;
    
    -- Increment the counter
    SET @i = @i + 1;
END










DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    -- Generate a random name using a combination of letters and numbers
    DECLARE @dbname NVARCHAR(50) = 
        CONCAT(
            'DB_', 
            CHAR(65 + ABS(CHECKSUM(NEWID()) % 26)), -- Random letter A-Z
            CHAR(65 + ABS(CHECKSUM(NEWID()) % 26)), -- Random letter A-Z
            CHAR(48 + ABS(CHECKSUM(NEWID()) % 10)), -- Random digit 0-9
            CHAR(48 + ABS(CHECKSUM(NEWID()) % 10)), -- Random digit 0-9
            CHAR(48 + ABS(CHECKSUM(NEWID()) % 10))  -- Random digit 0-9
        );
    
    -- Construct the SQL statement to create the database
    DECLARE @sql NVARCHAR(MAX) = CONCAT('CREATE DATABASE ', @dbname, ';');
    
    -- Print the SQL statement
    PRINT @sql;
    
    -- Increment the counter
    SET @i = @i + 1;
END



