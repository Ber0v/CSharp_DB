-- Section 1. DDL 
-- Create the database
CREATE DATABASE LibraryDb

USE LibraryDb

-- Create the Contacts table
CREATE TABLE Contacts (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    PostAddress NVARCHAR(200),
    Website NVARCHAR(50)
)

-- Create the Authors table
CREATE TABLE Authors (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    ContactId INT NOT NULL,
    FOREIGN KEY (ContactId) REFERENCES Contacts(Id)
)

-- Create the Genres table
CREATE TABLE Genres (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(30) NOT NULL
)

-- Create the Libraries table
CREATE TABLE Libraries (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    ContactId INT NOT NULL,
    FOREIGN KEY (ContactId) REFERENCES Contacts(Id)
)

-- Create the Books table
CREATE TABLE Books (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    YearPublished INT NOT NULL,
    ISBN NVARCHAR(13) NOT NULL UNIQUE,
    AuthorId INT NOT NULL,
    GenreId INT NOT NULL,
    FOREIGN KEY (AuthorId) REFERENCES Authors(Id),
    FOREIGN KEY (GenreId) REFERENCES Genres(Id)
)

-- Create the LibrariesBooks table
CREATE TABLE LibrariesBooks (
    LibraryId INT NOT NULL,
    BookId INT NOT NULL,
    PRIMARY KEY (LibraryId, BookId),
    FOREIGN KEY (LibraryId) REFERENCES Libraries(Id),
    FOREIGN KEY (BookId) REFERENCES Books(Id)
)

--Section 2. DML 
--2.	Insert
INSERT INTO Contacts ([Email], [PhoneNumber], [PostAddress], [Website]) VALUES
(NULL, NULL, NULL, NULL),
(NULL, NULL, NULL, NULL),
('stephen.king@example.com', '+4445556666', '15 Fiction Ave, Bangor, ME', 'www.stephenking.com'),
('suzanne.collins@example.com', '+7778889999', '10 Mockingbird Ln, NY, NY', 'www.suzannecollins.com')

INSERT INTO Authors ([Name], [ContactId]) VALUES
('George Orwell', 21),
('Aldous Huxley', 22),
('Stephen King', 23),
('Suzanne Collins', 24)

INSERT INTO Books ([Title], [YearPublished], [ISBN], [AuthorId], [GenreId]) VALUES
('1984', 1949, '9780451524935', 16, 2),
('Animal Farm', 1945, '9780451526342', 16, 2),
('Brave New World', 1932, '9780060850524', 17, 2),
('The Doors of Perception', 1954, '9780060850531', 17, 2),
('The Shining', 1977, '9780307743657', 18, 9),
('It', 1986, '9781501142970', 18, 9),
('The Hunger Games', 2008, '9780439023481', 19, 7),
('Catching Fire', 2009, '9780439023498', 19, 7),
('Mockingjay', 2010, '9780439023511', 19, 7)

INSERT INTO LibrariesBooks (LibraryId, BookId) VALUES
(1, 36),
(1, 37),
(2, 38),
(2, 39),
(3, 40),
(3, 41),
(4, 42),
(4, 43),
(5, 44)

--3.	Update
UPDATE Contacts
SET Website = 'www.' + LOWER(REPLACE(a.Name, ' ', '')) + '.com'
FROM Contacts c
JOIN Authors a ON c.Id = a.ContactId
WHERE c.Website IS NULL

--4.	Delete
DELETE lb
FROM LibrariesBooks lb
JOIN Books b ON lb.BookId = b.Id
JOIN Authors a ON b.AuthorId = a.Id
WHERE a.Name = 'Alex Michaelides'

-- Step 2: Delete from Books where the author is 'Alex Michaelides'
DELETE b
FROM Books b
JOIN Authors a ON b.AuthorId = a.Id
WHERE a.Name = 'Alex Michaelides'

-- Step 3: Delete 'Alex Michaelides' from Authors
DELETE FROM Authors
WHERE Name = 'Alex Michaelides'

--Section 3. Querying 
--5.	Books by Year of Publication
SELECT
    Title AS [Book Title],
    ISBN,
    YearPublished AS YearReleased
FROM
    Books
ORDER BY
    YearReleased DESC,
    [Book Title] ASC

--6.	Books by Genre
SELECT 
    b.Id,
    b.Title,
    b.ISBN,
    g.Name AS Genre
FROM 
    Books b
JOIN 
    Genres g ON b.GenreId = g.Id
WHERE 
    g.Name IN ('Biography', 'Historical Fiction')
ORDER BY 
    g.Name, 
    b.Title

--7.	Libraries Missing Specific Genre
SELECT 
    l.Name AS Library,
    c.Email
FROM 
    Libraries l
JOIN 
    Contacts c ON l.ContactId = c.Id
WHERE 
    l.Id NOT IN (
        SELECT DISTINCT lb.LibraryId
        FROM LibrariesBooks lb
        JOIN Books b ON lb.BookId = b.Id
        JOIN Genres g ON b.GenreId = g.Id
        WHERE g.Name = 'Mystery'
    )
ORDER BY 
    l.Name

--8.	First 3 Books
SELECT
    b.Title AS Title,
    b.YearPublished AS Year,
    g.Name AS Genre
FROM
    Books b
    JOIN Genres g ON b.GenreId = g.Id
WHERE
    (b.YearPublished > 2000 AND b.Title LIKE '%a%')
    OR
    (b.YearPublished < 1950 AND g.Name LIKE '%Fantasy%')
ORDER BY
    Title ASC,
    Year DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY

--9.	Authors from the UK
SELECT
    a.Name AS Author,
    c.Email,
    c.PostAddress AS Address
FROM
    Authors a
    JOIN Contacts c ON a.ContactId = c.Id
WHERE
    c.PostAddress LIKE '%UK%'
ORDER BY
    Author ASC

--10.	Memoirs in NY
SELECT
    a.Name AS [Author],
    b.Title AS [Fiction Book],
    l.Name AS [Library],
    c.PostAddress AS [Library Address]
FROM
    Books b
JOIN
    Authors a ON b.AuthorId = a.Id
JOIN
    LibrariesBooks lb ON b.Id = lb.BookId
JOIN
    Libraries l ON lb.LibraryId = l.Id
JOIN
    Contacts c ON l.ContactId = c.Id
WHERE
    b.GenreId IN (
        SELECT Id FROM Genres WHERE Name = 'Fiction'
    )
    AND
    c.PostAddress LIKE '%Denver%'
ORDER BY
    b.Title ASC

--Section 4. Programmability 
-- 11.	Authors with Books
CREATE FUNCTION dbo.udf_AuthorsWithBooks
(
    @name NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
    DECLARE @bookCount INT

    SELECT @bookCount = COUNT(*) 
    FROM Books b
    JOIN Authors a ON b.AuthorId = a.Id
    JOIN LibrariesBooks lb ON b.Id = lb.BookId
    JOIN Libraries l ON lb.LibraryId = l.Id
    WHERE a.Name = @name

    RETURN @bookCount
END

--12.	Search for Books from a Specific Genre
CREATE PROCEDURE usp_SearchByGenre
(
    @genreName NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON

    SELECT
        b.Title,
        b.YearPublished AS Year,
        b.ISBN,
        a.Name AS Author,
        g.Name AS Genre
    FROM
        Books b
        JOIN Authors a ON b.AuthorId = a.Id
        JOIN Genres g ON b.GenreId = g.Id
    WHERE
        g.Name = @genreName
    ORDER BY
        b.Title ASC
END