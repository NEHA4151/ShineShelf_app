const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function seedBooks() {
    try {
        console.log("Seeding books...");
        await pool.query(`
      INSERT INTO books (title, author, isbn, genre, description, cover_image_url, price) VALUES 
      ('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'Classic', 'A novel about the American dream.', 'https://upload.wikimedia.org/wikipedia/commons/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg', 12.99),
      ('1984', 'George Orwell', '9780451524935', 'Dystopian', 'A novel about totalitarianism.', 'https://m.media-amazon.com/images/I/71rpa1-kyvL._AC_UF1000,1000_QL80_.jpg', 14.99),
      ('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 'Classic', 'A novel about racial injustice.', 'https://upload.wikimedia.org/wikipedia/commons/4/4f/To_Kill_a_Mockingbird_%28first_edition_cover%29.jpg', 11.50),
      ('Harry Potter and the Sorcerers Stone', 'J.K. Rowling', '9780590353427', 'Fantasy', 'A young wizard discovers his magical heritage.', 'https://m.media-amazon.com/images/I/71-++hbbERL._AC_UF1000,1000_QL80_.jpg', 19.99),
      ('The Hobbit', 'J.R.R. Tolkien', '9780547928227', 'Fantasy', 'A fantasy novel about the quest of home-loving hobbit Bilbo Baggins.', 'https://upload.wikimedia.org/wikipedia/en/4/4a/TheHobbit_FirstEdition.jpg', 15.00),
      ('Clean Code', 'Robert C. Martin', '9780132350884', 'Education', 'A Handbook of Agile Software Craftsmanship.', 'https://m.media-amazon.com/images/I/41xShlnTZTL._AC_UF1000,1000_QL80_.jpg', 39.99)
      ON CONFLICT (isbn) DO UPDATE SET price = EXCLUDED.price;
    `);
        console.log("Books added successfully!");
    } catch (err) {
        console.error("Error seeding books:", err);
    } finally {
        pool.end();
    }
}

seedBooks();
