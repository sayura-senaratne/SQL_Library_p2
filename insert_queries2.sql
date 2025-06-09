-- INSERT INTO book_issued in last 30 days
-- SELECT * from employees;
-- SELECT * from books;
-- SELECT * from members;
-- SELECT * from issued_status;


INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', DATEADD(DAY, -24, CAST(GETDATE() AS DATE)), '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', DATEADD(DAY, -13, CAST(GETDATE() AS DATE)), '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', DATEADD(DAY, -7, CAST(GETDATE() AS DATE)), '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', DATEADD(DAY, -32, CAST(GETDATE() AS DATE)), '978-0-375-50167-0', 'E101');

-- Adding new column in return_status

ALTER TABLE return_status
ADD book_quality VARCHAR(15) DEFAULT 'Good';

-- Update specific rows
UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id IN ('IS112', 'IS117', 'IS118');

-- View table
SELECT * FROM return_status;

