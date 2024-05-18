-- 01. Create Dtatabase
Create Database Minions
use Minions
GO

-- 02.Create Tables
Create Table Minions
(
	Id Int primary key,
	[Name] varchar(50),
	Age Int
)

Create Table Towns
(
	Id Int primary key,
	[Name] varchar(50),
)

-- 03.Alter Minions Table
alter table Minions
add TownsId int

alter table Minions
add foreign key (TownsId) references Towns(Id)

-- 04.Insert Records in Both Tables
insert into Towns
values(1, 'Sofia'),
		(2, 'Plovdiv'),
		(3, 'Varna')

insert into Minions (Id, [Name], Age, TownsId)
values(1, 'Kevin', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Steward', Null, 2)

-- 05.Truncate Table Minions
Truncate table Minions

-- 06.Drop All Tables
Drop table Minions
Drop table Towns

-- 07.Create Table People
Create Table People
(
	Id Int primary key identity,
	[Name] nvarchar(200) not null,
	Picture varbinary(max),
	Height decimal(3,2),
	[Weight] decimal(5,2),
	Gender char(1) not null,
		check(Gender in('m','f')),
	Birthdate datetime2 not null,
	Biography varchar(max)
)

insert into People([Name], Gender, Birthdate)
			values ('Kevin', 'm', '1998-05-05'),
					('Pesho', 'm', '1980-03-08'),
					('Ratka', 'f', '2010-01-27'),
					('Berov', 'm', '2006-03-07'),
					('Abel', 'm', '1999-12-12')
-- 08.Create Table Users
Create Table Users
(
	Id Int primary key identity,
	Username varchar(30) not null,
	[Password] varchar(26) not null,
	ProfilePicture varbinary(max),
	LastLoginTime datetime2,
	IsDeleted bit
)
insert into Users(Username, [Password])
			values ('Kevin', '786215551'),
			('Pesho', '5235285272'),
			('Ratka', '87527272782'),
			('Abel', '25744754721'),
			('Berov', '5737527272783')

-- 09.Change Primary Key
alter table Users
drop constraint PK_UsersTable

alter table Users
add constraint PK_UsersTable primary key(Id, Username)

-- 10.Add Check Constraint
alter table Users
add constraint CHK_PassIsAtLeastFiveSimbols
		check(len([Password]) >= 5)

-- 11.Set Default Value of a Field
alter table Users
add constraint DF_LastLoginTime default getdate() for LastLoginTime

-- 12.Set Unique Field
alter table Users
drop constraint PK_UsersTable

alter table Users
add constraint PK_UsersTable primary key(Id)

alter table Users
add constraint UQ_Username unique(Username)

alter table Users
add constraint CHK_UsernameLength
    check (len(Username) >= 3)

-- 13.Movies Database
create Database Movies
use Movies
go

create table Directors
(
	Id int primary key identity,
	DirectorName varchar(100) not null,
    Notes varchar(max)
)
create table Genres 
(
	Id int primary key identity,
	GenreName varchar(100) not null,
    Notes varchar(max)
)
create table Categories  
(
	Id int primary key identity,
	CategoryName varchar(100) not null,
    Notes varchar(max)
)
create table Movies  
(
	Id int primary key identity,
	Title varchar(200) not null,
    DirectorId int not null,
    CopyrightYear int not null,
    Length int not null,
    GenreId int not null,
    CategoryId int not null,
    Rating int not null,
    Notes varchar(max),
    foreign key (DirectorId) references Directors(Id),
    foreign key (GenreId) references Genres(Id),
    foreign key (CategoryId) references Categories(Id)
)

insert into Directors (DirectorName, Notes)
values ('Director1', 'Notes1'),
       ('Director2', 'Notes2'),
       ('Director3', 'Notes3'),
       ('Director4', 'Notes4'),
       ('Director5', 'Notes5')

insert into Genres (GenreName, Notes)
values ('Genre1', 'Notes1'),
       ('Genre2', 'Notes2'),
       ('Genre3', 'Notes3'),
       ('Genre4', 'Notes4'),
       ('Genre5', 'Notes5')

insert into Categories (CategoryName, Notes)
values ('Category1', 'Notes1'),
       ('Category2', 'Notes2'),
       ('Category3', 'Notes3'),
       ('Category4', 'Notes4'),
       ('Category5', 'Notes5')

insert into Movies (Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes)
values ('Movie1', 1, 2001, 120, 1, 1, 5, 'Notes1'),
       ('Movie2', 2, 2002, 130, 2, 2, 4, 'Notes2'),
       ('Movie3', 3, 2003, 140, 3, 3, 3, 'Notes3'),
       ('Movie4', 4, 2004, 150, 4, 4, 2, 'Notes4'),
       ('Movie5', 5, 2005, 160, 5, 5, 1, 'Notes5')

-- 14.Car Database Database
create Database CarRental
use CarRental
go


CREATE TABLE Categories (
    Id INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL,
    DailyRate DECIMAL(10, 2) NOT NULL,
    WeeklyRate DECIMAL(10, 2) NOT NULL,
    MonthlyRate DECIMAL(10, 2) NOT NULL,
    WeekendRate DECIMAL(10, 2) NOT NULL
);


INSERT INTO Categories (Id, CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate) VALUES
(1, 'Compact', 30.00, 180.00, 600.00, 50.00),
(2, 'SUV', 50.00, 300.00, 1000.00, 80.00),
(3, 'Luxury', 100.00, 600.00, 2000.00, 150.00);


CREATE TABLE Cars (
    Id INT PRIMARY KEY,
    PlateNumber VARCHAR(20) NOT NULL,
    Manufacturer VARCHAR(100) NOT NULL,
    Model VARCHAR(100) NOT NULL,
    CarYear INT NOT NULL,
    CategoryId INT,
    Doors INT NOT NULL,
    Picture VARCHAR(255),
    Condition VARCHAR(50),
    Available BIT NOT NULL,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
);


INSERT INTO Cars (Id, PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available) VALUES
(1, 'ABC123', 'Toyota', 'Corolla', 2019, 1, 4, 'corolla.jpg', 'Good', 1),
(2, 'XYZ789', 'Ford', 'Explorer', 2020, 2, 4, 'explorer.jpg', 'Excellent', 1),
(3, 'DEF456', 'BMW', '7 Series', 2021, 3, 4, '7series.jpg', 'Like New', 1);


CREATE TABLE Employees (
    Id INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Title VARCHAR(100),
    Notes VARCHAR(255)
);


INSERT INTO Employees (Id, FirstName, LastName, Title, Notes) VALUES
(1, 'John', 'Doe', 'Manager', 'Experienced'),
(2, 'Jane', 'Smith', 'Sales Associate', 'New employee'),
(3, 'Michael', 'Johnson', 'Customer Service', NULL);


CREATE TABLE Customers (
    Id INT PRIMARY KEY,
    DriverLicenceNumber VARCHAR(20) NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    ZIPCode VARCHAR(20) NOT NULL,
    Notes VARCHAR(255)
);


INSERT INTO Customers (Id, DriverLicenceNumber, FullName, Address, City, ZIPCode, Notes) VALUES
(1, 'DL123456', 'Alice Johnson', '123 Main St', 'Anytown', '12345', NULL),
(2, 'DL789012', 'Bob Smith', '456 Elm St', 'Sometown', '67890', 'Corporate client'),
(3, 'DL345678', 'Charlie Brown', '789 Oak St', 'Anothertown', '54321', NULL);


CREATE TABLE RentalOrders (
    Id INT PRIMARY KEY,
    EmployeeId INT,
    CustomerId INT,
    CarId INT,
    TankLevel DECIMAL(5, 2),
    KilometrageStart INT,
    KilometrageEnd INT,
    TotalKilometrage INT,
    StartDate DATE,
    EndDate DATE,
    TotalDays INT,
    RateApplied DECIMAL(10, 2),
    TaxRate DECIMAL(5, 2),
    OrderStatus VARCHAR(50) NOT NULL,
    Notes VARCHAR(255),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
    FOREIGN KEY (CarId) REFERENCES Cars(Id)
);


INSERT INTO RentalOrders (Id, EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes) VALUES
(1, 1, 1, 1, 75.00, 5000, 5500, 500, '2024-05-01', '2024-05-05', 5, 150.00, 10.00, 'Completed', 'Customer was satisfied'),
(2, 2, 2, 2, 80.00, 3000, 3200, 200, '2024-05-02', '2024-05-06', 4, 250.00, 10.00, 'Completed', NULL),
(3, 3, 3, 3, 90.00, 1000, 1200, 200, '2024-05-03', '2024-05-07', 4, 400.00, 10.00, 'Completed', 'VIP customer');

-- 15.Hotel Database
create Database Hotel
use Hotel
go

CREATE TABLE Employees (
    Id INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Title VARCHAR(100),
    Notes VARCHAR(255)
);

INSERT INTO Employees (Id, FirstName, LastName, Title, Notes) VALUES
(1, 'John', 'Doe', 'Manager', 'Experienced'),
(2, 'Jane', 'Smith', 'Front Desk Clerk', 'Morning shift'),
(3, 'Michael', 'Johnson', 'Housekeeper', NULL);

CREATE TABLE Customers (
    AccountNumber INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20),
    EmergencyName VARCHAR(100),
    EmergencyNumber VARCHAR(20),
    Notes VARCHAR(255)
);

