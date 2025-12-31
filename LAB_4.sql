--Part-A
--1.Write a scalar function to print "Welcome to DBMS Lab".
CREATE OR ALTER FUNCTION FN_WELCOME()
RETURNS VARCHAR(50)
AS
	BEGIN
		RETURN 'WELCOME TO DBMS-II'
	END
SELECT DBO.FN_WELCOME() AS WELCOME_MESSG
--2.Write a scalar function to calculate simple interest.
	CREATE OR ALTER FUNCTION FN_SIMPLE(
	@P DECIMAL(5,2),
	@R DECIMAL(5,2),
	@T DECIMAL(5,2)
	)
	RETURNS DECIMAL(5,2)
	AS
		BEGIN
			DECLARE @RESULT DECIMAL
				SET @RESULT = @P*@R*@T/100
		RETURN @RESULT
		END
SELECT DBO.FN_SIMPLE(10,10,1) AS SIMPLE_INTREST 
--3.Function to Get Difference in Days Between Two Given Dates
	CREATE OR ALTER FUNCTION FN_DATE(@FDATE DATE,@LDATE DATE)
	RETURNS INT
	AS 
		BEGIN
			RETURN DATEDIFF(DAY,@FDATE,@LDATE)
		END
SELECT DBO.FN_DATE('2024-01-01','2025-01-01') AS CURRNT_DATE

--4.Write a scalar function which returns the sum of Credits for two given CourseIDs.
	CREATE OR ALTER FUNCTION FN_CREDIT_SUM(@CID1 VARCHAR(10),@CID2 VARCHAR(10))
	RETURNS INT
		AS
			BEGIN
				RETURN (SELECT SUM(COURSECREDITS) FROM COURSE WHERE COURSEID = @CID1 OR COURSEID = @CID2)
			END
SELECT DBO.FN_CREDIT_SUM('CS101','IT101')
--5.Write a function to check whether the given number is ODD or EVEN.
	CREATE OR ALTER FUNCTION FN_ODD_EVEN(@N INT)
	RETURNS VARCHAR(10)
	AS
		BEGIN
			IF(@N % 2 = 0)
				RETURN 'EVEN'
			RETURN 'ODD'
		END
SELECT DBO.FN_ODD_EVEN(4)
--6.Write a function to print number from 1 to N. (Using while loop)
	CREATE OR ALTER FUNCTION FN_NUMBER(@N INT)
	RETURNS VARCHAR(100)
	AS
		BEGIN
			DECLARE @MSG VARCHAR(200),@COUNT INT
			SET @MSG = ''
			SET @COUNT = 1
			WHILE(@COUNT <= @N)
				BEGIN
					SET @MSG = @MSG + ' '+CAST(@COUNT AS VARCHAR(50))
					SET @COUNT = @COUNT + 1
				END
			RETURN @MSG
		END
SELECT DBO.FN_NUMBER(10)
--7.Write a scalar function to calculate factorial of total credits for a given CourseID.
	CREATE OR ALTER FUNCTION FN_FACTORIAL(@CID VARCHAR(10))
	RETURNS INT
		AS
		BEGIN
			DECLARE @FACT INT,@I INT,@CREDIT INT
			SET @FACT = 1
			SET @I = 1
			SET @CREDIT = (SELECT COURSECREDITS
							FROM COURSE
							WHERE COURSEID = @CID)
			WHILE(@I <= @CREDIT)
				BEGIN
				SET @FACT = @FACT*@I
				SET @I = @I + 1
				END
			RETURN @FACT
		END
SELECT DBO.FN_FACTORIAL('CS101') AS FECTORIAL
					
--8.Write a scalar function to check whether a given EnrollmentYear is in the past, current or future (Case statement)
	CREATE OR ALTER FUNCTION FN_YEAR(@EYEAR INT)
	RETURNS VARCHAR(50)
	AS
		BEGIN
			DECLARE @RESULT VARCHAR(50)
			SET @RESULT = CASE
				WHEN @EYEAR < YEAR(GETDATE()) THEN 'PAST'
				WHEN @EYEAR = YEAR(GETDATE()) THEN 'CURRENT'
				ELSE 'FUTURE'
			END
			RETURN @RESULT
		END

	SELECT DBO.FN_YEAR(2024) AS YEAR
			
--9.Write a table-valued function that returns details of students whose names start with a given letter.
	CREATE OR ALTER FUNCTION FN_LETTER(@L VARCHAR(1))
	RETURNS TABLE
	AS
		RETURN(SELECT STUNAME FROM STUDENT WHERE STUNAME LIKE @L + '%')
	SELECT * FROM DBO.FN_LETTER('K')
