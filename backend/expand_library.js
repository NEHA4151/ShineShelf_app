const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function expandLibrary() {
    try {
        console.log('Expanding library...');

        // 1. Increase price of EXISTING books by 10x
        // Note: Running this multiple times will exponentially increase prices. 
        // Ideally we would check if they are already high, but per user request "increase by 10x", we do it once.
        // To be safe, let's assume if price < 100 it needs updating (since new books are > 300).
        console.log('Increasing prices by 10x (for low priced books)...');
        await pool.query("UPDATE books SET price = price * 10 WHERE price < 100");

        // 2. Add New Books
        const newBooks = [
            {
                title: "The Alchemist",
                author: "Paulo Coelho",
                genre: "Fiction",
                description: "A novel about following your dreams.",
                cover_image_url: "https://m.media-amazon.com/images/I/51bVNTqHFlL._AC_UF1000,1000_QL80_.jpg",
                price: 499.00
            },
            {
                title: "Atomic Habits",
                author: "James Clear",
                genre: "Self-Help",
                description: "An easy & proven way to build good habits & break bad ones.",
                cover_image_url: "https://m.media-amazon.com/images/I/91bYsX41DVL._AC_UF1000,1000_QL80_.jpg",
                price: 550.00
            },
            {
                title: "Sapiens: A Brief History of Humankind",
                author: "Yuval Noah Harari",
                genre: "History",
                description: "Explores the history of our species.",
                cover_image_url: "https://m.media-amazon.com/images/I/713jIoMO3UL._AC_UF1000,1000_QL80_.jpg",
                price: 600.00
            },
            {
                title: "Rich Dad Poor Dad",
                author: "Robert T. Kiyosaki",
                genre: "Finance",
                description: "What the rich teach their kids about money.",
                cover_image_url: "https://m.media-amazon.com/images/I/81bsw6fnUiL._AC_UF1000,1000_QL80_.jpg",
                price: 450.00
            },
            {
                title: "Clean Architecture",
                author: "Robert C. Martin",
                genre: "Technology",
                description: "A craftsman's guide to software structure and design.",
                cover_image_url: "https://m.media-amazon.com/images/I/61r4tYksy1L._AC_UF1000,1000_QL80_.jpg",
                price: 850.00
            },
            {
                title: "Introduction to Algorithms",
                author: "Thomas H. Cormen",
                genre: "Education",
                description: "Comprehensive guide to algorithms.",
                cover_image_url: "https://m.media-amazon.com/images/I/61Mw06x2XcL._AC_UF1000,1000_QL80_.jpg",
                price: 1200.00
            },
            {
                title: "The Psychology of Money",
                author: "Morgan Housel",
                genre: "Finance",
                description: "Timeless lessons on wealth, greed, and happiness.",
                cover_image_url: "https://m.media-amazon.com/images/I/71trhHuBHrL._AC_UF1000,1000_QL80_.jpg",
                price: 399.00
            }
        ];

        console.log('Inserting new books...');
        for (const book of newBooks) {
            const existing = await pool.query("SELECT id FROM books WHERE title = $1", [book.title]);

            let bookId;
            if (existing.rows.length === 0) {
                const res = await pool.query(
                    `INSERT INTO books (title, author, genre, description, cover_image_url, price, publication_year, isbn) 
                     VALUES ($1, $2, $3, $4, $5, $6, 2020, '1234567890') 
                     RETURNING id`,
                    [book.title, book.author, book.genre, book.description, book.cover_image_url, book.price]
                );
                bookId = res.rows[0].id;
                console.log(`Inserted: ${book.title}`);

                for (let i = 0; i < 5; i++) {
                    await pool.query("INSERT INTO inventory (book_id, status) VALUES ($1, 'available')", [bookId]);
                }
            } else {
                console.log(`Skipped (Already exists): ${book.title}`);
            }
        }

        console.log('Library expansion complete!');

    } catch (err) {
        console.error('Error expanding library:', err);
    } finally {
        pool.end();
    }
}

expandLibrary();
