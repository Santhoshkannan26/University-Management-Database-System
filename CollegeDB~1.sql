-- University Database Management System in Oracle SQL

-- 1. Creating Tables with Relationships and Constraints
-- Table for Departments to store department details
CREATE TABLE Departments (
    DeptID NUMBER PRIMARY KEY, -- Unique identifier for departments
    DeptName VARCHAR2(50) NOT NULL -- Name of the department
);

-- Table for Faculty to store faculty details
CREATE TABLE Faculty (
    FacultyID NUMBER PRIMARY KEY, -- Unique identifier for faculty
    FacultyName VARCHAR2(100) NOT NULL, -- Name of the faculty member
    DeptID NUMBER, -- Department the faculty belongs to
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID) -- Foreign key constraint
);

-- Table for Students to store student details
CREATE TABLE Students (
    StudentID NUMBER PRIMARY KEY, -- Unique identifier for students
    StudentName VARCHAR2(100) NOT NULL, -- Name of the student
    DeptID NUMBER, -- Department the student belongs to
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID) -- Foreign key constraint
);

-- Table for Courses to store course details
CREATE TABLE Courses (
    CourseID NUMBER PRIMARY KEY, -- Unique identifier for courses
    CourseName VARCHAR2(100) NOT NULL, -- Name of the course
    DeptID NUMBER, -- Department offering the course
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID) -- Foreign key constraint
);

-- Table for Enrollments to track student enrollments in courses
CREATE TABLE Enrollments (
    EnrollmentID NUMBER PRIMARY KEY, -- Unique identifier for enrollments
    StudentID NUMBER, -- Student enrolling in the course
    CourseID NUMBER, -- Course the student is enrolling in
    EnrollmentDate DATE, -- Date of enrollment
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID), -- Foreign key constraint
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) -- Foreign key constraint
);

-- Table for Exams to store exam details
CREATE TABLE Exams (
    ExamID NUMBER PRIMARY KEY, -- Unique identifier for exams
    CourseID NUMBER, -- Course associated with the exam
    ExamDate DATE, -- Date of the exam
    MaxMarks NUMBER, -- Maximum marks for the exam
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) -- Foreign key constraint
);

-- 2. Inserting Sample Data
-- Sample data for Departments
INSERT INTO Departments VALUES (1, 'Computer Science');
INSERT INTO Departments VALUES (2, 'Mathematics');
INSERT INTO Departments VALUES (3, 'Physics');

-- Sample data for Faculty
INSERT INTO Faculty VALUES (1, 'Dr. Smith', 1);
INSERT INTO Faculty VALUES (2, 'Dr. Johnson', 2);
INSERT INTO Faculty VALUES (3, 'Dr. Lee', 3);

-- Sample data for Students
INSERT INTO Students VALUES (1, 'Alice', 1);
INSERT INTO Students VALUES (2, 'Bob', 2);
INSERT INTO Students VALUES (3, 'Charlie', 3);

-- Sample data for Courses
INSERT INTO Courses VALUES (1, 'Database Systems', 1);
INSERT INTO Courses VALUES (2, 'Linear Algebra', 2);
INSERT INTO Courses VALUES (3, 'Quantum Mechanics', 3);

-- Sample data for Enrollments
INSERT INTO Enrollments VALUES (1, 1, 1, SYSDATE);
INSERT INTO Enrollments VALUES (2, 2, 2, SYSDATE);
INSERT INTO Enrollments VALUES (3, 3, 3, SYSDATE);

