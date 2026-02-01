const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function makeBooksAvailable() {
    try {
        console.log('Restocking library...');

        // 1. Reset all inventory to available
        await pool.query("UPDATE inventory SET status = 'available'");

        // 2. (Optional) If we want to ensure *every* book has stock even if it had 0 inventory rows:
        // Get all book IDs
        const books = await pool.query("SELECT id FROM books");
        for (const book of books.rows) {
            // Check if it has any inventory
            const inv = await pool.query("SELECT count(*) FROM inventory WHERE book_id = $1", [book.id]);
            if (parseInt(inv.rows[0].count) === 0) {
                // Add 5 copies if none exist
                for (let i = 0; i < 5; i++) {
                    await pool.query("INSERT INTO inventory (book_id, status) VALUES ($1, 'available')", [book.id]);
                }
                console.log(`Added stock for book ${book.id}`);
            }
        }

        console.log('All books are now available!');
    } catch (err) {
        console.error('Error updating stock:', err);
    } finally {
        pool.end();
    }
}

makeBooksAvailable();
