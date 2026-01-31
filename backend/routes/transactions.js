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

// Borrow a book
router.post('/borrow', authenticateToken, async (req, res) => {
    const { bookId } = req.body;
    const userId = req.user.id;

    try {
        // 1. Find an available inventory item for this book
        const inventoryResult = await pool.query(
            'SELECT id FROM inventory WHERE book_id = $1 AND status = $2 LIMIT 1',
            [bookId, 'available']
        );

        if (inventoryResult.rows.length === 0) {
            return res.status(400).json({ error: 'Book is currently out of stock' });
        }

        const inventoryId = inventoryResult.rows[0].id;
        const dueDate = new Date();
        dueDate.setDate(dueDate.getDate() + 14); // 2 weeks due date

        // 2. Create Transaction
        await pool.query(
            'INSERT INTO transactions (user_id, inventory_id, due_date) VALUES ($1, $2, $3)',
            [userId, inventoryId, dueDate]
        );

        // 3. Update Inventory Status
        await pool.query(
            'UPDATE inventory SET status = $1 WHERE id = $2',
            ['borrowed', inventoryId]
        );

        res.json({ message: 'Book borrowed successfully!', dueDate });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error during borrowing' });
    }
});

// Return a book
router.post('/return', authenticateToken, async (req, res) => {
    const { bookId } = req.body;
    const userId = req.user.id;

    try {
        // 1. Find active transaction
        const transactionResult = await pool.query(`
            SELECT t.id, t.inventory_id, t.due_date 
            FROM transactions t
            JOIN inventory i ON t.inventory_id = i.id
            WHERE t.user_id = $1 AND i.book_id = $2 AND t.return_date IS NULL
            LIMIT 1
        `, [userId, bookId]);

        if (transactionResult.rows.length === 0) {
            return res.status(400).json({ error: 'No active loan found for this book' });
        }

        const transaction = transactionResult.rows[0];
        const returnDate = new Date();

        // Calculate Fine (Example: $1 per day overdue)
        let fine = 0.00;
        const dueDate = new Date(transaction.due_date);
        if (returnDate > dueDate) {
            const diffTime = Math.abs(returnDate - dueDate);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            fine = diffDays * 1.00;
        }

        // 2. Update Transaction
        await pool.query(
            'UPDATE transactions SET return_date = $1, fine_amount = $2 WHERE id = $3',
            [returnDate, fine, transaction.id]
        );

        // 3. Update Inventory
        await pool.query(
            'UPDATE inventory SET status = $1 WHERE id = $2',
            ['available', transaction.inventory_id]
        );

        // 4. BADGE LOGIC: Check total books read
        const booksReadResult = await pool.query(
            'SELECT COUNT(*) FROM transactions WHERE user_id = $1 AND return_date IS NOT NULL',
            [userId]
        );
        const count = parseInt(booksReadResult.rows[0].count);

        // Define triggers
        let badgeTrigger = null;
        if (count === 1) badgeTrigger = 'read_1';
        else if (count === 5) badgeTrigger = 'read_5';
        else if (count === 10) badgeTrigger = 'read_10';
        else if (count === 20) badgeTrigger = 'read_20';

        let newBadge = null;
        if (badgeTrigger) {
            const badgeRes = await pool.query('SELECT id, name FROM badges WHERE trigger_logic = $1', [badgeTrigger]);
            if (badgeRes.rows.length > 0) {
                const badge = badgeRes.rows[0];
                // Check if already has badge
                const hasBadge = await pool.query('SELECT 1 FROM user_badges WHERE user_id = $1 AND badge_id = $2', [userId, badge.id]);
                if (hasBadge.rows.length === 0) {
                    await pool.query('INSERT INTO user_badges (user_id, badge_id) VALUES ($1, $2)', [userId, badge.id]);
                    newBadge = badge.name;
                }
            }
        }

        res.json({ message: 'Book returned successfully!', fine, newBadge });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error during return' });
    }
});

// Get My Borrowed Books
router.get('/my-books', authenticateToken, async (req, res) => {
    const userId = req.user.id;
    try {
        const result = await pool.query(`
            SELECT b.id, b.title, b.author, b.cover_image_url, t.due_date, t.issue_date, t.fine_amount
            FROM transactions t
            JOIN inventory i ON t.inventory_id = i.id
            JOIN books b ON i.book_id = b.id
            WHERE t.user_id = $1 AND t.return_date IS NULL
        `, [userId]);

        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error fetching my books' });
    }
});

module.exports = router;
