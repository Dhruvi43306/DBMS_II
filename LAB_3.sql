--Lab-3	Advanced Stored Procedure
--	Part – A 
--1.	Create a stored procedure that accepts a date and returns all faculty members who joined on that date.
		CREATE OR ALTER PROCEDURE PR_JOINING_DATE
		@FDATE DATE
		AS
		BEGIN
			SELECT FACULTYNAME
			FROM FACULTY
			WHERE FACULTYJOININGDATE = @FDATE
		END
		EXEC PR_JOINING_DATE '2010-07-15'

--2.	Create a stored procedure for ENROLLMENT table where user enters either StudentID and returns EnrollmentID, EnrollmentDate, Grade, and Status.
		CREATE OR ALTER PROCEDURE PR_DETAIL
		@SID INT
		AS
		BEGIN
		SELECT ENROLLMENTID,ENROLLMENTDATE,GRADE,ENROLLMENTSTATUS
		FROM ENROLLMENT 
		WHERE STUDENTID = @SID
		END
		EXEC PR_DETAIL 2
--3.	Create a stored procedure that accepts two integers (min and max credits) and returns all courses whose credits fall between these values.
		CREATE OR ALTER PROCEDURE PR_INTEGER
		@MIN INT,
		@MAX INT
		AS 
		BEGIN
			SELECT *
			FROM COURSE
			WHERE COURSECREDITS BETWEEN @MIN AND @MAX
		END
		EXEC PR_INTEGER 1 , 3

--4.	Create a stored procedure that accepts Course Name and returns the list of students enrolled in that course.
		CREATE OR ALTER PROCEDURE PR_COURSE
		@CNAME VARCHAR(100)
		AS
		BEGIN
			SELECT S.STUNAME
			FROM STUDENT S
			JOIN ENROLLMENT E
			ON S.STUDENTID = E.STUDENTID
			JOIN COURSE C
			ON E.COURSEID = C.COURSEID
			WHERE COURSENAME = @CNAME
	END
			EXEC PR_COURSE 'DATA STRUCTURES'
--5.	Create a stored procedure that accepts Faculty Name and returns all course assignments.
		CREATE OR ALTER PROCEDURE PR_FACULTY
		@FNAME VARCHAR(100)
		AS
		BEGIN
			SELECT *
			FROM COURSE_ASSIGNMENT C
			JOIN FACULTY F
			ON C.FACULTYID = F.FACULTYID
			WHERE FACULTYNAME = @FNAME
			END
			EXEC PR_FACULTY 'Dr. Sheth'
--6.	Create a stored procedure that accepts Semester number and Year, and returns all course assignments with faculty and classroom details.
		CREATE OR ALTER PROCEDURE PR_CLASSROOM_DETIL
		@SEM INT,
		@CYEAR INT
		AS
		BEGIN
			SELECT F.FACULTYNAME,C.CLASSROOM
			FROM FACULTY F
			JOIN COURSE_ASSIGNMENT C
			ON F.FACULTYID = C.FACULTYID
			WHERE C.SEMESTER =@SEM AND C.YEAR = @CYEAR
		END	
		EXEC PR_CLASSROOM_DETIL 1,2024
--Part – B 
--**7.	Create a stored procedure that accepts the first letter of Status ('A', 'C', 'D') and returns enrollment details.
		CREATE OR ALTER PROCEDURE PR_ENROLLMENT
		@LETTER VARCHAR(1)
		AS
		BEGIN
			SELECT *
			FROM ENROLLMENT
			WHERE ENROLLMENTSTATUS LIKE @LETTER + '%'
	END
	EXEC PR_ENROLLMENT '[A,C,D]'
--8.	Create a stored procedure that accepts either Student Name OR Department Name and returns student data accordingly.
	CREATE OR ALTER PROCEDURE PR_STUDENT_DATA
	@STNAME VARCHAR(100) = NULL,
	@DEPTNAME VARCHAR(50) = NULL
	AS 
	BEGIN
		SELECT *
		FROM STUDENT
		WHERE STUNAME = @STNAME OR STUDEPARTMENT = @DEPTNAME
	END
	EXEC PR_STUDENT_DATA 'Raj Patel'
	
--9.	Create a stored procedure that accepts CourseID and returns all students enrolled grouped by enrollment status with counts.
		CREATE OR ALTER PROCEDURE PR_COURSE
		@CID VARCHAR(10),
		@count int OUT
		AS
		BEGIN
			SELECT @count = COUNT(*)
			FROM STUDENT S
			JOIN ENROLLMENT E
			ON S.STUDENTID = E.STUDENTID
			WHERE E.COURSEID = @CID
			GROUP BY E.ENROLLMENTSTATUS
			
		END
		DECLARE @CNT INT
		EXEC PR_COURSE 'CS101',@CNT OUTPUT
		SELECT @CNT
--Part – C 
--10.	Create a stored procedure that accepts a year as input and returns all courses assigned to faculty in that year with classroom details.
		CREATE OR ALTER PROCEDURE PR_CLASSROOM_DETAIL
		@CAYEAR INT

		AS
		BEGIN
			SELECT C.COURSENAME
			FROM COURSE C
			JOIN COURSE_ASSIGNMENT CE
			ON C.COURSEID = CE.COURSEID
			JOIN FACULTY F
			ON CE.FACULTYID = F.FACULTYID
			WHERE  CE.YEAR = @CAYEAR
		END
		EXEC PR_CLASSROOM_DETAIL 2024

--11.	Create a stored procedure that accepts From Date and To Date and returns all enrollments within that range with student and course details.
CREATE OR ALTER PROCEDURE PR_DATE
@FROMDATE DATE,
@TODATE DATE
AS
BEGIN 
	SELECT  S.STUDENTID,
        S.STUNAME,
        C.COURSEID,
        C.COURSENAME,
        E.ENROLLMENTDATE
	FROM STUDENT S
	JOIN ENROLLMENT E
	ON S.STUDENTID = E.STUDENTID
	JOIN COURSE C
	ON E.COURSEID = C.COURSEID
	WHERE E.ENROLLMENTDATE BETWEEN @FROMDATE AND @TODATE
END
EXEC PR_DATE '2022-01-05', '2024-12-31';

--12.Create a stored procedure that accepts FacultyID and calculates their total teaching load (sum of credits of all courses assigned).
CREATE OR ALTER PROCEDURE PR_FACULTY
@FID INT
AS
BEGIN
	SELECT SUM(C.COURSECREDITS)
	FROM COURSE C
	JOIN COURSE_ASSIGNMENT CE
	ON C.COURSEID = CE.COURSEID
	WHERE CE.FACULTYID = @FID
	
END

EXEC PR_FACULTY 101

