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

-- 7.	Find Towns Not Starting With
SELECT TownID, [Name] FROM Towns
WHERE [Name] NOT LIKE '[RBD]%'
ORDER BY [Name] ASC

-- 8.	Create View Employees Hired After 2000 Year
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName,LastName FROM Employees
WHERE DATEPART(YEAR, HireDate) > 2000

-- 9.	Length of Last Name
SELECT FirstName,LastName FROM Employees
WHERE LEN(LastName) = 5

-- 10.	Rank Employees by Salary
SELECT EmployeeID, FirstName, LastName, Salary, DENSE_RANK() OVER 
					(PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

-- 11.	Find All Employees with Rank 2
WITH CTE_RankedEmployees AS
(
	SELECT EmployeeID, FirstName, LastName, Salary,
		DENSE_RANK() OVER
		(PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
	FROM Employees
	WHERE Salary BETWEEN 10000 AND 50000 
)

SELECT * 
FROM CTE_RankedEmployees 
WHERE [Rank] = 2
ORDER BY Salary DESC

-- 12.	Countries Holding 'A' 3 or More Times
SELECT CountryName, ISOCode FROM Countries
WHERE CountryName LIKE '%a%a%a%'
ORDER BY ISOCode ASC

-- 13.	 Mix of Peak and River Names
SELECT PeakName, RiverName, LOWER(CONCAT(SUBSTRING(PeakName,1, LEN(PeakName)-1),RiverName)) 
AS Mix FROM Peaks, Rivers
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix ASC

-- 14.	Games from 2011 and 2012 Year
SELECT TOP 50 [Name], FORMAT([Start],'yyyy-MM-dd') AS [START] FROM Games
WHERE DATEPART(YEAR, [START]) BETWEEN 2011 AND 2012
ORDER BY [START], [Name]

-- 15.	 User Email Providers
SELECT Username, SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS EmailProvider
FROM Users
ORDER BY EmailProvider, Username

-- 16.	 Get Users with IP Address Like Pattern
SELECT Username, IpAddress FROM Users
WHERE IpAddress LIKE '___.1_%._%.___'
ORDER BY Username ASC

-- 17.	 Show All Games with Duration and Part of the Day
SELECT [Name], [Part of the Day] =
	CASE
		WHEN DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
		ELSE 'Evening'
	END,
	Duration = CASE
		WHEN [Duration] <= 3 THEN 'Extra Short'
		WHEN [Duration] <= 6 THEN 'Short'
		WHEN [Duration] > 6 THEN 'Long'
		ELSE 'Extra Long'
		END
FROM Games
ORDER BY [Name], [Duration], [Part of the Day]

-- 18.	 Orders Table
SELECT Id, ProductName, OrderDate FROM Orders

SELECT ProductName, OrderDate,
	DATEADD(DAY, 3, OrderDate) AS [Pay Due],
	DATEADD(MONTH, 1, OrderDate) AS [Delivery Due]
FROM Orders
