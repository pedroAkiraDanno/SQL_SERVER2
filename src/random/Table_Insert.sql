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


