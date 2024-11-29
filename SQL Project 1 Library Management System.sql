-- Create the LibraryDB database
CREATE DATABASE LibraryDB;

-- Select to use the LibraryDB database we just created
USE LibraryDB;

-- Creates the "Books" table to store information about books
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique ID for each book
    title VARCHAR(255) NOT NULL,             -- Title of the book
    author VARCHAR(255) NOT NULL,            -- Author of the book
    genre VARCHAR(100),                      -- Genre of the book
    published_year YEAR                      -- Year the book was published
);

-- Creates the "Borrowers" table to store information about borrowers
CREATE TABLE Borrowers (
    borrower_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique ID for each borrower
    name VARCHAR(255) NOT NULL,                  -- Name of the borrower
    email VARCHAR(255),                          -- Email address of the borrower
    phone_number VARCHAR(15)                     -- Phone number of the borrower
);

-- Creates the "BorrowedBooks" table to track borrowed books
CREATE TABLE BorrowedBooks (
    borrowed_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique ID for each borrowed record
    book_id INT,                                 -- References the book_id in "Books" table
    borrower_id INT,                             -- References the borrower_id in "Borrowers" table
    borrow_date DATE,                            -- Date when the book was borrowed
    return_date DATE,                            -- Date when the book was returned
    FOREIGN KEY (book_id) REFERENCES Books(book_id),          -- Foreign key linking "BorrowedBooks" table to "Books" table
    FOREIGN KEY (borrower_id) REFERENCES Borrowers(borrower_id) -- Foreign key linking "BorrowedBooks" table to "Borrowers" table
);

-- Inserts the data: title, author, genre, published_year into the "Books" table
INSERT INTO Books (title, author, genre, published_year) VALUES
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960),
('1984', 'George Orwell', 'Dystopian', 1949),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925),
('The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 1951),
('Harry Potter', 'J.K. Rowling', 'Fantasy', 1997),
('Matilda', 'Roald Dahl', 'Children Literature', 1988);

-- Inserts the data: name, email, phone_number into the "Borrowers" table
INSERT INTO Borrowers (name, email, phone_number) VALUES
('Alice Johnson', 'alicej@gmail.com', '0723-456-7890'),
('Bob Smith', 'bobs@hotmail.co.uk', '0734-567-8901'),
('John Jones', 'Johns@aol.co.uk', '0789-456-0123');

-- Inserts the data: book_id, borrower_id, borrow_date, return_date into the "BorrowedBooks" table
INSERT INTO BorrowedBooks (book_id, borrower_id, borrow_date, return_date) VALUES
(1, 1, '2024-11-01', NULL),            -- Alice Johnson borrowed 'To Kill a Mockingbird' on 2024-11-01 and hasn't returned it yet
(2, 2, '2024-11-02', '2024-11-10');    -- Bob Smith borrowed '1984' on 2024-11-02 and returned it on 2024-11-10

-- Retrieve all records from the "Books" table
SELECT * FROM Books;

-- Retrieve all records from the "Borrowers" table
SELECT * FROM Borrowers;

-- Retrieve all records from the "BorrowedBooks" table
SELECT * FROM BorrowedBooks;

-- Retrieve detailed information about borrowed books, including book titles and borrower names:
-- borrowed_id from the "BorrowedBooks" table, title from the "Books" table, name from the "Borrowers" table, borrow_date and return_date from the "BorrowedBooks" table
SELECT BorrowedBooks.borrowed_id, Books.title, Borrowers.name, BorrowedBooks.borrow_date, BorrowedBooks.return_date
FROM BorrowedBooks
-- The JOIN clauses link the "BorrowedBooks" table with the "Books" and "Borrowers" tables
JOIN Books ON BorrowedBooks.book_id = Books.book_id
JOIN Borrowers ON BorrowedBooks.borrower_id = Borrowers.borrower_id;

-- Updates the return_date to November 15, 2024, for the record in the "BorrowedBooks" table where borrowed_id is 1
UPDATE BorrowedBooks
SET return_date = '2024-11-15'
WHERE borrowed_id = 1;

-- Delete the borrower record for borrower_id 2 if they have returned all borrowed books.
DELETE FROM Borrowers
WHERE borrower_id = 2
-- If they still have books that haven't been returned, hence "return_date IS NULL", then the record is not deleted
AND borrower_id NOT IN (SELECT borrower_id FROM BorrowedBooks WHERE return_date IS NULL);