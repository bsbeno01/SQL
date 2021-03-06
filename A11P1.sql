
CREATE TABLE CREW (
CHAR_TRIP int NOT NULL,
EMP_NUM int NOT NULL,
CREW_JOB varchar(20)
);

INSERT INTO CREW VALUES('10001','104','Pilot');
INSERT INTO CREW VALUES('10002','101','Pilot');
INSERT INTO CREW VALUES('10003','105','Pilot');
INSERT INTO CREW VALUES('10003','109','Copilot');
INSERT INTO CREW VALUES('10004','106','Pilot');
INSERT INTO CREW VALUES('10005','101','Pilot');
INSERT INTO CREW VALUES('10006','109','Pilot');
INSERT INTO CREW VALUES('10007','104','Pilot');
INSERT INTO CREW VALUES('10007','105','Copilot');
INSERT INTO CREW VALUES('10008','106','Pilot');
INSERT INTO CREW VALUES('10009','105','Pilot');
INSERT INTO CREW VALUES('10010','108','Pilot');
INSERT INTO CREW VALUES('10011','101','Pilot');
INSERT INTO CREW VALUES('10011','104','Copilot');
INSERT INTO CREW VALUES('10012','101','Pilot');
INSERT INTO CREW VALUES('10013','105','Pilot');
INSERT INTO CREW VALUES('10014','106','Pilot');
INSERT INTO CREW VALUES('10015','101','Copilot');
INSERT INTO CREW VALUES('10015','104','Pilot');
INSERT INTO CREW VALUES('10016','105','Copilot');
INSERT INTO CREW VALUES('10016','109','Pilot');
INSERT INTO CREW VALUES('10017','101','Pilot');
INSERT INTO CREW VALUES('10018','104','Copilot');
INSERT INTO CREW VALUES('10018','105','Pilot');

--CREATE DIMENSION TABLES AND FACT TABLE
CREATE TABLE TIMEDIM (
TIME_ID INT IDENTITY,
CHAR_DATE DATE,
MONTH INT,
YEAR INT);

CREATE TABLE PILOTDIM(
PILOT_ID INT IDENTITY,
EMP_NUM INT,
EMP_LNAME VARCHAR (25),
EMP_FNAME VARCHAR (25),
PIL_LICENSE VARCHAR (25),
PIL_RATINGS VARCHAR (25),
PIL_MED_TYPE VARCHAR (1),
PIL_MED_DATE DATETIME,
PIL_PT135_DATE DATETIME);

CREATE TABLE AIRCRAFTDIM(
AIRCRAFT_ID INT IDENTITY,
AC_NUMBER VARCHAR(20),
MOD_CODE VARCHAR(20),
AC_TTAF FLOAT (8),
AC_TTEL FLOAT (8),
AC_TTER FLOAT (8));

CREATE TABLE FACT_TABLE(
PILOT_ID INT,
AIRCRAFT_ID INT,
TIME_ID INT,
FUEL_USED FLOAT (8),
DISTANCE FLOAT (8),
REVENUE FLOAT (8));

--ADD CONSTRAINTS
ALTER TABLE TIMEDIM
ADD CONSTRAINT PK_TIMEDIM PRIMARY KEY (TIME_ID);

ALTER TABLE PILOTDIM
ADD CONSTRAINT PK_PILOTDIM PRIMARY KEY (PILOT_ID);

ALTER TABLE AIRCRAFTDIM
ADD CONSTRAINT PK_AIRCRAFTDIM PRIMARY KEY (AIRCRAFT_ID);

ALTER TABLE FACT_TABLE
ADD CONSTRAINT FK_FACT_PILOTDIM FOREIGN KEY (PILOT_ID) REFERENCES PILOTDIM (PILOT_ID);

ALTER TABLE FACT_TABLE
ADD CONSTRAINT FK_FACT_AIRCRAFTDIM FOREIGN KEY (AIRCRAFT_ID) REFERENCES AIRCRAFTDIM (AIRCRAFT_ID);

ALTER TABLE FACT_TABLE
ADD CONSTRAINT FK_FACT_TIMEDIM FOREIGN KEY (TIME_ID) REFERENCES TIMEDIM (TIME_ID);

--STAGING TABLE
CREATE TABLE STAGING(
PILOT_ID INT,
EMP_NUM INT,
EMP_LNAME VARCHAR(20),
EMP_FNAME VARCHAR(20),
AIRCRAFT_ID INT,
MOD_CODE VARCHAR (10),
AC_NUMBER VARCHAR (25),
TIME_ID INT,
CHAR_DATE DATE,
FUEL_USED FLOAT (8),
DISTANCE FLOAT (8),
REVENUE FLOAT (8));