-- Sample data for Exams
INSERT INTO Exams VALUES (1, 1, TO_DATE('2025-02-01', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (2, 2, TO_DATE('2025-02-02', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (3, 3, TO_DATE('2025-02-03', 'YYYY-MM-DD'), 100);

-- 3. PL/SQL Procedure Example
-- Procedure to add a new student
CREATE OR REPLACE PROCEDURE AddStudent(
    p_StudentID NUMBER, -- Student ID
    p_StudentName VARCHAR2, -- Student Name
    p_DeptID NUMBER -- Department ID
) IS
BEGIN
    INSERT INTO Students (StudentID, StudentName, DeptID)
    VALUES (p_StudentID, p_StudentName, p_DeptID);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding student: ' || SQLERRM); -- Error handling
END;
/

-- 4. PL/SQL Function Example
-- Function to retrieve department name by ID
CREATE OR REPLACE FUNCTION GetDepartmentName(p_DeptID NUMBER) RETURN VARCHAR2 IS
    v_DeptName VARCHAR2(50); -- Variable to hold department name
BEGIN
    SELECT DeptName INTO v_DeptName FROM Departments WHERE DeptID = p_DeptID;
    RETURN v_DeptName; -- Return the department name
END;
/

-- 5. Trigger Example
-- Trigger to convert student names to uppercase before insertion
CREATE OR REPLACE TRIGGER BeforeInsertStudent
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    :NEW.StudentName := UPPER(:NEW.StudentName); -- Convert name to uppercase
END;
/

-- 6. Materialized View Example
-- Materialized view to display student enrollments
CREATE MATERIALIZED VIEW EnrollmentsView AS
SELECT s.StudentName, c.CourseName, e.EnrollmentDate
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID;

-- 7. Indexing Example
-- Index to optimize searches by student name
CREATE INDEX idx_student_name ON Students(StudentName);

-- 8. Sequence Example
-- Sequence to auto-generate student IDs
CREATE SEQUENCE StudentSeq START WITH 1 INCREMENT BY 1;

-- 9. Cursor Example
-- Cursor to iterate over all student names
DECLARE
    CURSOR student_cur IS SELECT StudentName FROM Students;
    v_StudentName Students.StudentName%TYPE; -- Variable to hold student name
BEGIN
    OPEN student_cur;
    LOOP
        FETCH student_cur INTO v_StudentName;
        EXIT WHEN student_cur%NOTFOUND; -- Exit when no more records
        DBMS_OUTPUT.PUT_LINE('Student Name: ' || v_StudentName);
    END LOOP;
    CLOSE student_cur;
END;
/

-- 10. Analytical Function Example
-- Rank students by enrollment date
SELECT StudentID, RANK() OVER (ORDER BY EnrollmentDate) AS EnrollmentRank
FROM Enrollments;

-- 11. Hierarchical Query Example
-- Hierarchical query example for departments
SELECT LEVEL, DeptName
FROM Departments
CONNECT BY PRIOR DeptID = DeptID - 1;

-- 12. Partitioning Example
-- Partitioned table for enrollments based on enrollment date
CREATE TABLE PartitionedEnrollments (
    EnrollmentID NUMBER, -- Unique enrollment ID
    StudentID NUMBER, -- Student ID
    CourseID NUMBER, -- Course ID
    EnrollmentDate DATE -- Enrollment date
);
PARTITION BY RANGE (EnrollmentDate) (
    PARTITION p1 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD')), -- Partition 1
    PARTITION p2 VALUES LESS THAN (TO_DATE('2026-01-01', 'YYYY-MM-DD')) -- Partition 2
);

-- 13. Dynamic SQL Example
-- Example of dynamic SQL to insert a new department
DECLARE
    v_sql VARCHAR2(1000); -- Variable to hold SQL statement
BEGIN
    v_sql := 'INSERT INTO Departments (DeptID, DeptName) VALUES (4, ''Biology'')';
    EXECUTE IMMEDIATE v_sql; -- Execute the dynamic SQL
END;
/

-- 14. User Roles and Privileges
-- Creating a role and granting privileges
CREATE ROLE CollegeAdmin; -- Role for college administrators
GRANT SELECT, INSERT, UPDATE, DELETE ON Students TO CollegeAdmin; -- Grant privileges
GRANT CollegeAdmin TO User1; -- Assign role to a user

-- 15. Performance Tuning with Hints
-- Example query with a FULL table scan hint
SELECT /*+ FULL(Students) */ * FROM Students;

-- 16. NVL Function Example
-- Example of NVL function to handle null values
SELECT NVL(StudentName, 'Unknown') FROM Students;

-- 17. Cross Join Example
-- Cross join example to pair all students with all courses
SELECT s.StudentName, c.CourseName
FROM Students s
CROSS JOIN Courses c;

-- 18. Subqueries and Aggregate Functions
-- Subquery to count students in each department
SELECT DeptName, (SELECT COUNT(*) FROM Students WHERE Students.DeptID = Departments.DeptID) AS StudentCount
FROM Departments;


COMMIT ;

SELECT DeptID FROM Departments;

EXEC AddStudent(4, 'David', 1);

SELECT * FROM Students;

SELECT * FROM Departments;
SELECT * FROM Faculty;
SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Enrollments;
SELECT * FROM Exams;

CREATE VIEW StudentCourseFaculty AS
SELECT s.StudentName, c.CourseName, f.FacultyName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
JOIN Faculty f ON c.DeptID = f.DeptID;

CREATE INDEX idx_faculty_name ON Faculty(FacultyName);

CREATE ROLE FacultyRole;
GRANT SELECT, INSERT, UPDATE ON Enrollments TO FacultyRole;


ALTER TABLE Exams ADD CONSTRAINT check_max_marks CHECK (MaxMarks > 0);

SELECT s.StudentName, c.CourseName, f.FacultyName, e.EnrollmentDate
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
JOIN Faculty f ON c.DeptID = f.DeptID
ORDER BY e.EnrollmentDate;

SELECT DeptName, COUNT(StudentID) AS StudentCount
FROM Departments d
JOIN Students s ON d.DeptID = s.DeptID
GROUP BY DeptName;


SELECT StudentName, COUNT(CourseID) AS CourseCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY StudentName
HAVING COUNT(CourseID) > 1;



SELECT f.FacultyName, c.CourseName
FROM Faculty f
JOIN Courses c ON f.DeptID = c.DeptID
ORDER BY f.FacultyName;


CREATE OR REPLACE TRIGGER PreventDoubleEnrollment
BEFORE INSERT ON Enrollments
FOR EACH ROW
BEGIN
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM Enrollments
        WHERE StudentID = :NEW.StudentID
        AND CourseID = :NEW.CourseID;
        
        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Student is already enrolled in this course.');
        END IF;
    END;
END;


CREATE OR REPLACE TRIGGER ValidateDeptID
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM Departments
        WHERE DeptID = :NEW.DeptID;
        
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid Department ID.');
        END IF;
    END;
END;

CREATE OR REPLACE PROCEDURE AddStudent(
    p_StudentName VARCHAR2,
    p_DeptID NUMBER
) IS
BEGIN
    INSERT INTO Students (StudentID, StudentName, DeptID)
    VALUES (StudentSeq.NEXTVAL, p_StudentName, p_DeptID);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding student: ' || SQLERRM);
END;

CREATE OR REPLACE PROCEDURE CalculateTotalMarks(
    p_StudentID NUMBER
) IS
    v_total_marks NUMBER := 0;
BEGIN
    FOR record IN (SELECT e.CourseID, ex.MaxMarks
                   FROM Enrollments e
                   JOIN Exams ex ON e.CourseID = ex.CourseID
                   WHERE e.StudentID = p_StudentID) LOOP
        v_total_marks := v_total_marks + record.MaxMarks;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total Marks for Student ' || p_StudentID || ': ' || v_total_marks);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error calculating total marks: ' || SQLERRM);
END;


CREATE ROLE FacultyRole;
GRANT SELECT, INSERT, UPDATE ON Enrollments TO FacultyRole;
GRANT FacultyRole TO User1;














