import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Import the ChatbotScreen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A), // Deep dark background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1F2B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFF00E5A0).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Color(0xFF00E5A0),
                        size: 24,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Profile Header Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00E5A0).withOpacity(0.1),
                        const Color(0xFF00C4CC).withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF00E5A0).withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E5A0).withOpacity(0.1),
                        offset: const Offset(0, 8),
                        blurRadius: 32,
                        spreadRadius: 0,
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
                            colors: [
                              const Color(0xFF00E5A0),
                              const Color(0xFF00C4CC),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1F2B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 40,
                            color: Color(0xFF00E5A0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Hello, Hari",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5A0).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Premium User",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00E5A0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Profile Menu Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Account Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Profile Options
                _buildModernProfileOption(
                  context,
                  Icons.person_outline_rounded,
                  "User  Information",
                  "Manage your personal details",
                  const Color(0xFF00E5A0),
                ),
                const SizedBox(height: 16),
                _buildModernProfileOption(
                  context,
                  Icons.bar_chart_rounded,
                  "Progress",
                  "View your learning statistics",
                  const Color(0xFF6366F1),
                ),
                const SizedBox(height: 16),
                _buildModernProfileOption(
                  context,
                  Icons.settings_outlined,
                  "Settings",
                  "Customize app preferences",
                  const Color(0xFFEC4899),
                ),

                const SizedBox(height: 32),

                // App Info Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'App Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _buildModernProfileOption(
                  context,
                  Icons.info_outline_rounded,
                  "Application Info",
                  "Version and app details",
                  const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 16),
                _buildModernProfileOption(
                  context,
                  Icons.description_outlined,
                  "Terms and Conditions",
                  "Legal information and policies",
                  const Color(0xFF8B5CF6),
                ),
                const SizedBox(height: 16),
                _buildModernProfileOption(
                  context,
                  Icons.logout_rounded,
                  "Logout",
                  "Sign out of your account",
                  const Color(0xFFEF4444),
                ),

                const SizedBox(height: 120), // Extra space for bottom navigation
              ],
            ),
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1F2B),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF00E5A0), // Bright teal
            unselectedItemColor: const Color(0xFF6B7280),
            currentIndex: 3, // Profile page index
            type: BottomNavigationBarType.fixed,
            elevation: 0,
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatbotScreen(initialTabIndex: 2), // Highlight Chatbot tab
                    ),
                  );
                  break;
                case 3:
                  // Already in Profile
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 26),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apps_rounded, size: 26),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_rounded, size: 26),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded, size: 26),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernProfileOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        // Add specific navigation based on title
        _handleProfileOptionTap(context, title);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1F2B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.2),
                    color.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleProfileOptionTap(BuildContext context, String title) {
    // Handle specific navigation or actions based on the option selected
    switch (title) {
      case "User  Information":
        // Navigate to user info page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Opening $title..."),
            backgroundColor: const Color(0xFF00E5A0),
          ),
        );
        break;
      case "Progress":
        // Navigate to progress page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Opening $title..."),
            backgroundColor: const Color(0xFF6366F1),
          ),
        );
        break;
      case "Settings":
        // Navigate to settings page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Opening $title..."),
            backgroundColor: const Color(0xFFEC4899),
          ),
        );
        break;
      case "Application Info":
        // Show app info dialog
        _showAppInfoDialog(context);
        break;
      case "Terms and Conditions":
        // Navigate to terms page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Opening $title..."),
            backgroundColor: const Color(0xFF8B5CF6),
          ),
        );
        break;
      case "Logout":
        // Show logout confirmation
        _showLogoutDialog(context);
        break;
    }
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1F2B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Application Info",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Version: 1.0.0",
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
              SizedBox(height: 8),
              Text(
                "Build: 2024.1",
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
              SizedBox(height: 8),
              Text(
                "Developed with Flutter",
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Close",
                style: TextStyle(color: Color(0xFF00E5A0)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1F2B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Logout",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            "Are you sure you want to sign out of your account?",
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add logout functionality here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logged out successfully"),
                    backgroundColor: Color(0xFFEF4444),
                  ),
                );
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
          ],
        );
      },
    );
  }
}