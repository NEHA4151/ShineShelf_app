const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

async function seedBadges() {
    try {
        console.log("Seeding badges...");

        // Define badges
        const badges = [
            { name: 'First Read', description: 'Read your first book.', icon_url: 'https://cdn-icons-png.flaticon.com/512/2921/2921222.png', trigger_logic: 'read_1' },
            { name: 'Bookworm', description: 'Read 5 books.', icon_url: 'https://cdn-icons-png.flaticon.com/512/2921/2921226.png', trigger_logic: 'read_5' },
            { name: 'Scholar', description: 'Read 10 books.', icon_url: 'https://cdn-icons-png.flaticon.com/512/2921/2921224.png', trigger_logic: 'read_10' },
            { name: 'Legend', description: 'Read 20 books.', icon_url: 'https://cdn-icons-png.flaticon.com/512/2921/2921228.png', trigger_logic: 'read_20' }
        ];

        for (const badge of badges) {
            // Check if exists
            const res = await pool.query('SELECT id FROM badges WHERE name = $1', [badge.name]);
            if (res.rows.length === 0) {
                await pool.query(
                    'INSERT INTO badges (name, description, icon_url, trigger_logic) VALUES ($1, $2, $3, $4)',
                    [badge.name, badge.description, badge.icon_url, badge.trigger_logic]
                );
                console.log(`Created badge: ${badge.name}`);
            } else {
                console.log(`Badge exists: ${badge.name}`);
            }
        }
        console.log("Badges seeded successfully!");

    } catch (err) {
        console.error("Error seeding badges:", err);
    } finally {
        pool.end();
    }
}

seedBadges();