INSERT INTO Customers (AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes) VALUES
(1001, 'Alice', 'Johnson', '123-456-7890', 'Bob Smith', '234-567-8901', NULL),
(1002, 'Bob', 'Smith', '234-567-8901', 'Alice Johnson', '123-456-7890', 'Corporate client'),
(1003, 'Charlie', 'Brown', '345-678-9012', 'David Lee', '456-789-0123', NULL);

CREATE TABLE RoomStatus (
    RoomStatus VARCHAR(50) PRIMARY KEY,
    Notes VARCHAR(255)
);

INSERT INTO RoomStatus (RoomStatus, Notes) VALUES
('Occupied', 'Currently occupied by a guest'),
('Available', 'Ready for occupancy'),
('Under Maintenance', 'Currently being serviced');

CREATE TABLE RoomTypes (
    RoomType VARCHAR(50) PRIMARY KEY,
    Notes VARCHAR(255)
);

INSERT INTO RoomTypes (RoomType, Notes) VALUES
('Single', 'Single occupancy room'),
('Double', 'Double occupancy room'),
('Suite', 'Luxury suite');

CREATE TABLE BedTypes (
    BedType VARCHAR(50) PRIMARY KEY,
    Notes VARCHAR(255)
);

INSERT INTO BedTypes (BedType, Notes) VALUES
('Single', 'One single bed'),
('Double', 'One double bed'),
('King', 'One king-sized bed');

