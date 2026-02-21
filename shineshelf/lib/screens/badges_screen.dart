import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Achievements')),
      body: FutureBuilder<List<dynamic>>(
        future: Provider.of<AuthProvider>(context, listen: false).fetchMyBadges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No badges yet!", style: TextStyle(fontSize: 20)),
                  Text("Read books to earn badges."),
                ],
              ),
            );
          }

          final badges = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              return Card(
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(badge['icon_url'], height: 60, width: 60, errorBuilder: (c,e,s) => const Icon(Icons.star, size: 50, color: Colors.amber)),
                    const SizedBox(height: 12),
                    Text(badge['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(badge['description'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
