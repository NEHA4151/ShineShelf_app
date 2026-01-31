require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Database Connection
const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

// Test DB Connection
pool.connect((err, client, release) => {
    if (err) {
        return console.error('Error acquiring client', err.stack);
    }
    client.query('SELECT NOW()', (err, result) => {
        release();
        if (err) {
            return console.error('Error executing query', err.stack);
        }
        console.log('Connected to Database:', result.rows[0]);
    });
});

// Routes Placeholder
app.get('/', (req, res) => {
    res.send('ShineShelf Backend is Running');
});

// Auth Routes
const authRouter = require('./routes/auth');
app.use('/auth', authRouter);

// Book Routes
const booksRouter = require('./routes/books');
app.use('/books', booksRouter);

// Transaction Routes
const transactionsRouter = require('./routes/transactions');
app.use('/transactions', transactionsRouter);

// Start Server
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

module.exports = { pool };
