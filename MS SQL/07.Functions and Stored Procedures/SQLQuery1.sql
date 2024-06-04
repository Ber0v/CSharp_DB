-- 1.	Employees with Salary Above 35000
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000 AS BEGIN 
SELECT 
	FirstName AS 'First Name',
	LastName AS 'Last Name'
	FROM Employees
	WHERE Salary > 35000
END

-- 2.	Employees with Salary Above Number
CREATE PROCEDURE dbo.usp_GetEmployeesSalaryAboveNumber 
	@SalaryThreshold DECIMAL(18,4)
	AS BEGIN
		SELECT 
        FirstName AS 'First Name',
        LastName AS 'Last Name'
    FROM 
        Employees
    WHERE 
        Salary >= @SalaryThreshold
END

-- 3.	Town Names Starting With
CREATE PROCEDURE dbo.usp_GetTownsStartingWith @StartString VARCHAR(100) AS BEGIN
	SELECT 
	[Name] AS Town
	FROM Towns
	WHERE [Name] LIKE @StartString + '%'
END

-- 4.	Employees from Town
CREATE PROCEDURE dbo.usp_GetEmployeesFromTown @TownName VARCHAR(100) AS BEGIN
	SELECT 
	e.FirstName,
	e.LastName
	FROM Employees e
JOIN Addresses a ON e.AddressID = a.AddressID
JOIN Towns t ON t.TownID = a.TownID
WHERE t.[Name] = @TownName
END	

-- 5.	Salary Level Function
CREATE FUNCTION dbo.ufn_GetSalaryLevel(@Salary DECIMAL(18,4)) 
RETURNS VARCHAR(10) AS 
BEGIN 
	DECLARE @SalaryLevel VARCHAR(10)
	IF(@Salary < 30000)
	BEGIN 
	 SET @SalaryLevel = 'Low'
	END
	ELSE IF(@Salary >= 30000 AND @Salary <= 50000)
	BEGIN
	 SET @SalaryLevel = 'Average'
	END
	ELSE 
	BEGIN 
	 SET @SalaryLevel = 'High'
	END
RETURN @SalaryLevel
END

-- 6.	Employees by Salary Level
CREATE PROC usp_EmployeesBySalaryLevel(@SalaryLevel VARCHAR(10))
AS SELECT FirstName,LastName 
     FROM Employees 
    WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

-- 7.	Define Function
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50)) 
RETURNS BIT
AS
BEGIN
DECLARE @currentIndex int = 1;

WHILE(@currentIndex <= LEN(@word))
	BEGIN

	DECLARE @currentLetter varchar(1) = SUBSTRING(@word, @currentIndex, 1);

	IF(CHARINDEX(@currentLetter, @setOfLetters)) = 0
	BEGIN
	RETURN 0;
	END

	SET @currentIndex += 1;
	END

RETURN 1;
END

-- 8.	Delete Employees and Departments
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS

DECLARE @empIDsToBeDeleted TABLE
(
Id int
)

INSERT INTO @empIDsToBeDeleted
SELECT e.EmployeeID
FROM Employees AS e
WHERE e.DepartmentID = @departmentId

ALTER TABLE Departments
ALTER COLUMN ManagerID int NULL

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

UPDATE Departments
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Employees
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Departments
WHERE DepartmentID = @departmentId 

SELECT COUNT(*) AS [Employees Count] FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID
WHERE e.DepartmentID = @departmentId

-- 9.	Find Full Name
CREATE PROC usp_GetHoldersFullName AS
SELECT FirstName + ' ' + LastName AS [Full Name] 
  FROM AccountHolders

EXEC usp_GetHoldersFullName 

-- 10.	People with Balance Higher Than
