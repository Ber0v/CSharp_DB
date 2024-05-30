-- 1.	Employee Address
SELECT TOP 5
    e.EmployeeId,
    e.JobTitle,
    a.AddressId,
    a.AddressText
FROM
    Employees e
JOIN
    Addresses a ON e.AddressId = a.AddressId
ORDER BY
    a.AddressId ASC

-- 2.	Addresses with Towns
SELECT TOP 50
	e.FirstName,
	e.LastName,
	t.[Name],
	a.AddressText
FROM
	Employees e
JOIN
    Addresses a ON e.AddressId = a.AddressId
JOIN
    Towns t ON a.TownID = t.TownID
ORDER BY
    e.FirstName ASC,
    e.LastName ASC

-- 3.	Sales Employee
SELECT 
	e.EmployeeID,
	e.FirstName,
	e.LastName,
	d.[Name]
FROM 
	Employees e
JOIN
    Departments d ON e.DepartmentID = d.DepartmentID
WHERE
    d.[Name] = 'Sales'
ORDER BY
	e.EmployeeID ASC

-- 4.	Employee Departments
SELECT TOP 5
	e.EmployeeID,
	e.FirstName,
	e.Salary,
	d.[Name]
FROM 
	Employees e
JOIN
	Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY d.DepartmentID ASC

-- 5.	Employees Without Project
SELECT TOP 3
	e.EmployeeID,
	e.FirstName
FROM Employees e
LEFT JOIN
    EmployeesProjects ep ON e.EmployeeID = ep.EmployeeID
WHERE
    ep.ProjectID IS NULL
ORDER BY e.EmployeeID ASC

-- 6.	Employees Hired After
SELECT
	e.FirstName,
	e.LastName,
	e.HireDate,
	d.[Name]
FROM 
	Employees e
JOIN
	Departments d ON e.DepartmentID = d.DepartmentID
WHERE
	e.HireDate > '1.1.1999'
	AND d.[Name] IN('Sales', 'Finance')
ORDER BY e.HireDate ASC

-- 7.	Employees with Project
SELECT TOP 5
	e.EmployeeID,
	e.FirstName,
	p.[Name]
FROM 
	Employees e
JOIN EmployeesProjects ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE
	p.StartDate > '2002-08-13' AND
	p.EndDate IS NULL
ORDER BY e.EmployeeID ASC

-- 8.	Employee 24
SELECT
	e.EmployeeID,
	e.FirstName,
	CASE
        WHEN p.StartDate >= '2005-01-01' THEN NULL
        ELSE p.[Name]
    END AS ProjectName
FROM 
	Employees e
JOIN EmployeesProjects ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24

-- 9.	Employee Manager
SELECT 
	e.EmployeeID,	
	e.FirstName,	
	e.ManagerID,	
	m.FirstName AS ManagerName
FROM 
	Employees e
JOIN	
	Employees m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID ASC

-- 10.	Employees Summary
SELECT TOP 50
	e.EmployeeID,
	CONCAT(e.FirstName,' ', e.LastName) AS EmployeeName,
	CONCAT(m.FirstName,' ', m.LastName) AS ManagerName,
	d.[Name]
FROM 
	Employees e
JOIN	
	Employees m ON e.ManagerID = m.EmployeeID
JOIN 
	Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

-- 11.	Min Average Salary
SELECT TOP 1 AVG(Salary) MinAverageSalary FROM Employees
GROUP BY DepartmentID
ORDER BY MinAverageSalary

-- 12.	Highest Peaks in Bulgaria
SELECT 
	c.CountryCode,
	m.MountainRange,
	p.PeakName,
	p.Elevation
FROM MountainsCountries c
JOIN Mountains m ON c.MountainId = m.Id
JOIN Peaks p ON c.MountainId = P.MountainId
WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

-- 13.	Count Mountain Ranges
SELECT 
	c.CountryCode,
	COUNT(m.MountainRange) AS MountainRanges
FROM MountainsCountries c
JOIN Mountains m ON c.MountainId = m.Id
WHERE c.CountryCode IN ('BG', 'RU', 'US')
GROUP BY 
    c.CountryCode

-- 14.	Countries With or Without Rivers
SELECT TOP 5
    c.CountryName,
    r.RiverName
FROM 
    Countries c
LEFT JOIN 
    CountriesRivers rc ON c.CountryCode = rc.CountryCode
LEFT JOIN 
    Rivers r ON rc.RiverID = r.Id
JOIN 
    Continents cc ON c.ContinentCode = cc.ContinentCode
WHERE 
    cc.ContinentName = 'Africa'
ORDER BY 
    c.CountryName

-- 15.	*Continents and Currencies
WITH CurrencyUsage AS (
    SELECT
        c.ContinentCode,
        c.CurrencyCode,
        COUNT(c.CountryCode) AS UsageCount
    FROM
        Countries c
    GROUP BY
        c.ContinentCode, c.CurrencyCode
),
FilteredCurrencyUsage AS (
    SELECT
        ContinentCode,
        CurrencyCode,
        UsageCount
    FROM
        CurrencyUsage
    WHERE
        UsageCount > 1
),
MaxCurrencyUsage AS (
    SELECT
        ContinentCode,
        MAX(UsageCount) AS MaxUsage
    FROM
        FilteredCurrencyUsage
    GROUP BY
        ContinentCode
)
SELECT
    fcu.ContinentCode,
    fcu.CurrencyCode,
    fcu.UsageCount AS CurrencyUsage
FROM
    FilteredCurrencyUsage fcu
JOIN
    MaxCurrencyUsage mcu ON fcu.ContinentCode = mcu.ContinentCode AND fcu.UsageCount = mcu.MaxUsage
ORDER BY
    fcu.ContinentCode;

-- 16.	Countries Without Any Mountains
SELECT COUNT(c.CountryCode) AS Count
FROM Countries c
LEFT JOIN MountainsCountries m ON c.CountryCode = m.CountryCode
WHERE m.MountainId IS NULL

-- 17.	Highest Peak and Longest River by Country
SELECT TOP (5)
	CountryName,
	MAX(Elevation) AS HighestPeakElevation,
	MAX(r.[Length]) AS LongestRiverLength
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId 
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
LEFT JOIN Peaks AS p ON p.MountainId = m.Id
GROUP BY 
	CountryName
ORDER BY
	HighestPeakElevation DESC,
	LongestRiverLength DESC,
	CountryName

-- 18.	Highest Peak Name and Elevation by Country
WITH PeaksRankedByElevation AS 
(
	SELECT
		c.CountryName,
		p.PeakName,
		p.Elevation,
		m.MountainRange,
		DENSE_RANK() OVER
			(PARTITION BY c.CountryName ORDER BY Elevation DESC) AS PeakRank
	FROM Countries AS c
	LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
	LEFT JOIN Peaks AS p ON m.Id = p.MountainId
)

SELECT TOP(5)
	CountryName AS Country,
	ISNULL(PeakName, '(no highest peak)') AS [Highest Peak Name],
	ISNULL(Elevation, 0) AS [Highest Peak Elevation],
	ISNULL(MountainRange, '(no mountain)') AS Mountain
FROM PeaksRankedByElevation
WHERE PeakRank = 1
ORDER BY 
	CountryName, [Highest Peak Name]