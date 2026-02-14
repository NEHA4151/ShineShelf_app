const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function seedFinalAndFixStock() {
    try {
        console.log("Seeding final batch of books...");
        const books = [
            { title: "The Kite Runner", author: "Khaled Hosseini", isbn: "9781594480003", genre: "Fiction", desc: "A story of friendship and redemption.", img: "https://m.media-amazon.com/images/I/81IzbD2IiIL._AC_UF1000,1000_QL80_.jpg", price: 14.00 },
            { title: "Little Women", author: "Louisa May Alcott", isbn: "9780147514011", genre: "Classic", desc: "The story of the four March sisters.", img: "https://m.media-amazon.com/images/I/91l13I5C0EL._AC_UF1000,1000_QL80_.jpg", price: 10.50 },
            { title: "Frankenstein", author: "Mary Shelley", isbn: "9780486282114", genre: "Horror", desc: "A scientist creates a sentient creature.", img: "https://m.media-amazon.com/images/I/81z7E0uWdtL._AC_UF1000,1000_QL80_.jpg", price: 9.00 },
            { title: "Dracula", author: "Bram Stoker", isbn: "9780486411095", genre: "Horror", desc: "The vampire Count Dracula moves to England.", img: "https://m.media-amazon.com/images/I/91cT+K+-nAL._AC_UF1000,1000_QL80_.jpg", price: 9.50 },
            { title: "The Picture of Dorian Gray", author: "Oscar Wilde", isbn: "9780141439570", genre: "Classic", desc: "A young man sells his soul for eternal youth.", img: "https://m.media-amazon.com/images/I/71ftb9X+L+L._AC_UF1000,1000_QL80_.jpg", price: 8.99 },
            { title: "Jane Eyre", author: "Charlotte Bronte", isbn: "9780141441146", genre: "Classic", desc: "The experiences of the eponymous heroine.", img: "https://m.media-amazon.com/images/I/91lu-3pLurL._AC_UF1000,1000_QL80_.jpg", price: 11.00 },
            { title: "Wuthering Heights", author: "Emily Bronte", isbn: "9780141439556", genre: "Classic", desc: "A tale of passion and revenge.", img: "https://m.media-amazon.com/images/I/81-I+RXZiJL._AC_UF1000,1000_QL80_.jpg", price: 10.00 },
            { title: "Crime and Punishment", author: "Fyodor Dostoevsky", isbn: "9780140449136", genre: "Classic", desc: "A mental anguish and moral dilemmas of a poor ex-student.", img: "https://m.media-amazon.com/images/I/71O2QE0vV0L._AC_UF1000,1000_QL80_.jpg", price: 13.00 },
        ];

        // 1. Insert New Books
        for (const book of books) {
            await pool.query(`
                INSERT INTO books (title, author, isbn, genre, description, cover_image_url, price) 
                VALUES ($1, $2, $3, $4, $5, $6, $7)
                ON CONFLICT (isbn) DO NOTHING;
            `, [book.title, book.author, book.isbn, book.genre, book.desc, book.img, book.price]);
        }
        console.log("New books inserted/verified.");

        // 2. Clear existing inventory to start fresh (or you could just add, but clearing ensures exact counts)
        // Since we want exactly 5 for everyone, clearing is safer to avoid duplicates.
        // Be careful: if there are active loans in 'transactions', deleting from inventory might violate FK constraints unless ON DELETE CASCADE.
        // The init.sql has ON DELETE CASCADE for inventory -> books, but transactions -> inventory doesn't specify cascade on delete.
        // So we should try to update existing or add new ones.

        // Strategy: Get all books. For each book, count inventory. Add until 5.
        // For the 2 unavailable books, set status to 'maintenance' or delete if not referenced.
        // EASIER: Just set status of existing items to 'available' and add more if needed.

        const allBooksRes = await pool.query('SELECT id, title FROM books');
        const allBooks = allBooksRes.rows;
        const unavailableTitles = ['The Da Vinci Code', 'The Hunger Games'];

        for (const book of allBooks) {
            if (unavailableTitles.includes(book.title)) {
                // Set these to 0 available. We can mark existing as 'maintenance' or 'lost'.
                console.log(`Setting ${book.title} to unavailable...`);
                await pool.query(`UPDATE inventory SET status = 'maintenance' WHERE book_id = $1`, [book.id]);
                // Ensure no 'available' items exist
            } else {
                // Determine current count
                const invRes = await pool.query(`SELECT COUNT(*) FROM inventory WHERE book_id = $1`, [book.id]);
                let count = parseInt(invRes.rows[0].count);

                // If we have items, make sure they are 'available'
                if (count > 0) {
                    await pool.query(`UPDATE inventory SET status = 'available' WHERE book_id = $1 AND status != 'borrowed'`, [book.id]);
                }

                // Add more if less than 5
                const needed = 5 - count;
                if (needed > 0) {
                    console.log(`Adding ${needed} copies for ${book.title}...`);
                    for (let i = 0; i < needed; i++) {
                        await pool.query(`INSERT INTO inventory (book_id, status) VALUES ($1, 'available')`, [book.id]);
                    }
                }
            }
        }

        console.log("Stock levels updated successfully!");

    } catch (err) {
        console.error("Error updating books:", err);
    } finally {
        pool.end();
    }
}

seedFinalAndFixStock();
