--	Part – A 
--1.	Retrieve all unique departments from the STUDENT table.
		SELECT DISTINCT STUDEPARTMENT
		FROM STUDENT
--2.	Insert a new student record into the STUDENT table.
		INSERT INTO STUDENT VALUES(9, 'Neha Singh', 'neha.singh@univ.edu', '9876543218', 'IT', '2003-09-20', 2021)
--(9, 'Neha Singh', 'neha.singh@univ.edu', '9876543218', 'IT', '2003-09-20', 2021)
--3.	Change the Email of student 'Raj Patel' to 'raj.p@univ.edu'. (STUDENT table)
		UPDATE STUDENT
		SET STUEMAIL = 'raj.p@univ.edu'
		WHERE STUNAME = 'RAJ PATEL'
--4.	Add a new column 'CGPA' with datatype DECIMAL(3,2) to the STUDENT table.
		ALTER TABLE STUDENT
		ADD CGPA DECIMAL(3,2)
--5.	Retrieve all courses whose CourseName starts with 'Data'. (COURSE table)
		SELECT COURSENAME
		FROM COURSE
		WHERE COURSENAME LIKE 'DATA%'
--6.	Retrieve all students whose Name contains 'Shah'. (STUDENT table)
		SELECT STUNAME
		FROM STUDENT
		WHERE STUNAME LIKE '%SHAH%'
--7.	Display all Faculty Names in UPPERCASE. (FACULTY table)
		SELECT UPPER(FACULTYNAME)
		FROM FACULTY
--8.	Find all faculty who joined after 2015. (FACULTY table)
		SELECT FACULTYNAME
		FROM FACULTY
		WHERE FACULTYJOININGDATE > '2015'
--9.	Find the SQUARE ROOT of Credits for the course 'Database Management Systems'. (COURSE table)
		SELECT SQRT(COURSECREDITS)
		FROM COURSE
		WHERE COURSENAME = 'DATABASE MANAGEMENT SYSTEMS'
--10.	Find the Current Date using SQL Server in-built function.
		SELECT GETDATE() AS CURRANT_DATE
--11.	Find the top 3 students who enrolled earliest (by EnrollmentYear). (STUDENT table)
		SELECT TOP 3 STUNAME
		FROM STUDENT
		ORDER BY STUENROLLMENTYEAR 
--12.	Find all enrollments that were made in the year 2022. (ENROLLMENT table)
		SELECT *
		FROM ENROLLMENT
		WHERE ENROLLMENTDATE BETWEEN ('2022-1-1') AND ('2022-12-30')
		
		
--13.	Find the number of courses offered by each department. (COURSE table)
		SELECT COURSEDEPARTMENT,COUNT(COURSEID) AS COURSE_ID
		FROM COURSE
		GROUP BY COURSEDEPARTMENT
--14.	Retrieve the CourseID which has more than 2 enrollments. (ENROLLMENT table)
		SELECT COURSEID
		FROM ENROLLMENT
		GROUP BY COURSEID
		HAVING COUNT(ENROLLMENTID) > 2
--15.	Retrieve all the student name with their enrollment status. (STUDENT & ENROLLMENT table)
		SELECT STUNAME,ENROLLMENTSTATUS
		FROM STUDENT
		JOIN ENROLLMENT
		ON STUDENT.STUDENTID = ENROLLMENT.STUDENTID
--16.	Select all student names with their enrolled course names. (STUDENT, COURSE, ENROLLMENT table)
		SELECT STUDENT.STUNAME,ENROLLMENT.ENROLLMENTID,COURSE.COURSENAME
		FROM STUDENT
		JOIN ENROLLMENT
		ON STUDENT.STUDENTID = ENROLLMENT.ENROLLMENTID
		JOIN COURSE
		ON COURSE.COURSEID = ENROLLMENT.COURSEID
