import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // Storing joined clubs with their join date
  final Map<String, DateTime> _joinedClubs = {};

  // Mock store for discussion posts
  final Map<String, List<Map<String, dynamic>>> _clubPosts = {};

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

  void _joinClub(String clubName) {
    setState(() {
      _joinedClubs[clubName] = DateTime.now();
      // Initialize empty discussion list if not exists
      if (!_clubPosts.containsKey(clubName)) {
         _clubPosts[clubName] = [
           {
              'author': 'Admin',
              'content': 'Welcome to $clubName! Introduce yourself here.',
              'timestamp': DateTime.now().subtract(const Duration(days: 1))
           }
         ];
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Joined $clubName!')),
    );
  }

  void _openClubDiscussion(String clubName) {
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => ClubDiscussionScreen(
           clubName: clubName,
           posts: _clubPosts[clubName] ?? [],
           onPostAdded: (String content) {
             setState(() {
               _clubPosts[clubName]?.add({
                 'author': 'You', // Assuming logged-in user for mock
                 'content': content,
                 'timestamp': DateTime.now(),
               });
             });
           },
         ),
       ),
     );
  }

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
                                : () => _joinClub(club['name']!),
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
                      
                      return InkWell(
                        onTap: () => _openClubDiscussion(clubName),
                        borderRadius: BorderRadius.circular(12),
                        child: Card(
                          color: Colors.deepPurple[50],
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
                                    const Icon(Icons.chevron_right, color: Colors.deepPurple),
                                  ],
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

class ClubDiscussionScreen extends StatefulWidget {
  final String clubName;
  final List<Map<String, dynamic>> posts;
  final Function(String) onPostAdded;

  const ClubDiscussionScreen({
    super.key, 
    required this.clubName, 
    required this.posts,
    required this.onPostAdded,
  });

  @override
  State<ClubDiscussionScreen> createState() => _ClubDiscussionScreenState();
}

class _ClubDiscussionScreenState extends State<ClubDiscussionScreen> {
  final TextEditingController _postController = TextEditingController();

  void _submitPost() {
    if (_postController.text.trim().isNotEmpty) {
      widget.onPostAdded(_postController.text.trim());
      _postController.clear();
      // Need to tell this state to rebuild to show the new post
      // In a real app we'd use a state management solution (Provider, Bloc)
      // Here we just setState as the parent widget already added the post to the list passed by reference
      setState(() {}); 
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')} - ${time.day}/${time.month}/${time.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.clubName} Discussions"),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.posts.isEmpty 
               ? const Center(child: Text("No posts yet. Be the first to start a discussion!"))
               : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.posts.length,
                  itemBuilder: (context, index) {
                    final post = widget.posts[index];
                    final bool isMe = post['author'] == 'You';
                    
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.deepPurple[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12).copyWith(
                             bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                             bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              post['author'], 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: isMe ? Colors.deepPurple[800] : Colors.black87,
                              )
                            ),
                            const SizedBox(height: 4),
                            Text(post['content']),
                            const SizedBox(height: 4),
                            Text(
                              _formatTime(post['timestamp'] as DateTime),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              )
                            )
                          ],
                        ),
                      ),
                    );
                  },
               )
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))]
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      hintText: "Write a post...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                    ),
                    onSubmitted: (_) => _submitPost(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _submitPost,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
