--Part – A
--1.Create a cursor Course_Cursor to fetch all rows from COURSE table and display them.
DECLARE @CID VARCHAR(10),@CNAME VARCHAR(100),@CCREDITS INT ,@CDEPT VARCHAR(50),@CSEM INT
	DECLARE Course_Cursor CURSOR 
	FOR SELECT * FROM COURSE

	OPEN Course_Cursor

	FETCH NEXT FROM Course_Cursor INTO @CID,@CNAME,@CCREDITS,@CDEPT,@CSEM

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @CID +' '+ @CNAME +' '+ CAST(@CCREDITS AS VARCHAR) +' '+ @CDEPT +' '+ CAST(@CSEM AS VARCHAR)
		FETCH NEXT FROM Course_Cursor
		INTO @CID,@CNAME,@CCREDITS,@CDEPT,@CSEM
	END

	CLOSE Course_Cursor
	DEALLOCATE Course_Cursor
--2.
--Create a cursor Student_Cursor_Fetch to fetch records in form of StudentID_StudentName (Example: 1_Raj Patel).
	DECLARE @SID INT ,@SNAME VARCHAR(100)

	DECLARE  Student_Cursor_Fetch CURSOR
	FOR SELECT StudentID,StuName FROM STUDENT

	OPEN Student_Cursor_Fetch

	FETCH NEXT FROM Student_Cursor_Fetch INTO @SID,@SNAME
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT CAST(@SID AS VARCHAR)+'_'+@SNAME
		FETCH NEXT FROM Student_Cursor_Fetch INTO @SID,@SNAME
	END

	CLOSE Student_Cursor_Fetch
	DEALLOCATE Student_Cursor_Fetch

--3.Create a cursor to find and display all courses with Credits greater than 3.
	DECLARE @CUNAME VARCHAR(100),@CREDITS INT

	DECLARE CURSOR_COURSE CURSOR
	FOR SELECT CourseName,CourseCredits 
	FROM COURSE
	WHERE CourseCredits  > 3

	OPEN CURSOR_COURSE

	FETCH NEXT FROM CURSOR_COURSE
	INTO @CUNAME,@CREDITS

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @CUNAME +' '+ CAST(@CREDITS AS VARCHAR)
		FETCH NEXT FROM CURSOR_COURSE INTO @CUNAME,@CREDITS
	END

	CLOSE CURSOR_COURSE
	DEALLOCATE CURSOR_COURSE

--4.Create a cursor to display all students who enrolled in year 2021 or later.
	DECLARE @SUNAME VARCHAR(100),@STUENROLL INT
	DECLARE CURSOR_STU CURSOR
	FOR SELECT StuName , STUENROLLMENTYEAR
		FROM STUDENT
		WHERE StuEnrollmentYear >= 2021

	OPEN CURSOR_STU

	FETCH NEXT FROM CURSOR_STU INTO @SUNAME,@STUENROLL
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @SUNAME + ' ' + CAST(@STUENROLL AS VARCHAR)
		FETCH NEXT FROM CURSOR_STU INTO @SUNAME,@STUENROLL
	END

	CLOSE CURSOR_STU
	DEALLOCATE CURSOR_STU
--5.Create a cursor Course_CursorUpdate that retrieves all courses and increases Credits by 1 for courses with Credits less than 4.
	DECLARE @CN VARCHAR(100),@CE INT

	DECLARE Course_CursorUpdate CURSOR 
	FOR SELECT CourseName,CourseCredits
		FROM COURSE

	OPEN Course_CursorUpdate

	FETCH NEXT FROM Course_CursorUpdate INTO @CN,@CE

	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE COURSE
		SET CourseCredits = CourseCredits +1
		WHERE CourseCredits < 4
		--PRINT @CN + '' + CAST(@CE AS VARCHAR)
		FETCH NEXT FROM Course_CursorUpdate INTO @CN,@CE

	END

	CLOSE Course_CursorUpdate
	DEALLOCATE Course_CursorUpdate

	SELECT * FROM COURSE