CREATE TABLE Rooms (
    RoomNumber INT PRIMARY KEY,
    RoomType VARCHAR(50),
    BedType VARCHAR(50),
    Rate DECIMAL(10, 2) NOT NULL,
    RoomStatus VARCHAR(50),
    Notes VARCHAR(255),
    FOREIGN KEY (RoomType) REFERENCES RoomTypes(RoomType),
    FOREIGN KEY (RoomStatus) REFERENCES RoomStatus(RoomStatus)
);

INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes) VALUES
(101, 'Single', 'Single', 80.00, 'Available', 'Standard single room'),
(102, 'Double', 'Double', 120.00, 'Available', 'Standard double room'),
(103, 'Suite', 'King', 250.00, 'Available', 'Luxury suite with king-sized bed');

CREATE TABLE Payments (
    Id INT PRIMARY KEY,
    EmployeeId INT,
    PaymentDate DATE,
    AccountNumber INT,
    FirstDateOccupied DATE,
    LastDateOccupied DATE,
    TotalDays INT,
    AmountCharged DECIMAL(10, 2),
    TaxRate DECIMAL(5, 2),
    TaxAmount DECIMAL(10, 2),
    PaymentTotal DECIMAL(10, 2),
    Notes VARCHAR(255),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
    FOREIGN KEY (AccountNumber) REFERENCES Customers(AccountNumber)
);

