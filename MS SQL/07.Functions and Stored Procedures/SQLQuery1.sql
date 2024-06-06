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
CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan @parameter DECIMAL(20,6)
AS
BEGIN
	SELECT 
	ah.FirstName AS [First Name]
	,ah.LastName AS [Last Name]
	
	FROM AccountHolders AS ah
	JOIN (
	SELECT 
	AccountHolderId
	,SUM(Balance) AS TotalSum
	FROM Accounts
	GROUP BY AccountHolderId
	) AS sas ON ah.Id=sas.AccountHolderId
	WHERE TotalSum>@parameter
	ORDER BY ah.FirstName,ah.LastName

END

--11. Future Value Function
CREATE FUNCTION  ufn_CalculateFutureValue (@sum DECIMAL(14,4), @rate FLOAT,@years  INT)
RETURNS DECIMAL (24,4)
AS
BEGIN
	RETURN @sum * POWER((1 + @rate), @years)
END

--12. Calculating Interest
CREATE PROCEDURE usp_CalculateFutureValueForAccount @accountId INT,@rate FLOAT
AS
BEGIN
	SELECT 
	ac.Id AS [Account Id]
	,ah.FirstName AS [First Name]
	,ah.LastName AS [Last Name]
	,ac.Balance AS [Current Balance]
	,dbo.ufn_CalculateFutureValue(ac.Balance,@rate,5)AS[Balance in 5 years]
	
	FROM AccountHolders AS ah
	JOIN Accounts AS ac ON ah.Id=ac.AccountHolderId
	WHERE ac.Id=@accountId
END

--13. *Cash in User Games Odd Rows
CREATE OR ALTER FUNCTION ufn_CashInUsersGames (@GameName NVARCHAR(50))
RETURNS TABLE 
AS
RETURN
	SELECT
	Sum(sg.Cash) AS SumCash
	FROM
		(
		SELECT 
		ug.Cash
		,ROW_NUMBER() OVER (ORDER BY ug.Cash DESC) AS RowNumber
		FROM UsersGames AS ug
		JOIN Games AS g ON ug.GameId=g.Id
		WHERE g.Name=@GameName) AS sg
	WHERE sg.RowNumber%2=1