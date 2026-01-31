import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> clubs = [
      {
        'name': 'The Classics Club',
        'description': 'Discussing timeless masterpieces every Friday.',
        'members': '124 members'
      },
      {
        'name': 'Sci-Fi Explorers',
        'description': 'Journey to other worlds with fellow sci-fi geeks.',
        'members': '89 members'
      },
      {
        'name': 'Mystery Solvers',
        'description': 'Can you figure out whodunnit before the last chapter?',
        'members': '210 members'
      },
      {
        'name': 'Non-Fiction Grow',
        'description': 'Learning and self-improvement together.',
        'members': '56 members'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Clubs'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          final club = clubs[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        club['name']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Chip(
                        label: Text(club['members']!, style: const TextStyle(fontSize: 10)),
                        backgroundColor: Colors.deepPurple.withOpacity(0.1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(club['description']!),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Joined ${club['name']}!')),
                        );
                      },
                      child: const Text('Join Now'),
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