--17.	Create a view called 'ActiveEnrollments' showing only active enrollments with student name and  course name. (STUDENT, COURSE, ENROLLMENT,  table)
		SELECT ENROLLMENT.ENROLLMENTID,STUDENT.STUNAME,COURSE.COURSENAME
		FROM ENROLLMENT
		JOIN STUDENT
		ON ENROLLMENT.STUDENTID = STUDENT.STUDENTID
		JOIN COURSE
		ON ENROLLMENT.COURSEID = COURSE.COURSEID
		WHERE ENROLLMENT.ENROLLMENTSTATUS = 'ACTIVE'
--18.	Retrieve the student’s name who is not enrol in any course using subquery. (STUDENT, ENROLLMENT TABLE)
		SELECT STUNAME
		FROM STUDENT S
		WHERE S.STUDENTID NOT IN(SELECT E.STUDENTID
							FROM ENROLLMENT E)
--19.	Display course name having second highest credit. (COURSE table)
		SELECT TOP 1 COURSENAME,COURSECREDITS
		FROM COURSE
		WHERE COURSECREDITS < (SELECT MAX(COURSECREDITS)
								FROM COURSE)
		ORDER BY COURSECREDITS DESC


--Part – B 
--20.	Retrieve all courses along with the total number of students enrolled. (COURSE, ENROLLMENT table)
		SELECT C.COURSENAME,COUNT(E.ENROLLMENTID) AS ENROOLMENT_ID
		FROM COURSE C
		LEFT JOIN ENROLLMENT E
		ON C.COURSEID = E.COURSEID
		GROUP BY C.COURSENAME
		 
--21.	Retrieve the total number of enrollments for each status, showing only statuses that have more than 2 enrollments. (ENROLLMENT table)
		SELECT ENROLLMENTSTATUS,COUNT(ENROLLMENTID) AS TOTAL_ENROLLS
		FROM ENROLLMENT
		GROUP BY ENROLLMENTSTATUS
		HAVING  COUNT(ENROLLMENTID) > 2
--22.	Retrieve all courses taught by 'Dr. Sheth' and order them by Credits. (FACULTY, COURSE, COURSE_ASSIGNMENT table)
		SELECT C.COURSENAME,C.COURSECREDITS 
		FROM COURSE C
		JOIN COURSE_ASSIGNMENT CE
		ON C.COURSEID = CE.COURSEID
		JOIN FACULTY F
		ON F.FACULTYID = CE.FACULTYID
		WHERE F.FACULTYNAME = 'Dr. Sheth'
		ORDER BY C.COURSECREDITS
--Part – C 
--23.	List all students who are enrolled in more than 3 courses. (STUDENT, ENROLLMENT table)
		SELECT S.STUNAME,COUNT(E.COURSEID)
		FROM STUDENT S
		JOIN ENROLLMENT E
		ON S.STUDENTID = E.STUDENTID
		GROUP BY S.STUNAME
		HAVING COUNT(E.COURSEID) > 3
--24.	Find students who have enrolled in both 'CS101' and 'CS201' Using Sub Query. (STUDENT, ENROLLMENT table)
		SELECT S.STUNAME
		FROM STUDENT S
		WHERE S.STUDENTID IN (SELECT E1.STUDENTID
								FROM ENROLLMENT E1
								WHERE E1.COURSEID = 'CS101' 
						AND S.STUDENTID IN (
								SELECT E2.STUDENTID
								FROM ENROLLMENT E2
								WHERE E2.COURSEID = 'CS201'))
--25.	Retrieve department-wise count of faculty members along with their average years of experience (calculate experience from JoiningDate). (Faculty table)
		SELECT FACULTYDEPARTMENT,COUNT(FACULTYID) AS NO_OF_FACULTY,
									AVG(YEAR(GETDATE()) - YEAR(FACULTYJOININGDATE)) AS EXPERIENCE_FACULTY
		FROM FACULTY
		GROUP BY FACULTYDEPARTMENT
	


