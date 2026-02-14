const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function seedMoreBooks() {
    try {
        console.log("Seeding more books...");
        const books = [
            { title: "Pride and Prejudice", author: "Jane Austen", isbn: "9780141439518", genre: "Classic", desc: "A romantic novel of manners.", img: "https://m.media-amazon.com/images/I/71Q1tPupKjL._AC_UF1000,1000_QL80_.jpg", price: 9.99 },
            { title: "Moby Dick", author: "Herman Melville", isbn: "9781503280786", genre: "Adventure", desc: "The narrative of Captain Ahab's obsessiveness.", img: "https://m.media-amazon.com/images/I/71d5wo+-MuL._AC_UF1000,1000_QL80_.jpg", price: 11.49 },
            { title: "War and Peace", author: "Leo Tolstoy", isbn: "9780199232765", genre: "Historical", desc: "A story of five aristocratic families.", img: "https://m.media-amazon.com/images/I/71wXZB-VtBL._AC_UF1000,1000_QL80_.jpg", price: 13.99 },
            { title: "The Catcher in the Rye", author: "J.D. Salinger", isbn: "9780316769488", genre: "Fiction", desc: "A story about teenage angst and alienation.", img: "https://m.media-amazon.com/images/I/91HPG31dTwL._AC_UF1000,1000_QL80_.jpg", price: 10.99 },
            { title: "The Lord of the Rings", author: "J.R.R. Tolkien", isbn: "9780544003415", genre: "Fantasy", desc: "An epic high-fantasy novel.", img: "https://m.media-amazon.com/images/I/71jLBXtWJWL._AC_UF1000,1000_QL80_.jpg", price: 25.00 },
            { title: "The Alchemist", author: "Paulo Coelho", isbn: "9780062315007", genre: "Adventure", desc: "A novel about following your dreams.", img: "https://m.media-amazon.com/images/I/61HAE8zahLL._AC_UF1000,1000_QL80_.jpg", price: 16.99 },
            { title: "The Da Vinci Code", author: "Dan Brown", isbn: "9780307474278", genre: "Thriller", desc: "A mystery thriller novel.", img: "https://m.media-amazon.com/images/I/914-1m74hAL._AC_UF1000,1000_QL80_.jpg", price: 14.50 },
            { title: "The Hunger Games", author: "Suzanne Collins", isbn: "9780439023481", genre: "Dystopian", desc: "A dystopian novel set in Panem.", img: "https://m.media-amazon.com/images/I/61I24wOsn8L._AC_UF1000,1000_QL80_.jpg", price: 12.00 },
            { title: "Life of Pi", author: "Yann Martel", isbn: "9780156027328", genre: "Adventure", desc: "A fantasy adventure novel.", img: "https://m.media-amazon.com/images/I/913s4s-gVIL._AC_UF1000,1000_QL80_.jpg", price: 11.20 },
            { title: "Brave New World", author: "Aldous Huxley", isbn: "9780060850524", genre: "Dystopian", desc: "A dystopian social science fiction.", img: "https://m.media-amazon.com/images/I/91D4YvdC0dL._AC_UF1000,1000_QL80_.jpg", price: 13.50 },
            { title: "Sapiens", author: "Yuval Noah Harari", isbn: "9780062316097", genre: "Non-fiction", desc: "A brief history of humankind.", img: "https://m.media-amazon.com/images/I/713jIoMO3UL._AC_UF1000,1000_QL80_.jpg", price: 18.99 },
            { title: "Educated", author: "Tara Westover", isbn: "9780399590504", genre: "Memoir", desc: "A memoir about growing up in a survivalist family.", img: "https://m.media-amazon.com/images/I/81WojUxbbFL._AC_UF1000,1000_QL80_.jpg", price: 15.99 },
        ];

        for (const book of books) {
            await pool.query(`
                INSERT INTO books (title, author, isbn, genre, description, cover_image_url, price) 
                VALUES ($1, $2, $3, $4, $5, $6, $7)
                ON CONFLICT (isbn) DO NOTHING;
            `, [book.title, book.author, book.isbn, book.genre, book.desc, book.img, book.price]);
        }

        console.log("More books added successfully!");
    } catch (err) {
        console.error("Error seeding more books:", err);
    } finally {
        pool.end();
    }
}

seedMoreBooks();
