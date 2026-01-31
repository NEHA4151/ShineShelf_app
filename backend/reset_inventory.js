const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function resetTables() {
    try {
        console.log("Resetting Inventory and Transactions...");

        // Drop tables
        await pool.query('DROP TABLE IF EXISTS transactions CASCADE');
        await pool.query('DROP TABLE IF EXISTS inventory CASCADE');
        await pool.query('DROP TYPE IF EXISTS inventory_status CASCADE');

        // Recreate Types
        await pool.query("CREATE TYPE inventory_status AS ENUM ('available', 'borrowed', 'lost', 'maintenance')");

        // Recreate Inventory
        await pool.query(`
      CREATE TABLE inventory (
        id SERIAL PRIMARY KEY,
        book_id INT REFERENCES books(id) ON DELETE CASCADE,
        status inventory_status DEFAULT 'available'
    )`);

        // Recreate Transactions
        await pool.query(`
      CREATE TABLE transactions (
        id SERIAL PRIMARY KEY,
        user_id INT REFERENCES users(id),
        inventory_id INT REFERENCES inventory(id),
        issue_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        due_date TIMESTAMP WITH TIME ZONE NOT NULL,
        return_date TIMESTAMP WITH TIME ZONE,
        fine_amount DECIMAL(10, 2) DEFAULT 0.00
    )`);

        console.log("Tables reset successfully!");

        // Now Seed Inventory
        console.log("Seeding inventory...");
        const books = await pool.query('SELECT id FROM books');
        for (const book of books.rows) {
            for (let i = 0; i < 5; i++) {
                await pool.query('INSERT INTO inventory (book_id, status) VALUES ($1, $2)', [book.id, 'available']);
            }
        }
        console.log("Inventory seeded!");

    } catch (err) {
        console.error("Error resetting tables:", err);
    } finally {
        pool.end();
    }
}

resetTables();
