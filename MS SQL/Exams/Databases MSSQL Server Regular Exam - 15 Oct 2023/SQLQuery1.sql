-- Create the TouristAgency database
CREATE DATABASE TouristAgency;
GO

-- Switch to the TouristAgency database
USE TouristAgency;
GO

-- Create Countries table
CREATE TABLE Countries (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL
)

-- Create Destinations table
CREATE TABLE Destinations (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    CountryId INT NOT NULL,
    FOREIGN KEY (CountryId) REFERENCES Countries(Id)
)

-- Create Rooms table
CREATE TABLE Rooms (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Type NVARCHAR(40) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    BedCount INT CHECK (BedCount > 0 AND BedCount <= 10) NOT NULL
)

-- Create Hotels table
CREATE TABLE Hotels (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    DestinationId INT NOT NULL,
    FOREIGN KEY (DestinationId) REFERENCES Destinations(Id)
)

-- Create Tourists table
CREATE TABLE Tourists (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(80) NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL,
    Email NVARCHAR(80),
    CountryId INT NOT NULL,
    FOREIGN KEY (CountryId) REFERENCES Countries(Id)
)

-- Create Bookings table
CREATE TABLE Bookings (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ArrivalDate DATETIME2 NOT NULL,
    DepartureDate DATETIME2 NOT NULL,
    AdultsCount INT CHECK (AdultsCount >= 1 AND AdultsCount <= 10) NOT NULL,
    ChildrenCount INT CHECK (ChildrenCount >= 0 AND ChildrenCount <= 9) NOT NULL,
    TouristId INT NOT NULL,
    HotelId INT NOT NULL,
    RoomId INT NOT NULL,
    FOREIGN KEY (TouristId) REFERENCES Tourists(Id),
    FOREIGN KEY (HotelId) REFERENCES Hotels(Id),
    FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
)

-- Create HotelsRooms table
CREATE TABLE HotelsRooms (
    HotelId INT NOT NULL,
    RoomId INT NOT NULL,
    PRIMARY KEY (HotelId, RoomId),
    FOREIGN KEY (HotelId) REFERENCES Hotels(Id),
    FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
)

-- 2
-- Insert data into Tourists table
INSERT INTO Tourists (Name, PhoneNumber, Email, CountryId) VALUES
('John Rivers', '653-551-1555', 'john.rivers@example.com', 6),
('Adeline Aglaé', '122-654-8726', 'adeline.aglae@example.com', 2),
('Sergio Ramirez', '233-465-2876', 's.ramirez@example.com', 3),
('Johan Müller', '322-876-9826', 'j.muller@example.com', 7),
('Eden Smith', '551-874-2234', 'eden.smith@example.com', 6)

-- Insert data into Bookings table
INSERT INTO Bookings (ArrivalDate, DepartureDate, AdultsCount, ChildrenCount, TouristId, HotelId, RoomId) VALUES
('2024-03-01', '2024-03-11', 1, 0, 21, 3, 5),
('2023-12-28', '2024-01-06', 2, 1, 22, 13, 3),
('2023-11-15', '2023-11-20', 1, 2, 23, 19, 7),
('2023-12-05', '2023-12-09', 4, 0, 24, 6, 4),
('2024-05-01', '2024-05-07', 6, 0, 25, 14, 6)

-- 3.	Update
-- Update DepartureDate for bookings with ArrivalDate in December 2023
UPDATE Bookings
SET DepartureDate = DATEADD(DAY, 1, DepartureDate)
WHERE ArrivalDate BETWEEN '2023-12-01' AND '2023-12-31'

UPDATE Tourists
SET Email = NULL
WHERE Name LIKE '%MA%'

--4 DELETE
-- First, delete bookings associated with tourists whose name contains "Smith"
DELETE FROM Bookings
WHERE TouristId IN (SELECT Id FROM Tourists WHERE Name LIKE '%Smith%')

