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

select * from Users