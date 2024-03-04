








-- TABLE WITH PRIMARY KEY 

-- Create a new table called "Employees"
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10, 2)
);

-- Insert some sample data into the "Employees" table
INSERT INTO Employees (FirstName, LastName, Department, Salary)
VALUES 
    ('John', 'Doe', 'IT', 60000.00),
    ('Jane', 'Smith', 'HR', 55000.00),
    ('Michael', 'Johnson', 'Finance', 65000.00),
    ('Emily', 'Williams', 'Marketing', 58000.00);
GO 10000






--put scheduler name: random_every_time
USE big_log4;
DECLARE @cnt INT = 0;
WHILE @cnt < 10000
BEGIN
        INSERT INTO Employees (FirstName, LastName, Department, Salary)
        VALUES 
            ('John', 'Doe', 'IT', 60000.00),
            ('Jane', 'Smith', 'HR', 55000.00),
            ('Michael', 'Johnson', 'Finance', 65000.00),
            ('Emily', 'Williams', 'Marketing', 58000.00);

   SET @cnt = @cnt + 1;
END;
GO
    



SELECT COUNT(*) FROM dbo.Employees;

SELECT COUNT(*) FROM dbo.Employees;

--SELECT * FROM dbo.Employees;

    





-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NO PRMARY KEY    



-- Create a new table called "Employees"
CREATE TABLE Employees (
    EmployeeID INT ,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10, 2)
);

-- Insert some sample data into the "Employees" table
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES 
    (1, 'John', 'Doe', 'IT', 60000.00),
    (2, 'Jane', 'Smith', 'HR', 55000.00),
    (3, 'Michael', 'Johnson', 'Finance', 65000.00),
    (4, 'Emily', 'Williams', 'Marketing', 58000.00);
GO 10000