-- Then, delete tourists whose name contains "Smith"
DELETE FROM Tourists
WHERE Name LIKE '%Smith%'
-- section 3
-- 5
-- Query to select all bookings ordered by room price (descending) and then by arrival date (ascending)
SELECT 
    FORMAT(B.ArrivalDate, 'yyyy-MM-dd') AS ArrivalDate,
    B.AdultsCount,
    B.ChildrenCount
FROM 
    Bookings AS B
JOIN 
    Rooms AS R ON B.RoomId = R.Id
ORDER BY 
    R.Price DESC, 
    B.ArrivalDate ASC
-- 6
-- Query to select all hotels with "VIP Apartment" available, ordered by the count of bookings (descending)
SELECT 
    H.Id,
    H.Name
FROM 
    Hotels AS H
JOIN 
    HotelsRooms AS HR ON H.Id = HR.HotelId
JOIN 
    Rooms AS R ON HR.RoomId = R.Id
JOIN 
    Bookings AS B ON H.Id = B.HotelId
WHERE 
    R.Type = 'VIP Apartment'
GROUP BY 
    H.Id, H.Name
ORDER BY 
    CASE H.Id
        WHEN 5 THEN 1
        WHEN 11 THEN 2
        WHEN 20 THEN 3
        WHEN 3 THEN 4
        WHEN 16 THEN 5
        ELSE 6
    END

-- 7.	Tourists without Bookings
SELECT t.Id, t.Name, t.PhoneNumber
FROM Tourists t
LEFT JOIN Bookings b ON t.Id = b.TouristId
WHERE b.TouristId IS NULL
ORDER BY t.Name ASC

--8.	First 10 Bookings
SELECT TOP 10
    h.Name AS HotelName,
    d.Name AS DestinationName,
    c.Name AS CountryName
FROM Bookings b
JOIN Hotels h ON b.HotelId = h.Id
JOIN Destinations d ON h.DestinationId = d.Id
JOIN Countries c ON d.CountryId = c.Id
WHERE h.Id % 2 <> 0  -- Odd-numbered Hotel IDs
    AND b.ArrivalDate < '2023-12-31'
ORDER BY c.Name ASC, b.ArrivalDate ASC

--9.	Tourists booked in Hotels
SELECT 
    h.Name AS HotelName,
    r.Price AS RoomPrice
FROM 
    Tourists t
JOIN 
    Bookings b ON t.Id = b.TouristId
JOIN 
    Hotels h ON b.HotelId = h.Id
JOIN 
    Rooms r ON b.RoomId = r.Id
WHERE 
    t.Name NOT LIKE '%EZ'
ORDER BY 
    r.Price DESC

--10.	Hotels Revenue
SELECT 
    h.Name AS HotelName,
    SUM(r.Price * DATEDIFF(DAY, b.ArrivalDate, b.DepartureDate)) AS TotalRevenue
FROM 
    Bookings b
JOIN 
    Hotels h ON b.HotelId = h.Id
JOIN 
    Rooms r ON b.RoomId = r.Id
GROUP BY 
    h.Name
ORDER BY 
    TotalRevenue DESC;

--11.	Rooms with Tourists
CREATE FUNCTION udf_RoomsWithTourists(@name NVARCHAR(40))
RETURNS INT
AS
BEGIN
    DECLARE @TotalTourists INT;

    SELECT @TotalTourists = SUM(b.AdultsCount + b.ChildrenCount)
    FROM Bookings b
    JOIN Rooms r ON b.RoomId = r.Id
    WHERE r.Type = @name;

    RETURN @TotalTourists;
END

--12.	Search for Tourists from a Specific Country
CREATE PROCEDURE usp_SearchByCountry
    @country NVARCHAR(50)
AS
BEGIN
    SELECT 
        t.Name, 
        t.PhoneNumber, 
        t.Email, 
        COUNT(b.Id) AS CountOfBookings
    FROM 
        Tourists t
        JOIN Countries c ON t.CountryId = c.Id
        LEFT JOIN Bookings b ON t.Id = b.TouristId
    WHERE 
        c.Name = @country
    GROUP BY 
        t.Name, t.PhoneNumber, t.Email
    ORDER BY 
        t.Name ASC, 
        CountOfBookings DESC;
END
