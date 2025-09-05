import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Color constants are now local to this file
const Color darkBackground = Color(0xFF0A0E27);
const Color cardBackground = Color(0xFF1A2235);
const Color textPrimary = Color(0xFFFFFFFF);
const Color textSecondary = Color(0xFFB0BEC5);
const Color accentColor = Color(0xFF4FC3F7);
const Color primaryTeal = Color(0xFF00D4AA);

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final List<Map<String, dynamic>> _assistants = [
    {'name': 'Text-to-Speech', 'icon': Icons.record_voice_over_rounded, 'color': Colors.green},
    {'name': 'Simplify', 'icon': Icons.auto_fix_high_rounded, 'color': Colors.blue},
    {'name': 'LexiType', 'icon': Icons.keyboard_alt_rounded, 'color': Colors.purple},
    {'name': 'Dictionary', 'icon': Icons.menu_book_rounded, 'color': Colors.amber},
    {'name': 'PDF/Doc Reader', 'icon': Icons.picture_as_pdf_rounded, 'color': Colors.red},
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _onItemTapped(int index) {
    if (index == 2) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/adminDashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/userManagement');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      case 4:
        // Handle sign out
        Navigator.pushReplacementNamed(context, '/login');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        title: const Text(
          'Content & Assistants',
          style: TextStyle(
            color: textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: cardBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Content Library', showViewAll: false),
              const SizedBox(height: 16),
              _buildContentList(),
              const SizedBox(height: 40),
              _buildSectionHeader('Assistants', showViewAll: false),
              const SizedBox(height: 16),
              _buildAssistantsGrid(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1F2B),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB((0.3 * 255).round(), Colors.black.red, Colors.black.green, Colors.black.blue),
              offset: const Offset(0, 4),
              blurRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            currentIndex: 2, // Highlight the Content icon
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            selectedItemColor: primaryTeal,
            unselectedItemColor: const Color(0xFF6B7280),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded, size: 24),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded, size: 24),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder_rounded, size: 24),
                label: 'Content',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded, size: 24),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout_rounded, size: 24),
                label: 'Sign Out',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showViewAll = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (showViewAll)
          TextButton(
            onPressed: () {},
            child: const Text('View All', style: TextStyle(color: accentColor)),
          ),
      ],
    );
  }

  Widget _buildContentList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('content').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading content.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No content found.'));
          }

          final contentList = snapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: contentList.length,
            itemBuilder: (context, index) {
              final doc = contentList[index];
              return _ContentTile(
                title: doc['title'] ?? 'Untitled Document',
                subtitle: doc['type'] ?? 'Unknown',
                color: primaryTeal,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAssistantsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _assistants.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final assistant = _assistants[index];
        return _AssistantCard(
          name: assistant['name'],
          icon: assistant['icon'],
          color: assistant['color'],
        );
      },
    );
  }
}

class _ContentTile extends StatelessWidget {
  const _ContentTile({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.fromARGB(51, color.red, color.green, color.blue),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.description_rounded, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.more_vert,
            color: textSecondary,
          ),
        ],
      ),
    );
  }
}

class _AssistantCard extends StatelessWidget {
  const _AssistantCard({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.fromARGB(51, color.red, color.green, color.blue),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(25, Colors.black.red, Colors.black.green, Colors.black.blue),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 40),
          Text(
            name,
            style: const TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