INSERT INTO Payments (Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes) VALUES
(1, 1, '2024-05-01', 1001, '2024-04-28', '2024-05-01', 4, 320.00, 10.00, 32.00, 352.00, 'Room charges and tax'),
(2, 2, '2024-05-02', 1002, '2024-04-30', '2024-05-02', 3, 360.00, 10.00, 36.00, 396.00, 'Room charges and tax'),
(3, 3, '2024-05-03', 1003, '2024-05-01', '2024-05-03', 2, 500.00, 10.00, 50.00, 550.00, 'Room charges and tax');

CREATE TABLE Occupancies (
    Id INT PRIMARY KEY,
    EmployeeId INT,
    DateOccupied DATE,
    AccountNumber INT,
    RoomNumber INT,
    RateApplied DECIMAL(10, 2),
    PhoneCharge DECIMAL(10, 2),
    Notes VARCHAR(255),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
    FOREIGN KEY (AccountNumber) REFERENCES Customers(AccountNumber),
    FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber)
);

INSERT INTO Occupancies (Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes) VALUES
(1, 1, '2024-04-28', 1001, 101, 80.00, 12.00, 'Standard single room'),
(2, 2, '2024-04-30', 1002, 102, 120.00, 15.00, 'Standard double room'),
(3, 3, '2024-05-01', 1003, 103, 250.00, 20.00, 'Luxury suite with king-sized bed');

-- 16.Create SoftUni Database
-- 18.Basic Insert
create Database SoftUni
use SoftUni
go

CREATE TABLE Towns (
    Id int PRIMARY KEY IDENTITY,
    Name varchar(100) NOT NULL
);

CREATE TABLE Addresses (
    Id int PRIMARY KEY IDENTITY,
    AddressText varchar(200) NOT NULL,
    TownId int NOT NULL,
    FOREIGN KEY (TownId) REFERENCES Towns(Id)
);

CREATE TABLE Departments (
    Id int PRIMARY KEY IDENTITY,
    Name varchar(100) NOT NULL
);

CREATE TABLE Employees (
    Id int PRIMARY KEY IDENTITY,
    FirstName varchar(50) NOT NULL,
    MiddleName varchar(50),
    LastName varchar(50) NOT NULL,
    JobTitle varchar(100) NOT NULL,
    DepartmentId int NOT NULL,
    HireDate date NOT NULL,
    Salary decimal(10, 2) NOT NULL,
    AddressId int NOT NULL,
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id),
    FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
);

INSERT INTO Towns (Name) VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO Addresses (AddressText, TownId) VALUES
('ул. "Търговска" 10', 1),
('бул. "Витоша" 20', 1),
('ул. "Цар Самуил" 15', 2),
('ул. "Христо Ботев" 30', 3);

INSERT INTO Departments (Name) VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary, AddressId)
VALUES ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 
        (SELECT Id FROM Departments WHERE Name = 'Software Development'), '2013-02-01', 3500.00, 1);

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary, AddressId)
VALUES ('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 
        (SELECT Id FROM Departments WHERE Name = 'Engineering'), '2004-03-02', 4000.00, 2);

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary, AddressId)
VALUES ('Maria', 'Petrova', 'Ivanova', 'Intern', 
        (SELECT Id FROM Departments WHERE Name = 'Quality Assurance'), '2016-08-28', 525.25, 3);

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary, AddressId)
VALUES ('Georgi', 'Teziev', 'Ivanov', 'CEO', 
        (SELECT Id FROM Departments WHERE Name = 'Sales'), '2007-12-09', 3000.00, 4);

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary, AddressId)
VALUES ('Peter', 'Pan', 'Pan', 'Intern', 
        (SELECT Id FROM Departments WHERE Name = 'Marketing'), '2016-08-28', 599.88, 5);

-- 22.Increase Employees Salary
UPDATE Employees
SET Salary = Salary * 1.10

SELECT Salary FROM Employees

-- 23.Decrease Tax Rate
UPDATE Payments
SET TaxRate = TaxRate - 0.03

SELECT TaxRate
FROM Payments;
