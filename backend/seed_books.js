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
      INSERT INTO books (title, author, isbn, genre, description, cover_image_url) VALUES 
      ('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'Classic', 'A novel about the American dream.', 'https://upload.wikimedia.org/wikipedia/commons/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg'),
      ('1984', 'George Orwell', '9780451524935', 'Dystopian', 'A novel about totalitarianism.', 'https://m.media-amazon.com/images/I/71rpa1-kyvL._AC_UF1000,1000_QL80_.jpg'),
      ('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 'Classic', 'A novel about racial injustice.', 'https://upload.wikimedia.org/wikipedia/commons/4/4f/To_Kill_a_Mockingbird_%28first_edition_cover%29.jpg')
    `);
        console.log("Books added successfully!");
    } catch (err) {
        console.error("Error seeding books:", err);
    } finally {
        pool.end();
    }
}

seedBooks();
