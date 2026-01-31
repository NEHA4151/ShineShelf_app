import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/book_provider.dart';
import '../providers/theme_provider.dart';
import 'my_books_screen.dart';
import 'community_screen.dart';
import 'recommendations_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<BookProvider>(context, listen: false).fetchBooks());
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final bookProvider = Provider.of<BookProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shineshelf Library'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.username ?? 'Guest'),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.recommend),
              title: const Text('Recommendations'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecommendationsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('My Books'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyBooksScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Community Clubs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CommunityScreen()),
                );
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              secondary: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
            const Divider(),
             ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                 Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
      body: bookProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookProvider.books.isEmpty
              ? const Center(child: Text("No books available in the library."))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.60,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: bookProvider.books.length,
                  itemBuilder: (ctx, i) {
                    final book = bookProvider.books[i];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Full Bleed Image
                          Expanded(
                            flex: 4, 
                            child: Stack(
                                fit: StackFit.expand,
                                children: [
                                    book.coverImageUrl != null
                                    ? Image.network(
                                        book.coverImageUrl!, 
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          color: Colors.grey[800],
                                          child: const Icon(Icons.book, size: 50, color: Colors.white54),
                                        ),
                                      )
                                    : Container(
                                        color: Colors.grey[800],
                                        child: const Icon(Icons.book, size: 50, color: Colors.white54),
                                      ),
                                    // Gradient overlay for better text readability if we put text on image, 
                                    // but we are putting text below. 
                                ]
                            )
                          ),
                          // 2. Details Section
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title, 
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 14,
                                        color: isDark ? Colors.white : Colors.black87
                                    ), 
                                    maxLines: 1, 
                                    overflow: TextOverflow.ellipsis
                                  ),
                                  Text(
                                    book.author, 
                                    style: TextStyle(
                                        color: isDark ? Colors.grey[400] : Colors.grey[700], 
                                        fontSize: 12
                                    ),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 6),
                                  Expanded(
                                    child: Text(
                                      book.description ?? 'No description.',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? Colors.grey[300] : Colors.black54
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // 3. Borrow Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 36,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: isDark ? Colors.deepPurple[200] : Colors.deepPurple,
                                        foregroundColor: isDark ? Colors.black : Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        elevation: 0,
                                      ),
                                      onPressed: () async {
                                        final success = await Provider.of<BookProvider>(context, listen: false).borrowBook(book.id);
                                        if (success) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text('Successfully borrowed ${book.title}! Check My Books.'),
                                                backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else {
                                           ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text('Failed to borrow. Might be out of stock.'),
                                                backgroundColor: Colors.red[400],
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Borrow', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
