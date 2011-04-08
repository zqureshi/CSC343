DROP SCHEMA IF EXISTS Ultra CASCADE;
CREATE SCHEMA Ultra;
SET SEARCH_PATH TO Ultra;

-- A medical clinic with a clinic ID, address and phone number.
CREATE TABLE Clinic (
	cID TEXT,
	address TEXT NOT NULL,
	phone TEXT NOT NULL,
	PRIMARY KEY (cID)
);

-- A technician with an ID, last name, first name and email address.
CREATE TABLE Technician (
	ID INT,
	lastName TEXT NOT NULL,
	firstName TEXT NOT NULL,
	email TEXT,
	PRIMARY KEY(ID)
);

-- A doctor, with an OHIP billing number, address and phone number.
CREATE TABLE Doctor (
	billingNum INT,
	lastName TEXT NOT NULL,
	firstName TEXT NOT NULL,
	address TEXT NOT NULL,
	phone TEXT NOT NULL,
	PRIMARY KEY (BillingNum)
);

-- A patient with an OHIP number, last and first name, date of birth, address,
-- and physician (their general practitioner).
CREATE TABLE Patient (
	OHIP INT,
	lastName TEXT NOT NULL,
	firstName TEXT NOT NULL,
	dob DATE NOT NULL,
	address TEXT,
	physician INT,
	PRIMARY KEY(OHIP),
	FOREIGN KEY (physician) REFERENCES Doctor(billingNum)
);

-- A medical examination, with an examination ID, patient on whom
-- the examination was performed, clinic where it happened, 
-- technician who performed the exam, doctor who ordered it, and
-- timestamp.
CREATE TABLE Exam (
	eID INT,
	pID INT NOT NULL,
	cID TEXT NOT NULL,
	tID INT NOT NULL,
	dID INT NOT NULL,
	schedule TIMESTAMP NOT NULL,
	PRIMARY KEY (eID),
	FOREIGN KEY (pID) REFERENCES Patient(OHIP),
	FOREIGN KEY (cID) REFERENCES Clinic(cID),
	FOREIGN KEY (tID) REFERENCES Technician(ID),
	FOREIGN KEY (dID) REFERENCES Doctor(billingNum)	
);

-- A measurement that may be taken during a medical exam, with
-- a measurement ID, name, and the units in which it is measured.
CREATE TABLE Measurement (
	mID INT,
	name TEXT NOT NULL,
	units TEXT NOT NULL,
	PRIMARY KEY (mID)
);

-- The result of a measurement, with an exam ID (the medical exam
-- which this measurement result was part of), measurement (the
-- particular measurement that was made), repetition number (1 if
-- this is the first repetition of this measurement during this
-- exam, 2 if it is the second, and so on), and value (the actual
-- number).
CREATE TABLE Result (
	eID INT,
	mID INT,
	repetitionNum INT,
	value FLOAT NOT NULL,
	PRIMARY KEY (eID, mID, repetitionNum),
	FOREIGN KEY (eID) REFERENCES Exam(eID),
	FOREIGN KEY (mID) REFERENCES Measurement(mID)	
);

-- A pregnancy, with a patient ID (the patient who is pregnant), and
-- start date (when the pregnancy was deteremined to have begun).
CREATE TABLE Pregnancy (
	pID INT,
	start DATE,
	PRIMARY KEY (pID, start),
	FOREIGN KEY (pID) REFERENCES Patient(OHIP)
);

-- A birth, with a mother (the woman who gave birth), pregnancy start date, 
-- birthday (the date of the birth), birth weight of the baby in grams,
-- and attending phsyician.
CREATE TABLE Birth (
	mother INT,
	prStart DATE,DROP VIEW IF EXISTS A1 , A2 CASCADE;

	birthday DATE NOT NULL,
	weight FLOAT NOT NULL,
	attending INT,
	PRIMARY KEY (mother, prStart),
	FOREIGN KEY (mother) REFERENCES Patient(OHIP),
	FOREIGN KEY (mother, prStart) REFERENCES Pregnancy (pID, start),
	FOREIGN KEY (attending) REFERENCES Doctor(billingNum)
);
