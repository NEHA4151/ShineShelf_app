const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function checkData() {
    try {
        const books = await pool.query('SELECT COUNT(*) FROM books');
        const inventory = await pool.query('SELECT COUNT(*) FROM inventory');
        console.log(`Books Count: ${books.rows[0].count}`);
        console.log(`Inventory Count: ${inventory.rows[0].count}`);
        
        if (books.rows[0].count > 0) {
            const firstBook = await pool.query('SELECT * FROM books LIMIT 1');
            console.log('Sample Book:', JSON.stringify(firstBook.rows[0], null, 2));
        }
    } catch (err) {
        console.error('Diagnostic failed:', err.message);
    } finally {
        await pool.end();
    }
}

checkData();
