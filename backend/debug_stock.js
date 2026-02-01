const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function checkStock() {
    try {
        console.log('Checking stock...');

        const query = `
            SELECT 
                b.id, b.title,
                (SELECT COUNT(*) FROM inventory i WHERE i.book_id = b.id AND i.status = 'available') as available_stock
            FROM books b
        `;

        const res = await pool.query(query);
        console.table(res.rows);

        // Also check raw inventory
        const inv = await pool.query("SELECT book_id, status, count(*) FROM inventory GROUP BY book_id, status");
        console.log("\nRaw Inventory Counts:");
        console.table(inv.rows);

    } catch (err) {
        console.error('Error:', err);
    } finally {
        pool.end();
    }
}

checkStock();
