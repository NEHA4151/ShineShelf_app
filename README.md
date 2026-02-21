# ShineShelf - Modern Library Management System

![ShineShelf Banner](https://img.shields.io/badge/ShineShelf-Library_Management-blueviolet?style=for-the-badge)

ShineShelf is a comprehensive Library Management System (LMS) designed for a modern reading experience. It combines a robust Node.js/PostgreSQL backend with a beautiful, high-performance Flutter frontend to provide seamless book management, gamification, and transaction handling.

## 🚀 Key Features

### 🛍️ Smart Checkout & Payments
- **Multi-Gateway Support**: Support for UPI, Credit/Debit Cards, Net Banking, and Cash on Delivery (COD).
- **Payment Stimulation**: A built-in sandbox for developers to simulate successful and failed payment scenarios across all gateways safely.

### 🏆 Gamified Achievements
- **Premium Badge System**: Earn beautifully designed badges for reading milestones.
- **Glassmorphic UI**: Experience a modern, transparent UI with vibrant gradients for all your trophies.
- **Milestones**: "First Chapter", "High Five", "Perfect Ten", and "Literary Legend" badges.

### 📚 Comprehensive Library Management
- **Book Discovery**: Browse through an extensive collection with detailed metadata.
- **Transaction History**: Track your borrowed books, due dates, and inventory status in real-time.
- **Community Features**: Future-ready integration for clubs and reviews.

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Node.js, Express
- **Database**: PostgreSQL
- **Architecture**: Provider-based state management (Frontend), RESTful API (Backend)

## 🛠️ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Ensure `flutter` is in your PATH)
- [Node.js](https://nodejs.org/)
- [PostgreSQL](https://www.postgresql.org/)

### 📂 Setup Instructions

#### 1. Backend Setup
1. Navigate to the `backend/` folder.
2. Install dependencies: `npm install`.
3. Configure your `.env` file with database credentials.
4. Run the database migration/seeding:
   ```bash
   psql -d shineshelf -f ../init.sql
   psql -d shineshelf -f seed_badges.sql
   ```
5. Start the server: `node index.js` (or use the `start_server.bat` file in the root).

#### 2. Frontend Setup
1. Navigate to the `shineshelf/` folder.
2. Install dependencies: `flutter pub get`.
3. Run the application: `flutter run`.

## 🤝 Contributing
Contributions are welcome! Feel free to open issues or submit pull requests to enhance the ShineShelf experience.

---
*Developed with passion for readers everywhere.*
