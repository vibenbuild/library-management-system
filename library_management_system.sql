-- Show all available databases
SHOW DATABASES;

-- Create a new database for the Library Management System
CREATE DATABASE library_system;

-- Switch to the newly created database
USE library_system;

-- ============================
-- Create Tables for the Database
-- ============================

-- Create the 'books' table to store details about books in the library
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each book
    title VARCHAR(255) NOT NULL,           -- Title of the book
    author VARCHAR(255) NOT NULL,          -- Author of the book
    genre VARCHAR(100),                    -- Genre of the book (optional)
    publication_year INT,                  -- Year the book was published (optional)
    available_copies INT                   -- Number of copies available for borrowing
);

-- Create the 'members' table to store details about library members
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each member
    name VARCHAR(255),                        -- Name of the member
    email VARCHAR(255),                       -- Email of the member
    membership_date DATE                      -- Date the membership started
);

-- Create the 'transactions' table to store details about book borrow and return transactions
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each transaction
    book_id INT,                                   -- ID of the book being borrowed/returned
    member_id INT,                                 -- ID of the member borrowing/returning the book
    borrow_date DATE,                              -- Date the book was borrowed
    due_date DATE,                                 -- Due date for returning the book
    return_date DATE,                              -- Date the book was returned
    FOREIGN KEY (book_id) REFERENCES books(book_id), -- Foreign key linking to 'books' table
    FOREIGN KEY (member_id) REFERENCES members(member_id) -- Foreign key linking to 'members' table
);

-- View all tables created in the current database
SHOW TABLES;

-- ============================
-- Insert Data into Tables
-- ============================

-- Insert sample book records into the 'books' table
INSERT INTO books
(title, author, genre, publication_year, available_copies)
VALUES
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 5),
('1984', 'George Orwell', 'Dystopian', 1949, 3),
('Moby Dick', 'Herman Melville', 'Adventure', 1851, 2);

-- View data in the 'books' table to confirm the insertion
SELECT * FROM books;

-- Insert sample member records into the 'members' table
INSERT INTO members
(name, email, membership_date)
VALUES
('Alice Smith', 'alice@example.com', '2025-01-01'),
('Bob Johnson', 'bob@example.com', '2025-01-02');

-- View data in the 'members' table to confirm the insertion
SELECT * FROM members;

-- ============================
-- Perform Operations
-- ============================

-- View the availability of a specific book
SELECT * FROM books
WHERE title = "To Kill a Mockingbird";

-- Record a transaction when a member borrows a book
INSERT INTO transactions
(book_id, member_id, borrow_date, due_date)
VALUES
(1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY)); -- Borrowed today, due in 14 days

-- Manually update the number of available copies when a book is borrowed
UPDATE books
SET available_copies = available_copies - 1
WHERE book_id = 1;

-- View books borrowed by a specific member
SELECT m.name AS "Member Name",
       b.title, b.author, t.borrow_date, t.due_date, t.return_date
FROM transactions t
JOIN books b ON t.book_id = b.book_id
JOIN members m ON t.member_id = m.member_id
WHERE t.member_id = 1;

-- Record a transaction when a member returns a book
UPDATE transactions
SET return_date = CURDATE()
WHERE member_id = 1 AND book_id = 1 AND return_date IS NULL;

-- Manually update the number of available copies when a book is returned
UPDATE books
SET available_copies = available_copies + 1
WHERE book_id = 1;

-- ============================
-- Notes
-- ============================

-- Ensure that when deleting a book, no active transactions are referencing it.
-- If you need to delete a book, first delete the related transactions:
-- DELETE FROM transactions WHERE book_id = 1;

-- Then delete the book:
-- DELETE FROM books WHERE book_id = 1;
