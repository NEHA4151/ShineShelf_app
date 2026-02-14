const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function updateBookYears() {
    try {
        console.log("Updating publication years...");

        const bookYears = {
            'The Great Gatsby': 1925,
            '1984': 1949,
            'To Kill a Mockingbird': 1960,
            'Harry Potter and the Sorcerers Stone': 1997,
            'The Hobbit': 1937,
            'Clean Code': 2008,
            'Pride and Prejudice': 1813,
            'Moby Dick': 1851,
            'War and Peace': 1869,
            'The Catcher in the Rye': 1951,
            'The Lord of the Rings': 1954,
            'The Alchemist': 1988,
            'The Da Vinci Code': 2003,
            'The Hunger Games': 2008,
            'Life of Pi': 2001,
            'Brave New World': 1932,
            'Sapiens': 2011,
            'Educated': 2018,
            'The Kite Runner': 2003,
            'Little Women': 1868,
            'Frankenstein': 1818,
            'Dracula': 1897,
            'The Picture of Dorian Gray': 1890,
            'Jane Eyre': 1847,
            'Wuthering Heights': 1847,
            'Crime and Punishment': 1866
        };

        for (const [title, year] of Object.entries(bookYears)) {
            const res = await pool.query(
                `UPDATE books SET publication_year = $1 WHERE title = $2`,
                [year, title]
            );
            if (res.rowCount > 0) {
                console.log(`Updated '${title}' to ${year}`);
            } else {
                console.log(`Book not found: '${title}'`);
            }
        }

        console.log("Publication years updated successfully!");
    } catch (err) {
        console.error("Error updating books:", err);
    } finally {
        pool.end();
    }
}

updateBookYears();
