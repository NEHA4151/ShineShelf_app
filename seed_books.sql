-- Insert Sample Books
INSERT INTO books (title, author, genre, isbn, publication_year, description, cover_image_url, price) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', '9780743273565', 1925, 'A story of wealth, love, and the American Dream in the 1920s.', 'https://images-na.ssl-images-amazon.com/images/I/81af+MCATTL.jpg', 12.99),
('1984', 'George Orwell', 'Dystopian', '9780451524935', 1949, 'A chilling prophecy about the future and the struggle against Big Brother.', 'https://images-na.ssl-images-amazon.com/images/I/71kxa1-0arL.jpg', 14.50),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', '9780547928227', 1937, 'Bilbo Baggins is whisked away into a quest to reclaim the lost Treasure.', 'https://images-na.ssl-images-amazon.com/images/I/710+HcoP38L.jpg', 15.99),
('To Kill a Mockingbird', 'Harper Lee', 'Classic', '9780061120084', 1960, 'A gripping tale of racial injustice and the loss of innocence.', 'https://images-na.ssl-images-amazon.com/images/I/81gepf1eMqL.jpg', 11.20),
('Brave New World', 'Aldous Huxley', 'Sci-Fi', '9780060850524', 1932, 'A disturbing futuristic vision of a world of genetically bread people.', 'https://images-na.ssl-images-amazon.com/images/I/81zE42Jv3uL.jpg', 13.99);

-- Insert Inventory for each book (Physical copies)
INSERT INTO inventory (book_id, status) VALUES
(1, 'available'), (1, 'available'), (1, 'borrowed'),
(2, 'available'), (2, 'available'),
(3, 'available'), (3, 'available'), (3, 'available'),
(4, 'available'), (4, 'borrowed'),
(5, 'available'), (5, 'maintenance');
