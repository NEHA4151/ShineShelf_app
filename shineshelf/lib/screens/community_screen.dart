import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // Simulating joined clubs in local state for now
  final List<String> _joinedClubNames = [];

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
                final isJoined = _joinedClubNames.contains(club['name']);

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
                            onPressed: isJoined 
                                ? null 
                                : () {
                                    setState(() {
                                      _joinedClubNames.add(club['name']!);
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
            _joinedClubNames.isEmpty
                ? const Center(child: Text("You haven't joined any clubs yet."))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _joinedClubNames.length,
                    itemBuilder: (context, index) {
                      final clubName = _joinedClubNames[index];
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
                              const Text("Status: Member", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
