import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import 'package:intl/intl.dart';
import '../widgets/book_cover_image.dart';

class MyBooksScreen extends StatefulWidget {
  const MyBooksScreen({super.key});

  @override
  State<MyBooksScreen> createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<BookProvider>(context, listen: false).fetchMyBooks());
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Borrowed Books'),
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, _) {
          if (bookProvider.myBooks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No Books Borrowed Yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Go to the Library to borrow books.'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookProvider.myBooks.length,
            itemBuilder: (context, index) {
              final book = bookProvider.myBooks[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Book Image
                          Container(
                            width: 80,
                            height: 120,
                             color: Colors.grey[200],
                             child: BookCoverImage(
                               imageUrl: book.coverImageUrl,
                               fit: BoxFit.cover,
                             ),
                          ),
                          const SizedBox(width: 16),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(book.author,
                                    style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 12),
                                // Transaction Info
                                _buildInfoRow('Issue Date:', _formatDate(book.issueDate)),
                                _buildInfoRow('Due Date:', _formatDate(book.dueDate)),
                                _buildInfoRow('Fine:', '₹${book.fineAmount?.toStringAsFixed(2) ?? "0.00"}', 
                                  isRed: (book.fineAmount ?? 0) > 0),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Return Button
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final success = await Provider.of<BookProvider>(context, listen: false).returnBook(book.id);
                                  if (success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Book returned successfully!')),
                                      );
                                  }
                                },
                                icon: const Icon(Icons.assignment_return, size: 16),
                                label: const Text('Return', style: TextStyle(fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _showReviewDialog(book.id),
                                icon: const Icon(Icons.rate_review, size: 16),
                                label: const Text('Review', style: TextStyle(fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showReviewDialog(int bookId) {
    double rating = 5.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Write a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               const Text("Rate this book:"),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: List.generate(5, (index) {
                   return IconButton(
                     icon: Icon(
                       index < rating ? Icons.star : Icons.star_border,
                       color: Colors.amber,
                       size: 32,
                     ),
                     onPressed: () {
                       setState(() {
                         rating = index + 1.0;
                       });
                     },
                   );
                 }),
               ),
               TextField(
                 controller: commentController,
                 decoration: const InputDecoration(labelText: 'Comment'),
                 maxLines: 3,
               ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                 final success = await Provider.of<BookProvider>(context, listen: false)
                    .addReview(bookId, rating, commentController.text);
                 Navigator.pop(ctx);
                 if (success) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review added!')));
                 } else {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add review.')));
                 }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          const SizedBox(width: 8),
          Text(value, style: TextStyle(fontSize: 13, color: isRed ? Colors.red : Colors.black87)),
        ],
      ),
    );
  }
}
