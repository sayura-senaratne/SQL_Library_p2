# Library Management System - SQL Project 2

## Project Overview

**Project Title**: Library Management System  
**Platform**: MS SQL Server  

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/sayura-senaratne/SQL_Library_p2/blob/main/Lib_pic.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/sayura-senaratne/SQL_Library_p2/blob/main/ERD.png)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_db;

-- Creating branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
	branch_id	VARCHAR(25) PRIMARY KEY,
	manager_id	VARCHAR(10),
	branch_address	VARCHAR(55),
	contact_no VARCHAR(10)
);

 ALTER TABLE branch
 ALTER COLUMN contact_no VARCHAR(15);


-- Creating employees Table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees 
 (
	emp_id	VARCHAR(10) PRIMARY KEY,
	emp_name  VARCHAR(25),
	position  VARCHAR(15),
	salary	INT,
	branch_id VARCHAR(25) --FK
);

-- Creating books Table
DROP TABLE IF EXISTS books;
CREATE TABLE books
 (
	isbn VARCHAR(25) PRIMARY KEY,	
	book_title	VARCHAR(75),
	category	VARCHAR(15),
	rental_price	FLOAT(10),
	status	VARCHAR(15),
	author	VARCHAR(35),
	publisher VARCHAR(55)
 );
    
 ALTER TABLE books
 ALTER COLUMN category VARCHAR(20);

 --Creating members Table
 DROP TABLE IF EXISTS members;
 CREATE TABLE members
  (
	member_id	VARCHAR(20) PRIMARY KEY,
	member_name	VARCHAR(35),
	member_address	VARCHAR(75),
	reg_date DATE
  );

 -- Creating issued_status Table
 DROP TABLE IF EXISTS issued_status;
 CREATE TABLE issued_status
  (
	issued_id VARCHAR(10) PRIMARY KEY,	--FK
	issued_member_id VARCHAR(20),
	issued_book_name VARCHAR(75),
	issued_date	DATE,
	issued_book_isbn VARCHAR(25),  --FK
	issued_emp_id VARCHAR(10) --FK
  );

  --Creating return_status Table
  DROP TABLE IF EXISTS return_status;
  CREATE TABLE return_status
   (
	return_id	VARCHAR(10) PRIMARY KEY,
	issued_id	VARCHAR(10),
	return_book_name	VARCHAR(75),
	return_date	DATE,
	return_book_isbn VARCHAR(25)
   );

   -- FOREIGN KEY 
 ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books 
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees 
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_return_issued
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_return_books
FOREIGN KEY (return_book_isbn)
REFERENCES books(isbn);


 -- Veryfying the existence of constraints
  SELECT 
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    cp.name AS ParentColumn,
    tr.name AS ReferencedTable,
    cr.name AS ReferencedColumn
FROM 
    sys.foreign_keys AS fk
INNER JOIN 
    sys.foreign_key_columns AS fkc 
    ON fk.object_id = fkc.constraint_object_id
INNER JOIN 
    sys.tables AS tp 
    ON fk.parent_object_id = tp.object_id
INNER JOIN 
    sys.columns AS cp 
    ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
INNER JOIN 
    sys.tables AS tr 
    ON fk.referenced_object_id = tr.object_id
INNER JOIN 
    sys.columns AS cr 
    ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
ORDER BY 
    tp.name, fk.name;
```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books (isbn, book_title, category, rental_price, status, author,  publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT * FROM books;
```

**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address='4111 Walnut St'
WHERE member_id='C103';

SELECT * FROM members;
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE issued_id='IS121';

SELECT * FROM issued_status;
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT issued_book_name FROM issued_status
WHERE issued_emp_id='E101';
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT COUNT(issued_member_id) AS issued_count, issued_member_id FROM issued_status
GROUP BY  issued_member_id
HAVING COUNT(issued_member_id)>1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
SELECT 
    b.isbn, 
    b.book_title, 
    COUNT(ist.issued_id) AS issue_count
INTO book_issued_cnt
FROM issued_status AS ist
JOIN books AS b
    ON ist.issued_book_isbn = b.isbn
GROUP BY 
    b.isbn, 
    b.book_title;

SELECT * FROM book_issued_cnt;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT 
    b.category,
    SUM(b.rental_price) AS rental_income,
    COUNT(*) issued_book_count
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY category;
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
SELECT * FROM members
WHERE reg_date >= DATEADD(DAY, -180, GETDATE());
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
 SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
SELECT * 
INTO expensive_books
FROM books
WHERE rental_price > 7.00;

SELECT * FROM expensive_books;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    -- rs.return_date,
    DATEDIFF(DAY, ist.issued_date, GETDATE()) AS over_dues_days
FROM issued_status AS ist
JOIN members AS m
    ON m.member_id = ist.issued_member_id
JOIN books AS bk
    ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs
    ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND DATEDIFF(DAY, ist.issued_date, GETDATE()) > 180
ORDER BY ist.issued_member_id;
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql

CREATE OR ALTER PROCEDURE add_return_records
    @p_return_id VARCHAR(10),
    @p_issued_id VARCHAR(10),
    @p_book_quality VARCHAR(10)