--10.Write a table-valued function that returns unique department names from the STUDENT table.
	CREATE OR ALTER FUNCTION FN_UNIQE_DEPT()
	RETURNS TABLE
	AS
		RETURN(SELECT DISTINCT StuDepartment FROM STUDENT)
	SELECT * FROM DBO.FN_UNIQE_DEPT()
--Part-B
--11.Write a scalar function that calculates age in years given a DateOfBirth.
	CREATE OR ALTER FUNCTION FN_CALCULATE_AGE(@DOB DATE)
	RETURNS INT
	AS
		BEGIN
			RETURN DATEDIFF(YEAR,@DOB,GETDATE())
		END
SELECT DBO.FN_CALCULATE_AGE('2007-07-27') AS AGE
	--OR
CREATE OR ALTER FUNCTION FN_AGE (@DOB DATE)
RETURNS INT
AS
BEGIN
    DECLARE @AGE INT

    -- Step 1: Calculate year difference
    SET @AGE = DATEDIFF(YEAR, @DOB, GETDATE())

    -- Step 2: Check if birthday has not occurred yet this year
    IF (
        MONTH(@DOB) > MONTH(GETDATE())
        OR
        (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
       )
    BEGIN
        SET @AGE = @AGE - 1
    END

    -- Step 3: Return age
    RETURN @AGE
END

SELECT DBO.FN_AGE('2007-07-27') AS AGE
--12.Write a scalar function to check whether given number is palindrome or not.
	CREATE OR ALTER FUNCTION FN_PALINGDRON(@N INT)
	RETURNS VARCHAR(50)
	AS
		BEGIN
			DECLARE @ISPALINGDRONE INT,@SUM INT,@REM INT,@MSG VARCHAR(50)
			SET @ISPALINGDRONE = @N
			SET @SUM = 0
			WHILE(@N != 0)
			BEGIN
				SET @REM = @N % 10;
				SET @SUM = @SUM*10+@REM
				SET @N = @N / 10
			END
			IF(@SUM = @ISPALINGDRONE)
				SET @MSG = 'NUMBER IS PALINGDRONE'
			ELSE
				SET @MSG = 'NUMBER IS NOT PALINGDRONE'
			RETURN @MSG
		END
SELECT DBO.FN_PALINGDRON(121) AS PALINGDRONE_NUM

--13.Write a scalar function to calculate the sum of Credits for all courses in the 'CSE' department.
	CREATE OR ALTER FUNCTION FN_SUM_DEPT(@DEPT VARCHAR(50))
	RETURNS INT
	AS
		BEGIN
			RETURN(SELECT SUM(CourseCredits)
			FROM COURSE
			WHERE CourseDepartment = @DEPT)
		END
SELECT DBO.FN_SUM_DEPT('CSE') AS SUM_CREDIT
--14.Write a table-valued function that returns all courses taught by faculty with a specific designation.
	CREATE OR ALTER FUNCTION FN_COURSE_DEGSINATION(@FDESG VARCHAR(50))
	RETURNS TABLE
	AS
		RETURN(SELECT 
		  C.CourseID,
        C.CourseName,
        C.CourseCredits,
        F.FacultyID,
        F.FacultyName,
        F.FacultyDesignation
		FROM COURSE C
		JOIN COURSE_ASSIGNMENT CE
		ON C.COURSEID = CE.COURSEID
		JOIN FACULTY F
		ON CE.FACULTYID = F.FACULTYID
		WHERE F.FACULTYDESIGNATION = @FDESG)
	SELECT * FROM DBO.FN_COURSE_DEGSINATION('Professor')

--Part - C
--15.Write a scalar function that accepts StudentID and returns their total enrolled credits (sum of credits from all active enrollments).
CREATE OR ALTER FUNCTION FN_ENROLLED_CREDIT(@SID INT)
RETURNS INT
AS
	BEGIN
		RETURN(SELECT SUM(C.COURSECREDITS)
		FROM ENROLLMENT E
		JOIN COURSE C
		ON E.COURSEID = C.COURSEID
		WHERE E.STUDENTID = @SID)
	END
SELECT DBO.FN_ENROLLED_CREDIT(1) AS SUM_CREDIT
--16.Write a scalar function that accepts two dates (joining date range) and returns the count of faculty who joined in that period.
CREATE OR ALTER FUNCTION FN_JOINED_DATE(@JOINDATE1 DATE,@JOINDATE2 DATE)
RETURNS INT
AS
	BEGIN
		RETURN(SELECT COUNT(*)
				FROM FACULTY
				WHERE FacultyJoiningDate  BETWEEN @JOINDATE1 AND @JOINDATE2)
	END
SELECT DBO.FN_JOINED_DATE('2010-07-15','2012-08-20') AS COUNT_FACULTY