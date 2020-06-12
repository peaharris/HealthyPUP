--USE [master]
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

/****** Object:  Table [dbo].[User]    Script Date: 5/5/2020 8:59:16 AM ******/
CREATE TABLE HPR.Users
(
	id        INT          IDENTITY(1,1)  NOT NULL,
	password  NVARCHAR(40)                NOT NULL,
	email     NVARCHAR(40)                NOT NULL,

    CONSTRAINT PK_User PRIMARY KEY(id),
	CONSTRAINT UC_Email UNIQUE (email)   --creates a unique constraint
);
GO

CREATE NONCLUSTERED INDEX idx_nc_users_email ON HPR.Users(email); --clustered is 2 different databases on different machines
GO

INSERT INTO  HPR.Users(email, password)       --sorry for using your email as test data Paul!
	VALUES (N'PBanta101@GMail.com', N'password1'),
		   (N'PBanta102@GMail.com', N'password2'),
		   (N'PBanta103@GMail.com', N'password3'),
		   (N'PBanta104@GMail.com', N'password4'),
		   (N'PBanta105@GMail.com', N'password5'),
		   (N'PBanta106@GMail.com', N'password6'),
		   (N'PBanta107@GMail.com', N'password7'),
		   (N'PBanta108@GMail.com', N'password8'),
		   (N'PBanta109@GMail.com', N'password9'),
		   (N'PBanta100@GMail.com', N'password0');

/****** Object:  Table [dbo].[Dog]    Script Date: 5/5/2020 8:59:16 AM ******/
CREATE TABLE HPR.Dog
(
	id			INT			IDENTITY(1,1)	NOT NULL,
	name		NVARCHAR(40)				NOT NULL,
	breed		NVARCHAR(40)				NOT NULL,
	birthday	DATE						NOT NULL,
	userID		INT							NOT NULL,

	CONSTRAINT PK_Dog PRIMARY KEY(id),
	CONSTRAINT FK_HPR_Users FOREIGN KEY (userID)
		REFERENCES HPR.Users(id),
	--CONSTRAINT CHK_birthday CHECK(birthday <= CAST(SYSDATETIME() AS DATE))
);
GO

INSERT INTO  HPR.Dog(name, breed, birthday, userID)
	VALUES (N'Harold', N'Boston Terrier', '02/19/2010', 1),
		   (N'Buck', N'Lab', '01/10/2015', 2),
		   (N'Bones', N'Chow Chow', '05/09/2018', 3),	
		   (N'Winnie', N'Border Collie', '01/19/2016', 4),	
		   (N'Moose', N'Pit Terrier', '02/04/2012', 5),	
		   (N'Mochi', N'Chihuahuas', '04/17/2014', 6),	
		   (N'Walter', N'Scottish Terrier', '06/21/2016', 7),	
		   (N'Ben', N'German Shepherd', '12/24/2015', 8),	
		   (N'Penny', N'Poodle', '11/14/2016', 9),
		   (N'Yoshi', N'Pug', '02/14/2015', 10);

/****** Object:  Table [dbo].[Daily Routine]    Script Date: 5/5/2020 8:59:16 AM ******/

CREATE TABLE HPR.DailyRoutine
(
	id		INT IDENTITY(1,1)	NOT NULL,
	date	DATE				NOT NULL,
	food	NVARCHAR(120)		NOT NULL,
	poop	INT					NOT NULL,
	pee		INT					NULL,
	dogID	INT					NOT NULL,

	CONSTRAINT PK_DailyRoutine PRIMARY KEY(id),
	CONSTRAINT FK_HPR_DailyRoutine FOREIGN KEY (dogID)
		REFERENCES HPR.Dog(id),
	CONSTRAINT CHK_date CHECK(date <= CAST(SYSDATETIME() AS DATE))
);
GO

INSERT INTO  HPR.DailyRoutine(date, food, poop, pee, dogID)
	VALUES ('05/08/2020', N'Chicken and sweet potatoes', 2, 4, 1),
		   ('05/08/2020', N'Iams', 1, 3, 2),
		   ('05/08/2020', N'Eggs and carrots', 3, 4, 3),
		   ('05/08/2020', N'Blue Buffalo Chicken Kibbles', 2, 6, 4),
		   ('05/08/2020', N'Purina Beneful', 3, 9, 5),
		   ('05/08/2020', N'Raw chicken and rice', 3, 6, 6),
		   ('05/08/2020', N'Taste of the Wild Salmon Kibbles', 4, 8, 7),
		   ('05/08/2020', N'Hills Science Diet Kibbles', 3, 5, 8),
		   ('05/08/2020', N'Beef Cheek and sweet potatoes', 4, 9, 9),
		   ('05/08/2020', N'Pork and brussel sprouts', 3, 8, 10);


