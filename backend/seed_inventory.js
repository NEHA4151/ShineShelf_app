const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function seedInventory() {
    try {
        console.log("Fetching books...");
        const books = await pool.query('SELECT id, title FROM books');

        if (books.rows.length === 0) {
            console.log("No books found. Seed books first!");
            return;
        }

        console.log(`Found ${books.rows.length} books. Adding 5 copies each to inventory...`);

        for (const book of books.rows) {
            // Insert 5 copies for each book
            for (let i = 0; i < 5; i++) {
                await pool.query(
                    'INSERT INTO inventory (book_id, status) VALUES ($1, $2)',
                    [book.id, 'available']
                );
            }
        }
        console.log("Inventory seeded successfully!");
    } catch (err) {
        console.error("Error seeding inventory:", err);
    } finally {
        pool.end();
    }
}

seedInventory();
