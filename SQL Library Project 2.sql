-- Library Management System

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




	 
