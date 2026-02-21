import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // Storing joined clubs with their join date
  final Map<String, DateTime> _joinedClubs = {};

  final List<Map<String, String>> clubs = [
    {
      'name': 'The Classics Club',
      'description': 'Discussing timeless masterpieces every Friday.',
      'members': '124 members',
      'created_at': '2023-01-15'
    },
    {
      'name': 'Sci-Fi Explorers',
      'description': 'Journey to other worlds with fellow sci-fi geeks.',
      'members': '89 members',
      'created_at': '2023-03-10'
    },
    {
      'name': 'Mystery Solvers',
      'description': 'Can you figure out whodunnit before the last chapter?',
      'members': '210 members',
      'created_at': '2022-11-05'
    },
    {
      'name': 'Non-Fiction Grow',
      'description': 'Learning and self-improvement together.',
      'members': '56 members',
      'created_at': '2023-06-20'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Community Clubs'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "All Clubs"),
              Tab(text: "My Clubs"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: All Clubs
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: clubs.length,
              itemBuilder: (context, index) {
                final club = clubs[index];
                final isJoined = _joinedClubs.containsKey(club['name']);

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
                         const SizedBox(height: 4),
                        Text(
                          'Created: ${club['created_at']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isJoined 
                                ? null 
                                : () {
                                    setState(() {
                                      _joinedClubs[club['name']!] = DateTime.now();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Joined ${club['name']}!')),
                                    );
                                  },
                            child: Text(isJoined ? 'Joined' : 'Join Now'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Tab 2: My Clubs
            _joinedClubs.isEmpty
                ? const Center(child: Text("You haven't joined any clubs yet."))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _joinedClubs.length,
                    itemBuilder: (context, index) {
                      final clubName = _joinedClubs.keys.elementAt(index);
                      final joinedDate = _joinedClubs[clubName];
                      // Find club details
                      final club = clubs.firstWhere((c) => c['name'] == clubName);
                      
                      return Card(
                        color: Colors.deepPurple[50],
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                club['name']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(club['description']!),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Status: Member", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  Text(
                                    'Joined: ${joinedDate?.year}-${joinedDate?.month.toString().padLeft(2,'0')}-${joinedDate?.day.toString().padLeft(2,'0')}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
