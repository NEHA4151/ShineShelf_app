import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Achievements', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Provider.of<AuthProvider>(context, listen: false).fetchMyBadges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                     padding: const EdgeInsets.all(32),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       shape: BoxShape.circle,
                       boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, spreadRadius: 5)],
                     ),
                     child: Icon(Icons.emoji_events_outlined, size: 80, color: Colors.amber.withOpacity(0.3)),
                   ),
                  const SizedBox(height: 24),
                  const Text("No badges yet!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  const Text("Start your reading journey to earn rewards.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final badges = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 20, 
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              return _BadgeCard(badge: badge);
            },
          );
        },
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final dynamic badge;

  const _BadgeCard({required this.badge});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'badge_first_chapter':
        return Icons.auto_stories;
      case 'badge_high_five':
        return Icons.front_hand;
      case 'badge_perfect_ten':
        return Icons.workspace_premium;
      case 'badge_legend':
        return Icons.auto_awesome;
      default:
        return Icons.star;
    }
  }

  List<Color> _getGradient(String iconName) {
     switch (iconName) {
      case 'badge_first_chapter':
        return [Colors.blue, Colors.lightBlueAccent];
      case 'badge_high_five':
        return [Colors.orange, Colors.amber];
      case 'badge_perfect_ten':
        return [Colors.purple, Colors.deepPurpleAccent];
      case 'badge_legend':
        return [Colors.red, Colors.orangeAccent];
      default:
        return [Colors.grey, Colors.blueGrey];
    }
  }

  @override
  Widget build(BuildContext context) {
    final String iconName = badge['icon_url'] ?? '';
    final gradient = _getGradient(iconName);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background soft gradient spot
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: gradient[0].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIconData(iconName),
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  badge['name'] ?? 'Badge',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF2D3142),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  badge['description'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blueGrey.withOpacity(0.7),
                    height: 1.2,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
