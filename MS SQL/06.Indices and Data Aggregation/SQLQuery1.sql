-- 1. Records' Count
SELECT COUNT(Id) AS Count FROM WizzardDeposits

-- 2. Longest Magic Wand
SELECT MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits

-- 3. Longest Magic Wand Per Deposit Groups
SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits
GROUP BY DepositGroup

-- 4. Smallest Deposit Group Per Magic Wand Size
SELECT TOP 2 DepositGroup FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize) ASC

-- 5. Deposits Sum
SELECT DepositGroup, SUM(DepositAmount) FROM WizzardDeposits
GROUP BY DepositGroup

-- 6. Deposits Sum for Ollivander Family
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
WHERE MagicWandCreator LIKE '%Ollivander%'
GROUP BY DepositGroup

-- 7. Deposits Filter
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
WHERE MagicWandCreator LIKE '%Ollivander%'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) <= 150000
ORDER BY TotalSum DESC

-- 8.  Deposit Charge
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator ASC, DepositGroup ASC

-- 9. Age Groups
SELECT 
	CASE
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		ELSE '[61+]'
	END AS AgeGroup,
COUNT(Id) AS WizardsCount
FROM WizzardDeposits
GROUP BY
	CASE
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		ELSE '[61+]'
	END
ORDER BY MIN(Age)

-- 10. First Letter
SELECT LEFT(FirstName,1) FROM WizzardDeposits
ORDER BY LEFT(FirstName,1) ASC

-- 11. Average Interest 
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AverageInterest FROM WizzardDeposits
WHERE 
    DepositStartDate > '1985-01-01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY 
    DepositGroup DESC,
    IsDepositExpired ASC

-- 12. *Rich Wizard, Poor Wizard
SELECT SUM([Difference]) AS SumDifference
FROM
(
SELECT 
	FirstName AS HostWizzard,
	DepositAmount AS HostWizzardDeposit,
	LEAD(FirstName) OVER (ORDER BY Id) AS GuestWizzard,
	LEAD([DepositAmount]) OVER (ORDER BY Id) AS GuestWizzardDeposit,
	(DepositAmount - LEAD([DepositAmount]) OVER (ORDER BY Id)) AS [Difference]
FROM WizzardDeposits
) AS SubQuery

-- 13. Departments Total Salaries
SELECT DepartmentID, SUM(Salary) AS TotalSalary FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

-- 14. Employees Minimum Salaries
SELECT DepartmentID, MIN(Salary) AS MinimumSalary FROM Employees
WHERE DepartmentID IN(2,5,7) AND HireDate > '2000-01-01'
GROUP BY DepartmentID

-- 15. Employees Average Salaries
SELECT * INTO RichEmployees
FROM Employees
WHERE Salary > 30000

DELETE 
FROM RichEmployees
WHERE ManagerID = 42

UPDATE RichEmployees
SET Salary = Salary + 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary)
FROM RichEmployees
GROUP BY DepartmentID
