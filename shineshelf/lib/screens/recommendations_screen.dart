import 'package:flutter/material.dart';
import '../models/book.dart';
import 'book_detail_screen.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('For You'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Based on your recent read "1984"',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRecCard(
              context,
              'Brave New World',
              'Aldous Huxley',
              'A futuristic society where citizens are genetically bred and conditioned to perform labor and are happy with their predetermined role. The story follows a natural-born man who challenges this dystopian world.',
              'https://upload.wikimedia.org/wikipedia/en/6/62/BraveNewWorld_FirstEdition.jpg',
            ),
            _buildRecCard(
              context,
              'Fahrenheit 451',
              'Ray Bradbury',
              'A future American society where books are outlawed and "firemen" burn any that are found. The story traces the evolution of Guy Montag, a fireman who starts to question his task.',
              'https://upload.wikimedia.org/wikipedia/en/d/db/Fahrenheit_451_1st_ed_cover.jpg',
            ),
             const SizedBox(height: 24),
             const Text(
              'Trending in Classics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRecCard(
              context,
              'Pride and Prejudice',
              'Jane Austen',
              'A romantic novel of manners written by Jane Austen in 1813. The novel follows the character development of Elizabeth Bennet, the dynamic protagonist of the book who learns about the repercussions of hasty judgments.',
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/PrideAndPrejudiceTitlePage.jpg/800px-PrideAndPrejudiceTitlePage.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecCard(BuildContext context, String title, String author, String desc, String imgUrl) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 120,
            color: Colors.grey[200],
            child: Image.network(imgUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.book)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(author, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          // Create a dummy book for display logic
                          // ID is 0, so reviews won't work on these dummy recommendations unless they exist in DB
                          final dummyBook = Book(
                            id: 0, 
                            title: title, 
                            author: author, 
                            description: desc, 
                            coverImageUrl: imgUrl
                          );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookDetailScreen(book: dummyBook)
                                )
                            );
                        }, 
                        child: const Text("View Details")
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
