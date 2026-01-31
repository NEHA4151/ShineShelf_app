const express = require('express');
const { Pool } = require('pg');
require('dotenv').config();

const router = express.Router();
const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

// Get all books
router.get('/', async (req, res) => {
    try {
        const allBooks = await pool.query('SELECT * FROM books');
        res.json(allBooks.rows);
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get book by ID
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const book = await pool.query('SELECT * FROM books WHERE id = $1', [id]);
        if (book.rows.length === 0) {
            return res.status(404).json({ error: 'Book not found' });
        }
        res.json(book.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Server error' });
    }
});

// Add a book (Admin only - middleware to be added)
router.post('/', async (req, res) => {
    const { title, author, genre, isbn, publication_year, description, cover_image_url } = req.body;
    try {
        const newBook = await pool.query(
            'INSERT INTO books (title, author, genre, isbn, publication_year, description, cover_image_url) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
            [title, author, genre, isbn, publication_year, description, cover_image_url]
        );
        res.json(newBook.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;