AS
BEGIN
    DECLARE @v_isbn VARCHAR(50);
    DECLARE @v_book_name VARCHAR(80);

    -- Insert into return_status
    INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
    VALUES (@p_return_id, @p_issued_id, CAST(GETDATE() AS DATE), @p_book_quality);

    -- Get the ISBN and book name
    SELECT 
        @v_isbn = issued_book_isbn,
        @v_book_name = issued_book_name
    FROM issued_status
    WHERE issued_id = @p_issued_id;

    -- Update book status
    UPDATE books
    SET status = 'yes'
    WHERE isbn = @v_isbn;

    -- Print confirmation
    PRINT 'Thank you for returning the book: ' + @v_book_name;
END;


-- calling function 
EXEC add_return_records 'RS138', 'IS135', 'Good';

-- calling function 
EXEC add_return_records 'RS148', 'IS140', 'Good';

```

**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS number_book_issued,
    COUNT(rs.return_id) AS number_of_book_return,
    SUM(bk.rental_price) AS total_revenue
INTO branch_reports
FROM issued_status AS ist
JOIN employees AS e
    ON e.emp_id = ist.issued_emp_id
JOIN branch AS b
    ON e.branch_id = b.branch_id
LEFT JOIN return_status AS rs
    ON rs.issued_id = ist.issued_id
JOIN books AS bk
    ON ist.issued_book_isbn = bk.isbn
GROUP BY b.branch_id, b.manager_id;


SELECT * FROM branch_reports;
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

SELECT * 
INTO active_members
FROM members
WHERE member_id IN (
    SELECT DISTINCT issued_member_id
    FROM issued_status
    WHERE issued_date >= DATEADD(MONTH, -2, CAST(GETDATE() AS DATE))
);


SELECT * FROM active_members;

```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT 
    e.emp_name,
    b.branch_id,
    b.manager_id,
    b.branch_address,
    b.contact_no,
    COUNT(ist.issued_id) AS no_book_issued
FROM issued_status AS ist
JOIN employees AS e ON e.emp_id = ist.issued_emp_id
JOIN branch AS b ON e.branch_id = b.branch_id
GROUP BY 
    e.emp_name,
    b.branch_id,
    b.manager_id,
    b.branch_address,
    b.contact_no;
```

**Task 18: Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    

```sql 
SELECT 
    m.member_name,
    ist.issued_book_name AS book_title,
    COUNT(*) AS damaged_issued_count
FROM issued_status ist
JOIN return_status rs 
    ON rs.issued_id = ist.issued_id
JOIN members m 
    ON m.member_id = ist.issued_member_id
WHERE rs.book_quality = 'Damaged'
GROUP BY 
    m.member_name,
    ist.issued_book_name
HAVING COUNT(*) > 2
ORDER BY damaged_issued_count DESC;
```

**Task 19: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

CREATE OR ALTER PROCEDURE issue_book
    @p_issued_id VARCHAR(10),
    @p_issued_member_id VARCHAR(30),
    @p_issued_book_isbn VARCHAR(30),
    @p_issued_emp_id VARCHAR(10)
AS
BEGIN
    DECLARE @v_status VARCHAR(10);

    -- Get book status
    SELECT @v_status = status
    FROM books
    WHERE isbn = @p_issued_book_isbn;

    IF @v_status = 'yes'
    BEGIN
        -- Insert issue record
        INSERT INTO issued_status (
            issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id
        )
        VALUES (
            @p_issued_id, @p_issued_member_id, CAST(GETDATE() AS DATE), @p_issued_book_isbn, @p_issued_emp_id
        );

        -- Update book status to 'no'
        UPDATE books
        SET status = 'no'
        WHERE isbn = @p_issued_book_isbn;

        PRINT 'Book records added successfully for book isbn: ' + @p_issued_book_isbn;
    END
    ELSE
    BEGIN
        PRINT 'Sorry to inform you the book you have requested is unavailable. Book ISBN: ' + @p_issued_book_isbn;
    END
END;

-- Call the procedure
EXEC issue_book 'IS155', 'C108', '978-0-553-29698-2', 'E104';
EXEC issue_book 'IS156', 'C108', '978-0-375-41398-8', 'E104';
```



**Task 20: Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines

```sql
SELECT * INTO overdue_books_summary
FROM (
    SELECT 
        ist.issued_member_id AS member_id,
        COUNT(CASE 
                 WHEN rs.return_date IS NULL 
                      AND DATEDIFF(DAY, ist.issued_date, GETDATE()) > 30 
                 THEN 1 
             END) AS number_of_overdue_books,

        SUM(CASE 
                WHEN rs.return_date IS NULL 
                     AND DATEDIFF(DAY, ist.issued_date, GETDATE()) > 30 
                THEN 
                    0.5 * (DATEDIFF(DAY, ist.issued_date, GETDATE()) - 30)
                ELSE 0
            END) AS total_fines,

        COUNT(ist.issued_id) AS number_of_books_issued
    FROM issued_status ist
    LEFT JOIN return_status rs ON rs.issued_id = ist.issued_id
    GROUP BY ist.issued_member_id
) AS overdue_summary;

-- View results

SELECT * FROM overdue_books_summary;
```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## How to Use

1. **Clone the Repository**: Clone this repository to your local machine.
   ```sh
   git clone https://github.com/najirh/Library-System-Management---P2.git
   ```

2. **Set Up the Database**: Execute the SQL scripts in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries in the `analysis_queries.sql` file to perform the analysis.
4. **Explore and Modify**: Customize the queries as needed to explore different aspects of the data or answer additional questions.

## Author - Sayura Senaratne

This project showcases SQL skills essential for database management and analysis. 

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/sayura-senaratne-0a7639198/)

Thank you for your interest in this project!
