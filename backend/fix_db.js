const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function fixSchema() {
    try {
        // 1. Ensure type exists (graceful handling)
        try {
            await pool.query("create type user_role as enum ('admin', 'librarian', 'member');");
            console.log("Created user_role type.");
        } catch (e) {
            console.log("user_role type likely exists (ignoring error).");
        }

        // 2. Add the column
        await pool.query(`
      ALTER TABLE users 
      ADD COLUMN IF NOT EXISTS role user_role DEFAULT 'member';
    `);
        console.log('Successfully added "role" column to users table.');
    } catch (err) {
        console.error('Error fixing schema:', err);
    } finally {
        pool.end();
    }
}

fixSchema();
