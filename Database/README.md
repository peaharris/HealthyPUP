# Healthy PUP

## Physical Database Design
<hr>

[Physical Design](PhysicalDesign.md)

This is the underlying database design for the Healthy PUP Application. The Healthy PUP Application (HPA) will store a User's Dog, and all associated Records. These Records include Daily Routine, Vet Visits, and Walk Records. These Records are stored in different tables (Users, Dog, Daily Routine, Vet Visits, Walks).

<hr>

## Database Implementation (SQL Script)

### Drop And Create Database
This drops the (HPA) Database if it exists and creates the HPA Database.
~~~sql
USE master;
DROP DATABASE IF EXISTS HealthyPupDb;
IF @@ERROR = 3702 
   RAISERROR(N'Database cannot be dropped because there are still open connections.', 127, 127) WITH NOWAIT, LOG;
CREATE DATABASE HealthyPupDb;
GO

USE HealthyPupDb;
GO

CREATE SCHEMA HPR AUTHORIZATION dbo;
GO
~~~
### User Table
This Record stores all User information to include their email, password, and auto generated ID. The Primary key is the id. None of the items are null. The email item that the User registers with must be unique, meaning no one else can register with the same email. This table does not have a foreign key. 
~~~sql
CREATE TABLE HPR.Users
(
	id        INT  IDENTITY(1,1)	NOT NULL,
	password  NVARCHAR(40)          NOT NULL,
	email     NVARCHAR(40)          NOT NULL,

    CONSTRAINT PK_User PRIMARY KEY(id),
    CONSTRAINT UC_Email UNIQUE (email)   --creates a unique constraint
);
GO

CREATE NONCLUSTERED INDEX idx_nc_users_email ON HPR.Users(email);
GO
~~~
### Dog Table
This Record stores all of the User's Dog information to include the dog's name, breed, birthday and auto generated ID. None of the items can be null. The Primary key is the id. The foreign key is the userID. 
~~~sql
CREATE TABLE HPR.Dog
(
	id		INT  IDENTITY(1,1)	NOT NULL,
	name		NVARCHAR(40)		NOT NULL,
	breed		NVARCHAR(40)		NOT NULL,
	birthday	DATE			NOT NULL,
	userID		INT			NOT NULL,

	CONSTRAINT PK_Dog PRIMARY KEY(id),
	CONSTRAINT FK_HPR_Users FOREIGN KEY (userID)
		REFERENCES HPR.Users(id),
	CONSTRAINT CHK_birthday CHECK(birthday <= CAST(SYSDATETIME() AS DATE))
);
GO
~~~
### Daily Routine Table
This Record stores the Dog's Daily Routine information to include the date, their food, number of poops, number of pees, and auto generated ID. Only the pee item can be null. The Primary key is the id. The foreign key is the dogID. 
~~~sql
CREATE TABLE HPR.DailyRoutine
(
	id	INT  IDENTITY(1,1)	NOT NULL,
	date	DATE			NOT NULL,
	food	NVARCHAR(120)		NOT NULL,
	poop	INT			NOT NULL,
	pee	INT			NULL,
	dogID	INT			NOT NULL,

	CONSTRAINT PK_DailyRoutine PRIMARY KEY(id),
	CONSTRAINT FK_HPR_DailyRoutine FOREIGN KEY (dogID)
		REFERENCES HPR.Dog(id),
	CONSTRAINT CHK_date CHECK(date <= CAST(SYSDATETIME() AS DATE))
);
GO
~~~
### Vet Visits Table
This Record stores Dog's Vet Visit information to include the date, their vaccines, weight, comments, and auto generated ID. Only the vaccine and comment section can be null. The Primary key is the id. The foreign key is the dogID. 
~~~sql
CREATE TABLE HPR.VetVisits
(
	id		INT  IDENTITY(1,1)	NOT NULL,
	date		DATE			NOT NULL,
	vaccine		NVARCHAR(40)		NULL,
	weight		INT			NOT NULL,
	comments	NVARCHAR(120)		NULL,
	dogID		INT			NOT NULL,

	CONSTRAINT PK_VetVisits PRIMARY KEY(id),
	CONSTRAINT FK_HPR_VetVisits FOREIGN KEY (dogID)
		REFERENCES HPR.Dog(id),
	CONSTRAINT CHK_VetVisits_date CHECK(date <= CAST(SYSDATETIME() AS DATE))
);
GO
~~~
### Walks Table
This Record stores Dog's Walk information to include the date, their walk duration, distance, location, and auto generated ID. Only the duration, distance and location item can be null. The Primary key is the id. The foreign key is the dogID. 
~~~sql
CREATE TABLE HPR.Walks
(
	id		INT  IDENTITY(1,1)	NOT NULL,
	date		DATE			NOT NULL,
	duration	INT			NULL,
	distance	INT			NULL,
	location	NVARCHAR(40)		NULL,
	dogID		INT			NOT NULL,

	CONSTRAINT PK_Walks PRIMARY KEY(id),
	CONSTRAINT FK_HPR_Walks FOREIGN KEY (dogID)
		REFERENCES HPR.Dog(id),
	CONSTRAINT CHK_Walks_date CHECK(date <= CAST(SYSDATETIME() AS DATE))
);
GO
~~~

