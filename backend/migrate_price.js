const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function migrate() {
    try {
        console.log("Adding price column...");
        await pool.query('ALTER TABLE books ADD COLUMN IF NOT EXISTS price DECIMAL(10, 2) DEFAULT 19.99;');
        console.log("Column added successfully!");
    } catch (err) {
        console.error("Migration failed:", err);
    } finally {
        pool.end();
    }
}

migrate();