/****** Object:  Table [dbo].[Vet Visit]    Script Date: 5/5/2020 8:59:16 AM ******/
CREATE TABLE HPR.VetVisits
(
	id			INT IDENTITY(1,1)	NOT NULL,
	date		DATE				NOT NULL,
	vaccine		NVARCHAR(40)		NULL,
	weight		INT					NOT NULL,
	comments	NVARCHAR(120)		NULL,
	dogID		INT					NOT NULL,

	CONSTRAINT PK_VetVisits PRIMARY KEY(id),
	CONSTRAINT FK_HPR_VetVisits FOREIGN KEY (dogID)
		REFERENCES HPR.Dog(id),
	CONSTRAINT CHK_VetVisits_date CHECK(date <= CAST(SYSDATETIME() AS DATE))
);
GO


INSERT INTO  HPR.VetVisits(date, vaccine, weight, comments, dogID)
	VALUES ('05/01/2020', N'Rabies', 18, N'Harold was so bad at the vets today!', 1),
		   ('05/02/2020', N'Distemper', 55, N'Buck needs to start taking fish oil pills', 2),
		   ('05/03/2020', N'Parvo', 67, N'Bones coat is dry', 3),
		   ('05/01/2020', N'Parainfluenza', 26, N'Winnie was so good today!', 4),
		   ('05/02/2020', N'Rabies', 45, N'Moose needs to come back in 2 weeks for a follow up', 5),
		   ('05/05/2020', N'Rabies', 10, N'Mochi needs to gain 5 lbs.', 6),
		   ('05/06/2020', N'Kennel Cough', 19, N'Walter was so bad at the vets today!', 7),
		   ('05/07/2020', null, 67, N'Ben was so good and well behaved at the vets today!', 8),
		   ('05/03/2020', null, 45, N'Penny was complimented on her coat', 9),
		   ('05/04/2020', N'Rabies', 23, N'Yoshi needs to lose 5 lbs!', 10);

/****** Object:  Table [dbo].[Walks]    Script Date: 5/5/2020 8:59:16 AM ******/

CREATE TABLE HPR.Walks
(
	id			INT IDENTITY(1,1)	NOT NULL,
	date		DATE				NOT NULL,
	duration	INT					NULL,
	distance	INT					NULL,
	location	NVARCHAR(40)		NULL,
	dogID		INT					NOT NULL,

	CONSTRAINT PK_Walks PRIMARY KEY(id),
	CONSTRAINT FK_HPR_Walks FOREIGN KEY (dogID)
		REFERENCES HPR.Dog(id),
	CONSTRAINT CHK_Walks_date CHECK(date <= CAST(SYSDATETIME() AS DATE))
);
GO
INSERT INTO  HPR.Walks(date, duration, distance, location, dogID)
	VALUES ('05/08/2020', '50', 1, N'Walked to ciy Park and played frisbee', 1),
		   ('05/08/2020', '60', 2, N'Walked to the creek', 2),
		   ('05/08/2020', '50', 1, N'Walked to Target', 3),
		   ('05/08/2020', '30', .5, N'Dog Park', 4),
		   ('05/08/2020', '80', 1, N'Dog Park', 5),
		   ('05/08/2020', '180', 3, N'Benedict Fountain Park', 6),
		   ('05/08/2020', '250', 4, N'Jogged to Curtis Park and back', 7),
		   ('05/08/2020', '200', 3, N'Went swimming at the beach', 8),
		   ('05/08/2020', '220', 3, N'Played fetch at Lawson Park', 9),
		   ('05/08/2020', '160', 2, N'Walked to City Park', 10);

--Multi-Table Queries

--Testing Users and their Dog
SELECT U.id, U.email, D.name, D.breed, D.birthday
FROM HPR.Users AS U
	INNER JOIN HPR.Dog AS D
		ON U.id=D.userID;

--Testing Dog and Walks
SELECT D.name, W.date, W.duration, W.distance, W.location
FROM HPR.Dog AS D
	INNER JOIN HPR.Walks AS W
		ON D.id=W.dogID;

--Testing Dog and Dailly Routine
SELECT D1.name, D2.date, D2.food, D2.poop, D2.pee
FROM HPR.Dog AS D1
	INNER JOIN HPR.DailyRoutine AS D2
		ON D1.id=D2.dogID;

--Testing Dog and VetVisits
SELECT D.name, V.date, V.vaccine, V.weight, V.comments
FROM HPR.Dog AS D
	INNER JOIN HPR.VetVisits AS V
		ON D.id=V.dogID;

--Single Table Queries
SELECT *
FROM HPR.Users;

SELECT *
FROM HPR.DailyRoutine;

SELECT *
FROM HPR.Dog;

SELECT *
FROM HPR.VetVisits;

SELECT *
FROM HPR.Walks;

