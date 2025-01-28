# University-Management-Database-System
A database management system for managing university operations, including student information, courses, faculty, and grades using Oracle SQL.
# University Database Management System in Oracle SQL

## Overview
The University Database Management System is a robust Oracle SQL project designed to manage various aspects of a university's operations, including departments, faculty, students, courses, enrollments, and exams. It showcases the use of SQL and PL/SQL for database design, data manipulation, and advanced database features.

## Features
1. **Table Creation with Constraints**: Implements tables with primary keys, foreign keys, and check constraints.
2. **Sample Data Insertion**: Populates tables with sample data for testing.
3. **PL/SQL Procedures and Functions**: Includes reusable procedures and functions for common tasks.
4. **Triggers**: Ensures data integrity with before-insert triggers.
5. **Views**: Provides logical views for simplified data access.
6. **Indexes**: Optimizes query performance with indexes.
7. **Sequences**: Automates ID generation for tables.
8. **Materialized Views**: Demonstrates advanced query optimization.
9. **Dynamic SQL**: Executes flexible SQL statements at runtime.
10. **User Roles and Privileges**: Manages user access with roles and grants.

## Project Structure
- **SQL Scripts**: Contains all SQL scripts for table creation, sample data insertion, procedures, functions, and triggers.
- **Documentation**: Includes ER diagrams, project reports, and detailed explanations.

## Installation and Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/university-management-db.git
   ```
2. Navigate to the project directory:
   ```bash
   cd university-management-db
   ```
3. Execute the SQL scripts in your Oracle SQL Developer or any compatible tool:
   - Start with table creation scripts.
   - Insert sample data.
   - Add procedures, functions, and triggers.

## Usage
- Use the provided SQL scripts to interact with the database.
- Explore the PL/SQL procedures and functions for automation.
- Test triggers by performing insert operations.
- Query views for simplified data retrieval.

## Example Queries
- Retrieve all students enrolled in a specific course:
  ```sql
  SELECT s.StudentName, c.CourseName
  FROM Students s
  JOIN Enrollments e ON s.StudentID = e.StudentID
  JOIN Courses c ON e.CourseID = c.CourseID;
  ```
- Get the department name for a given department ID:
  ```sql
  SELECT GetDepartmentName(1) FROM DUAL;
  ```

## Author
**Santhosh Kannan**

Feel free to reach out for any queries or suggestions!

## License
This project is licensed under the MIT License. See the LICENSE file for details.

