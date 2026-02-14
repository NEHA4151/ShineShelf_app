import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/cart_provider.dart';
import '../models/book.dart';
import 'cart_screen.dart';
import '../widgets/book_cover_image.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final bool isStoreMode;

  const BookDetailScreen({super.key, required this.book, this.isStoreMode = false});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  List<dynamic> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    final reviews = await Provider.of<BookProvider>(context, listen: false).fetchReviews(widget.book.id);
    if (mounted) {
      setState(() {
        _reviews = reviews;
        _isLoading = false;
      });
    }
  }



  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating) {
          return const Icon(Icons.star, color: Colors.amber, size: 20);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 20);
        }
      }),
    );
  }

  double _calculateAverageRating() {
    if (_reviews.isEmpty) return 0.0;
    double sum = 0.0;
    for (var r in _reviews) {
      sum += (r['rating'] as num).toDouble();
    }
    return sum / _reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => const CartScreen(),
              ));
            },
          ),
        ],
      ),
      floatingActionButton: widget.isStoreMode
          ? FloatingActionButton.extended(
              heroTag: "cart",
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).addToCart(widget.book);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to Cart!')));
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: Text("Buy ₹${widget.book.price.toStringAsFixed(2)}"),
              backgroundColor: Colors.orange,
            )
          : FloatingActionButton.extended(
              heroTag: "borrow",
              onPressed: () async {
                  final success = await Provider.of<BookProvider>(context, listen: false).borrowBook(widget.book.id);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully borrowed ${widget.book.title}! Check My Books.'), backgroundColor: Colors.green),
                    );
                  } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to borrow.'), backgroundColor: Colors.red),
                    );
                  }
              },
              icon: const Icon(Icons.book),
              label: const Text("Borrow Book"),
              backgroundColor: Colors.deepPurple,
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                child: BookCoverImage(
                  imageUrl: widget.book.coverImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(widget.book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(widget.book.author, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 8),
            // Price Display
            Text('₹${widget.book.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 22, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            // Moved Rating Below Author
            Row(
              children: [
                _buildStarRating(_calculateAverageRating()),
                const SizedBox(width: 8),
                Text("(${_reviews.length} reviews)", style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.book.description ?? 'No description.', style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 32),
            const Divider(),
            const Text("Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (_isLoading) 
              const Center(child: CircularProgressIndicator())
            else if (_reviews.isEmpty)
              const Text("No reviews yet. Be the first!")
            else
              ..._reviews.map((r) {
                final rating = (r['rating'] as num?)?.toDouble() ?? 0.0;
                final username = r['username']?.toString() ?? 'Anonymous';
                final comment = r['comment']?.toString() ?? '';
                final dateStr = r['created_at']?.toString() ?? DateTime.now().toIso8601String();
                final formattedDate = dateStr.length >= 10 ? dateStr.substring(0, 10) : dateStr;

                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) => Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    )),
                  ),
                  title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(comment),
                  trailing: Text(formattedDate, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                );
              }),
             const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
    );
  }
}
