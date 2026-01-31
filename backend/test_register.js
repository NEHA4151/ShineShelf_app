const { Pool } = require('pg');
const bcrypt = require('bcrypt');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function testRegister() {
    try {
        const password = "password123";
        const hashedPassword = await bcrypt.hash(password, 10);
        // Simulating values from user screenshot
        const username = "yash";
        const email = "yash@email.com";
        const role = "member";

        console.log("Attempting INSERT...");
        const newUser = await pool.query(
            'INSERT INTO users (username, email, password_hash, role) VALUES ($1, $2, $3, $4) RETURNING id, username, email, role',
            [username, email, hashedPassword, role]
        );
        console.log("Success:", newUser.rows[0]);
    } catch (err) {
        console.error("FULL ERROR DETAILS:");
        console.error(err);
    } finally {
        pool.end();
    }
}

testRegister();
