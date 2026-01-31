import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

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

  void _showReviewDialog() {
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
               Slider(
                 value: rating,
                 min: 1,
                 max: 5,
                 divisions: 4,
                 label: rating.round().toString(),
                 onChanged: (val) => setState(() => rating = val),
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
                    .addReview(widget.book.id, rating, commentController.text);
                 Navigator.pop(ctx);
                 if (success) {
                   _fetchReviews(); // Refresh
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review added!')));
                 } else {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add review. Did you already review it?')));
                 }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showReviewDialog,
        icon: const Icon(Icons.rate_review),
        label: const Text("Write Review"),
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
                child: widget.book.coverImageUrl != null
                    ? Image.network(widget.book.coverImageUrl!, fit: BoxFit.cover)
                    : const Icon(Icons.book, size: 100),
              ),
            ),
            const SizedBox(height: 24),
            Text(widget.book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(widget.book.author, style: const TextStyle(fontSize: 18, color: Colors.grey)),
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
              ..._reviews.map((r) => ListTile(
                leading: CircleAvatar(child: Text(r['rating'].toString())),
                title: Text(r['username']),
                subtitle: Text(r['comment']),
                trailing: Text(r['created_at'].substring(0, 10), style: const TextStyle(fontSize: 10)),
              )),
             const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
    );
  }
}
