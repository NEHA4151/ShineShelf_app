import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/book_provider.dart';
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
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // Taller aspect ratio for larger images
                    childAspectRatio: 0.5, 
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: bookProvider.books.length,
                  itemBuilder: (ctx, i) {
                    final book = bookProvider.books[i];
                    return Card(
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Larger Image (Increased height)
                          SizedBox(
                            height: 200, 
                            child: book.coverImageUrl != null
                                ? Image.network(
                                    book.coverImageUrl!, 
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.book, size: 40, color: Colors.grey),
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.book, size: 40, color: Colors.grey),
                                  ),
                          ),
                          // 2. Details
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title, 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), 
                                    maxLines: 1, 
                                    overflow: TextOverflow.ellipsis
                                  ),
                                  Text(
                                    book.author, 
                                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: Text(
                                      book.description ?? 'No description.',
                                      style: const TextStyle(fontSize: 10),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // 3. Borrow Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 30, // Compact button
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Colors.deepPurple[100],
                                      ),
                                      onPressed: () async {
                                        final success = await Provider.of<BookProvider>(context, listen: false).borrowBook(book.id);
                                        if (success) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Successfully borrowed ${book.title}! Check My Books.')),
                                          );
                                        } else {
                                           ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Failed to borrow. Might be out of stock.')),
                                          );
                                        }
                                      },
                                      child: const Text('Borrow', style: TextStyle(fontSize: 12)),
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
