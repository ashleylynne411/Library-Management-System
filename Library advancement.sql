USE LibraryDB;

DELIMITER //

CREATE PROCEDURE IssueBook(IN book_id INT, IN member_id INT, IN BorrowDate DATE, IN ReturnDate DATE)
BEGIN
    -- Check if book is available
    DECLARE available INT;
    SELECT available_copies INTO available FROM Books WHERE book_id = bookID;

    IF available > 0 THEN
        -- Record the loan transaction
        INSERT INTO Loans (book_id, member_id, borrow_date, return_date, returned)
        VALUES (bookID, memberID, borrowDate, returnDate, FALSE);

        -- Reduce available copies by 1
        UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = bookID;
        
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book is currently unavailable';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER ReturnBook AFTER UPDATE ON Loans
FOR EACH ROW
BEGIN
    IF NEW.returned = TRUE THEN
        UPDATE Books SET available_copies = available_copies + 1 WHERE book_id = NEW.book_id;
    END IF;
END //

DELIMITER ;
