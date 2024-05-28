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