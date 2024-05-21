CREATE DATABASE ExampleDB
USE ExampleDB
GO

-- 1.	One-To-One Relationship
CREATE TABLE Persons
(
	PersonID INT NOT NULL,
	FirstName VARCHAR(50),
	Salary DECIMAL(10,2),
	PassportID INT,
	PRIMARY KEY (PersonID)
)
CREATE TABLE Passports
(
	PassportID INT NOT NULL,
	PassportNumber VARCHAR(20),
	PRIMARY KEY (PassportID)
)
INSERT INTO Persons VALUES
			(1, 'Roberto', 43300.00, 102),
			(2, 'Tom', 56100.00, 103),
			(3, 'Yana', 60200.00, 101)
		
INSERT INTO Passports VALUES
			(101, 'N34FG21B'),
			(102, 'K65LO4R7'),
			(103, 'ZE657QP2');

ALTER TABLE Persons
ADD CONSTRAINT FK_PassportID FOREIGN KEY (PassportID) REFERENCES Passports(PassportID)

-- 2.	One-To-Many Relationship
CREATE TABLE Manufacturers 
	(
	    ManufacturerID INT NOT NULL,
	    Name VARCHAR(50),
	    EstablishedOn DATE,
	    PRIMARY KEY (ManufacturerID)
	)
CREATE TABLE Models 
	(
		ModelID INT NOT NULL,
		[Name] VARCHAR(50),
		ManufacturerID INT
		PRIMARY KEY (ModelID),
		FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers(ManufacturerID)
	)

INSERT INTO Manufacturers (ManufacturerID, Name, EstablishedOn) VALUES
	(1, 'BMW', '1916-07-03'),
	(2, 'Tesla', '2003-01-01'),
	(3, 'Lada', '1966-01-05')	

INSERT INTO Models (ModelID, Name, ManufacturerID) VALUES
	(101, 'X1', 1),
	(102, 'i6', 1),
	(103, 'Model S', 2),
	(104, 'Model X', 2),
	(105, 'Model 3', 2),
	(106, 'Nova', 3)

-- 3.	Many-To-Many Relationship
CREATE TABLE Students
	(
		StudentID INT PRIMARY KEY NOT NULL,
		[Name] VARCHAR(50)
	)
CREATE TABLE Exams
	(
		ExamID INT PRIMARY KEY NOT NULL,
		[Name] VARCHAR(50)
	)
CREATE TABLE StudentsExams
	(
		StudentID INT NOT NULL,
		ExamID INT NOT NULL,
		PRIMARY KEY (StudentID, ExamID),
		FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
		FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
	)

INSERT INTO Students VALUES
	(1, 'Mila'),
	(2, 'Toni'),
	(3, 'Ron')

INSERT INTO Exams VALUES
	(101, 'SpringMVC'),
	(102, 'Neo4j'),
	(103, 'Oracle 11g')

INSERT INTO StudentsExams VALUES
	(1, 101),
	(1, 102),
	(2, 101),
	(2, 102),
	(2, 103),
	(3, 103)

-- 4.	Self-Referencing 
CREATE TABLE Teachers
	(
		TeacherID INT PRIMARY KEY NOT NULL,
		[Name] VARCHAR(50),
		ManagerID INT
		FOREIGN KEY (ManagerID) REFERENCES Teachers(TeacherID)
	)

-- 5.	Online Store Database
CREATE DATABASE InventoryDB
USE InventoryDB
GO

CREATE TABLE Cities
	(
	CityID INT PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50)
	)
CREATE TABLE Customers
	(
		CustomerID INT PRIMARY KEY NOT NULL,
		[Name] VARCHAR(50),
		Birthday DATE,
		CityID INT
		FOREIGN KEY (CityID) REFERENCES Cities(CityID)
	)
CREATE TABLE Orders 
	(
	    OrderID INT PRIMARY KEY NOT NULL,
	    CustomerID INT,
	    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
	)
CREATE TABLE ItemTypes
	(
		ItemTypeID INT PRIMARY KEY NOT NULL,
		[Name] VARCHAR(50)
	)
CREATE TABLE Items
	(
		ItemID INT PRIMARY KEY NOT NULL,
		[Name] VARCHAR(50),
		ItemTypeID INT,
		FOREIGN KEY (ItemTypeID) REFERENCES ItemTypes(ItemTypeID)
	)
CREATE TABLE OrderItems 
	(
	    OrderID INT NOT NULL,
	    ItemID INT NOT NULL,
		PRIMARY KEY (OrderID, ItemID),
	    FOREIGN KEY (ItemID) REFERENCES Items(ItemID),
		FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
	)

-- 6.	University Database
CREATE DATABASE UniversityDB
USE UniversityDB
GO

CREATE TABLE Students
	(
		StudentID INT PRIMARY KEY NOT NULL,
		StudentNumber INT NOT NULL,
		StudentName VARCHAR(50),
		MajorID INT
	)
CREATE TABLE Majors
	(
		MajorID INT PRIMARY KEY NOT NULL,
		[Name] VARCHAR(50)
	)
CREATE TABLE Payments
	(
		PaymentID INT PRIMARY KEY NOT NULL,
		PaymentDate DATE,
		PaymentAmount DECIMAL(10, 2),
		StudentID INT
	)
CREATE TABLE Agenda
	(
		StudentID INT NOT NULL,
		SubjectID INT NOT NULL,
		PRIMARY KEY(StudentID,SubjectID)
	)
CREATE TABLE Subjects
	(
		SubjectID INT PRIMARY KEY NOT NULL,
		SubjectName VARCHAR(50)
	)

ALTER TABLE Students
ADD FOREIGN KEY (MajorID) REFERENCES Majors(MajorID)

ALTER TABLE Payments
ADD FOREIGN KEY (StudentID) REFERENCES Students(StudentID)

ALTER TABLE Agenda
ADD FOREIGN KEY (StudentID) REFERENCES Students(StudentID)

ALTER TABLE Agenda
ADD FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)

-- 7.	SoftUni Design
