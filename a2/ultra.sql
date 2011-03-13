-- Query 1
DROP TABLE IF EXISTS query1 CASCADE;

CREATE TABLE query1 (
	billingNum INT NOT NULL,
	lastName TEXT NOT NULL,
	firstName TEXT NOT NULL,
	cID TEXT NOT NULL,
	address TEXT NOT NULL,
	numPatientsSent INT NOT NULL
);

-- Drop all previously generated views
DROP VIEW IF EXISTS maxPat CASCADE;
DROP VIEW IF EXISTS cPat CASCADE;

-- Generate number of patients for each (dID, cID) pair
CREATE VIEW cPat AS (
  SELECT dID, cID, COUNT(DISTINCT pID) AS nPat
  FROM Exam
  GROUP BY dID, cID
);

-- Select cID with max patients for each dID
CREATE VIEW maxPat AS (
  SELECT dID, cID, nPat
  FROM cPat
  WHERE (dID, nPAT) IN (
    -- Select max patients for each dID
    SELECT dID, MAX(nPat)
    FROM cPat
    GROUP BY dID
  )
);

-- Join tables and populate result
INSERT INTO query1 (
  SELECT billingNum, lastName, firstName, maxPat.cID AS cID,
         Clinic.address AS address, nPat AS numPatientsSent
  FROM Doctor, maxPat, Clinic
  WHERE maxPat.dID = Doctor.billingNum AND maxPat.cID = Clinic.cID
);

-- Query 2
DROP TABLE IF EXISTS query2 CASCADE;

CREATE TABLE query2 (
  year INT NOT NULL,
  age TEXT NOT NULL,
  numBirths INT NOT NULL,
  avgBirthWeight FLOAT
);

-- Drop all previously generated views
DROP VIEW IF EXISTS Mothers CASCADE;

-- Create view listing all babies and their mothers
CREATE VIEW Mothers AS (
  SELECT EXTRACT(YEAR FROM birthday) AS year,
         EXTRACT(YEAR FROM AGE(birthday, dob)) AS age, weight
  FROM Birth, Patient
  WHERE Birth.mother = Patient.OHIP
);

-- Insert data for all mothers with age < 30
INSERT INTO query2 (
  SELECT year, '<30' AS age, COUNT(*) AS numBirths,
         AVG(weight) AS avgBirthWeight
  FROM (SELECT * FROM Mothers WHERE age < 30) As M
  GROUP BY year
);

-- Insert data for all mothers with age < 30
INSERT INTO query2 (
  SELECT year, '30-35' AS age, COUNT(*) AS numBirths,
         AVG(weight) AS avgBirthWeight
  FROM (SELECT * FROM Mothers WHERE age >= 30 AND age <= 35) As M
  GROUP BY year
);

-- Insert data for all mothers with age > 35
INSERT INTO query2 (
  SELECT year, '>35' AS age, COUNT(*) AS numBirths,
         AVG(weight) AS avgBirthWeight
  FROM (SELECT * FROM Mothers WHERE age > 35) As M
  GROUP BY year
);

-- Query 3
DROP TABLE IF EXISTS query3 CASCADE;

CREATE TABLE query3 (
  ID INT NOT NULL,
  lastName TEXT NOT NULL,
  firstName TEXT NOT NULL,
  maxExams INT NOT NULL,
  minExams INT NOT NULL,
  avgExams FLOAT NOT NULL
);

-- Drop all previously generated views
DROP VIEW IF EXISTS techLoads, leastMax CASCADE;
DROP VIEW IF EXISTS maxLoad CASCADE;
DROP VIEW IF EXISTS load CASCADE;

-- Generate number of tests done every day by each technician
CREATE VIEW load AS (
  SELECT tID, EXTRACT(DAY from schedule) AS day, COUNT(eID) AS exams
  FROM Exam
  GROUP BY tID, day
);

-- Select max workload for each technician
CREATE VIEW maxLoad AS (
  SELECT tID, MAX(exams) AS exams
  FROM load
  GROUP BY tID
);

-- Select technician(s) with least max load
CREATE VIEW leastMax AS (
  SELECT tID
  FROM maxLoad
  WHERE exams = (
    -- Select the least load from maxLoad
    SELECT MIN(exams)
    FROM maxLoad
  )
);

-- Select all the other details for that technician
CREATE VIEW techLoads AS (
  SELECT tID AS ID, MAX(exams) AS maxExams, MIN(exams) AS minExams, 
  AVG(exams) AS avgExams
  FROM leastMax NATURAL JOIN load
  GROUP BY tID
);

INSERT INTO query3 (
  SELECT ID, lastName, firstname, maxExams, minExams, avgExams
  FROM techLoads NATURAL JOIN technician
);

-- Query 4
DROP TABLE IF EXISTS query4 CASCADE;

CREATE TABLE query4 (
	OHIP INT NOT NULL,
	lastName TEXT NOT NULL,
	firstName TEXT NOT NULL,
	start DATE NOT NULL
);

-- Drop all previously generated views
DROP VIEW IF EXISTS firstTen, nonRecorded CASCADE;

-- Get all birth that happened within first 10 months 
CREATE VIEW firstTen AS (
  SELECT mother AS pID, prStart AS start
  FROM Birth
  WHERE EXTRACT(MONTH FROM AGE(birthday, prStart)) <= 10
);

CREATE VIEW nonRecorded(OHIP, start) AS (
  (SELECT * FROM Pregnancy)
  EXCEPT
  (SELECT * FROM firstTen)
);

INSERT INTO query4 (
  SELECT OHIP, lastName, firstName, start
  FROM nonRecorded NATURAL JOIN Patient
);

-- Query 5
DROP TABLE IF EXISTS query5 CASCADE;

CREATE TABLE query5 (
	cID TEXT NOT NULL,
	tID INT NOT NULL,
	mID INT NOT NULL,
	maxDiff FLOAT NOT NULL
);

-- DROP all previously generated views
DROP VIEW IF EXISTS bigError CASCADE; 
DROP VIEW IF EXISTS avgResult, resultRange CASCADE; 
DROP VIEW IF EXISTS maxResult, minResult CASCADE; 

-- Select Minimum value for each (exam, measurement)
CREATE VIEW minResult AS (
  SELECT eID, mID, MIN(VALUE) AS minVal
  FROM Result
  GROUP BY eID, mID
);

-- Select Maximum value for each (exam, measurement)
CREATE VIEW maxResult AS (
  SELECT eID, mID, MAX(VALUE) AS maxVal
  FROM Result
  GROUP BY eID, mID
);

-- Generate range of result (Max - Min) for each (exam, measurement)
CREATE VIEW resultRange AS (
  SELECT eID, mID, (maxVal - minVal) AS maxDiff
  FROM minResult NATURAL JOIN maxResult
);

-- Generate average results for each measurement type
CREATE VIEW avgResult AS (
  SELECT mID, AVG(maxDiff) AS avgVal
  FROM resultRange
  GROUP BY mID
);

-- Select only those results that have error greater than average
CREATE VIEW bigError AS (
  SELECT eID, mID, maxDiff
  FROM resultRange NATURAL JOIN avgResult
  WHERE maxDiff > avgVal
);

-- Join and populate results
INSERT INTO query5 (
  SELECT cID, tID, mID, maxDiff
  FROM Exam NATURAL JOIN bigError
);
