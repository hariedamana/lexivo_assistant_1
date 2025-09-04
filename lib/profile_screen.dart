import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Import the ChatbotScreen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Light Theme Colors
    const backgroundColor = Color(0xFFF5F5F5);
    const cardColor = Colors.white;
    const accentColor = Color(0xFF00E5A0); // Main accent
    const secondaryAccent = Color(0xFF6366F1);
    const tertiaryAccent = Color(0xFFEC4899);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: accentColor.withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(Icons.edit_outlined, color: accentColor, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Profile Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [accentColor, secondaryAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded, size: 40, color: accentColor),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Hello, Hari",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Premium User",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Account Settings Header
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Settings',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Account Options
              _buildOptionTile(
                context,
                Icons.person_outline_rounded,
                "User Information",
                "Manage your personal details",
                accentColor,
                cardColor,
              ),
              const SizedBox(height: 16),
              _buildOptionTile(
                context,
                Icons.bar_chart_rounded,
                "Progress",
                "View your learning statistics",
                secondaryAccent,
                cardColor,
              ),
              const SizedBox(height: 16),
              _buildOptionTile(
                context,
                Icons.settings_outlined,
                "Settings",
                "Customize app preferences",
                tertiaryAccent,
                cardColor,
              ),
              const SizedBox(height: 32),

              // App Info Header
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'App Information',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // App Info Options
              _buildOptionTile(
                context,
                Icons.info_outline_rounded,
                "Application Info",
                "Version and app details",
                Color(0xFFF59E0B),
                cardColor,
              ),
              const SizedBox(height: 16),
              _buildOptionTile(
                context,
                Icons.description_outlined,
                "Terms and Conditions",
                "Legal information and policies",
                Color(0xFF8B5CF6),
                cardColor,
              ),
              const SizedBox(height: 16),
              _buildOptionTile(
                context,
                Icons.logout_rounded,
                "Logout",
                "Sign out of your account",
                Color(0xFFEF4444),
                cardColor,
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildOptionTile(
      BuildContext context, IconData icon, String title, String subtitle, Color color, Color cardColor) {
    return GestureDetector(
      onTap: () => _handleOptionTap(context, title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color.withOpacity(0.8), size: 16),
          ],
        ),
      ),
    );
  }

  void _handleOptionTap(BuildContext context, String title) {
    switch (title) {
      case "User Information":
      case "Progress":
      case "Settings":
      case "Terms and Conditions":
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opening $title..."), backgroundColor: Colors.grey[700]),
        );
        break;
      case "Application Info":
        _showAppInfoDialog(context);
        break;
      case "Logout":
        _showLogoutDialog(context);
        break;
    }
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Application Info", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Version: 1.0.0", style: TextStyle(color: Colors.black54)),
            SizedBox(height: 8),
            Text("Build: 2024.1", style: TextStyle(color: Colors.black54)),
            SizedBox(height: 8),
            Text("Developed with Flutter", style: TextStyle(color: Colors.black54)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Color(0xFF00E5A0))),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
        content: const Text("Are you sure you want to sign out?", style: TextStyle(color: Colors.black54)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out successfully"), backgroundColor: Color(0xFFEF4444)),
              );
            },
            child: const Text("Logout", style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    const selectedColor = Color(0xFF00E5A0);
    const unselectedColor = Colors.grey;
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), offset: Offset(0, 4), blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          currentIndex: 3,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/assistants');
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen()));
                break;
              case 3:
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 26), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.apps_rounded, size: 26), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded, size: 26), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded, size: 26), label: ''),
          ],
        ),
      ),
    );
  }
}
