import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'book_detail_screen.dart';

class BookStoreScreen extends StatefulWidget {
  const BookStoreScreen({super.key});

  @override
  State<BookStoreScreen> createState() => _BookStoreScreenState();
}

class _BookStoreScreenState extends State<BookStoreScreen> {
  @override
  void initState() {
    super.initState();
     // Ensure books are loaded
     Future.delayed(Duration.zero, () {
       Provider.of<BookProvider>(context, listen: false).fetchBooks();
     });
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const CartScreen()),
              );
            },
          )
        ],
      ),
      body: bookProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: bookProvider.books.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 4 : (MediaQuery.of(context).size.width > 800 ? 3 : 2),
                childAspectRatio: 0.55,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) {
                final book = bookProvider.books[i];
                return GestureDetector(
                  onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailScreen(book: book, isStoreMode: true),
                    ),
                  );
                },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: book.coverImageUrl != null
                                ? Image.network(book.coverImageUrl!, fit: BoxFit.cover)
                                : const Icon(Icons.book, size: 50),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(book.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text('₹${book.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  cart.addToCart(book);
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Added to Cart!')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(double.infinity, 30),
                                ),
                                child: const Text('Add to Cart'),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