--6.
--Create a Cursor to fetch Student Name with Course Name (Example: Raj Patel is enrolled in Database Management System)
	DECLARE @STUNAME VARCHAR(100),@CNE VARCHAR(100)

	DECLARE CURSOR_STUDENT CURSOR
	FOR SELECT C.CourseName,STU.StuName
		 FROM STUDENT STU
		 JOIN ENROLLMENT E
		 ON STU.STUDENTID = E.STUDENTID
		 JOIN COURSE C
		 ON C.CourseID = E.CourseID
	OPEN CURSOR_STUDENT
	FETCH NEXT FROM CURSOR_STUDENT INTO @STUNAME,@CNE

	 

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @STUNAME + ' ' + 'IS enrolled in' + ' ' + @CNE
			FETCH NEXT FROM CURSOR_STUDENT INTO @STUNAME,@CNE

	END

	CLOSE CURSOR_STUDENT
	DEALLOCATE CURSOR_STUDENT

--7.Create a cursor to insert data into new table if student belong to ‘CSE’ department. (create new table CSEStudent with relevant columns)
	CREATE TABLE CSEStudent(StudentID INT,StuName VARCHAR(100),StuEmail VARCHAR(100),StuPhone VARCHAR(15),StuDepartment VARCHAR(50),StuDateOfBirth DATE,StuEnrollmentYear INT)
	
	DECLARE @SDEPT VARCHAR(50),@STUID INT,@SN VARCHAR(100),@SE VARCHAR(100), @SD VARCHAR(50),@SDB DATE,@SEY INT
	
	DECLARE CURSOR_SU CURSOR
	FOR SELECT *
		FROM STUDENT
		WHERE StuDepartment= 'CSE'

	OPEN CURSOR_SU 

	FETCH NEXT FROM CURSOR_SU INTO @SDEPT,@STUID,@SN ,@SE , @SD ,@SDB,@SEY

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO CSEStudent VALUES(@STUID,@SN ,@SE , @SD ,@SDB,@SEY) 
	FETCH NEXT FROM CURSOR_SU INTO @SDEPT,@STUID,@SN ,@SE , @SD ,@SDB,@SEY
	END

	CLOSE CURSOR_SU
	DEALLOCATE CURSOR_SU

--Part – B
--8.Create a cursor to update all NULL grades to 'F' for enrollments with Status 'Completed'
DECLARE @EnrollmentID INT

DECLARE C_COURSE CURSOR
FOR 
SELECT EnrollmentID
FROM ENROLLMENT
WHERE EnrollmentStatus = 'Completed'
AND Grade IS NULL

OPEN C_COURSE

FETCH NEXT FROM C_COURSE INTO @EnrollmentID

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE ENROLLMENT
    SET Grade = 'F'
    WHERE EnrollmentID = @EnrollmentID

    FETCH NEXT FROM C_COURSE INTO @EnrollmentID
END

CLOSE C_COURSE
DEALLOCATE C_COURSE

--9.
--Cursor to show Faculty with Course they teach (EX: Dr. Sheth teaches Data structure)
	DECLARE @FUNAME VARCHAR(100),@COURSENAME VARCHAR(100)

	DECLARE CURSOR_TECH CURSOR
	FOR SELECT FU.FacultyName,C.CourseName
		FROM FACULTY FU
		JOIN COURSE_ASSIGNMENT CE
		ON FU.FACULTYID = CE.FACULTYID
		JOIN CURSE C
		ON CE.CourseID = C.CourseID

		OPEN CURSOR_TECH

		FETCH NEXT FROM CURSOR_TECH INTO @FUNAME,@COURSENAME

		WHILE @@FETCH_STATUS = 0
		BEGIN 
			PRINT @FUNAME + 'TEACHES' + ' ' + @COURSENAME
		END

		CLOSE CURSOR_TECH
		DEALLOCATE CURSOR_TECH

--Part – C
--10.Cursor to calculate total credits per student (Example: Raj Patel has total credits = 15)

DECLARE @COURSECREDIT INT,@STUDENTNAME VARCHAR(100)

DECLARE CURSOR_GRUP CURSOR
FOR SELECT S.StuName,SUM(COE.CourseCredits)
	FROM STUDENT S
	JOIN ENROLLMENT ET
	ON  S.StudentID = ET.StudentID
	JOIN COURSE CUE
	ON CUE.CourseID = ET.CourseID
	GROUP BY StudentID

OPEN CURSOR_GRUP

FETCH NEXT FROM CURSOR_GRUP INTO @COURSECREDIT,@STUDENTNAME

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @STUDENTNAME + 'has total credits = ' + CAST(@COURSECREDIT AS VARCHAR)
	FETCH NEXT FROM CURSOR_GRUP INTO @COURSECREDIT,@STUDENTNAME
END

CLOSE CURSOR_GRUP
DEALLOCATE URSOR_GRUP
