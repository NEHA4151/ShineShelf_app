const express = require('express');
const { Pool } = require('pg');
const authenticateToken = require('../middleware/auth');
require('dotenv').config();

const router = express.Router();
const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

// Add a Review
router.post('/', authenticateToken, async (req, res) => {
    const { bookId, rating, comment } = req.body;
    const userId = req.user.id;

    if (!rating || rating < 1 || rating > 5) {
        return res.status(400).json({ error: 'Rating must be between 1 and 5' });
    }

    try {
        // Check if user already reviewed this book
        const existingReview = await pool.query(
            'SELECT id FROM reviews WHERE user_id = $1 AND book_id = $2',
            [userId, bookId]
        );

        if (existingReview.rows.length > 0) {
            return res.status(400).json({ error: 'You have already reviewed this book' });
        }

        await pool.query(
            'INSERT INTO reviews (user_id, book_id, rating, comment) VALUES ($1, $2, $3, $4)',
            [userId, bookId, rating, comment]
        );

        res.json({ message: 'Review added successfully!' });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error adding review' });
    }
});

// Get Reviews for a Book
router.get('/:bookId', async (req, res) => {
    const { bookId } = req.params;

    try {
        const result = await pool.query(`
            SELECT r.id, r.rating, r.comment, r.created_at, u.username
            FROM reviews r
            JOIN users u ON r.user_id = u.id
            WHERE r.book_id = $1
            ORDER BY r.created_at DESC
        `, [bookId]);

        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error fetching reviews' });
    }
});

module.exports = router;
