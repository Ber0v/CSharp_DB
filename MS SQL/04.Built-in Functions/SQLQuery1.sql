-- 1.	Find Names of All Employees by First Name
SELECT FirstName,LastName FROM Employees
WHERE FirstName LIKE 'Sa%'

-- 2.	Find Names of All Employees by Last Name 
SELECT FirstName,LastName FROM Employees
WHERE LastName LIKE '%ei%'

-- 3.	Find First Names of All Employees
SELECT FirstName FROM Employees
WHERE DepartmentID IN (3,10) AND
	DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005

-- 4.	Find All Employees Except Engineers
SELECT FirstName,LastName FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

-- 5.	Find Towns with Name Length
SELECT [Name] FROM Towns
WHERE LEN([Name]) BETWEEN 5 AND 6
ORDER BY [Name] ASC

-- 6.	Find Towns Starting With
SELECT TownID, [Name] FROM Towns
WHERE [Name] LIKE 'M%' OR
[Name] LIKE 'K%' OR 
[Name] LIKE 'B%' OR
[Name] LIKE 'E%'
ORDER BY [Name] ASC