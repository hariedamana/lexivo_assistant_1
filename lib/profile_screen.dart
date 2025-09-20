import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart'; // Assuming this is for navigation
import 'tts_service.dart'; // Assuming this is for a tool page
import 'lexi_type.dart'; // Assuming this is for a tool page
import 'simplify_assistant.dart'; // Assuming this is for a tool page
import 'correct_me.dart'; // Assuming this is for a tool page

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dark theme colors for consistency
  static const Color primaryDark = Color(0xFF0F0F0F);
  static const Color secondaryDark = Color(0xFF1A1A1A);
  static const Color cardDark = Color(0xFF242424);
  static const Color accentGreen = Color(0xFF00D4AA);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color borderColor = Color(0xFF333333);
  static const Color secondaryAccent = Color(0xFF6366F1);
  static const Color tertiaryAccent = Color(0xFFEC4899);
  static const Color accentYellow = Color(0xFFF59E0B);
  static const Color accentTeal = Color(0xFF10B981);

  // Dyslexic-friendly settings
  final double _textScale = 1.0;

  // Professional stats data
  final List<Map<String, dynamic>> _statsData = [
    {
      'title': 'Lessons Completed',
      'value': '127',
      'icon': Icons.task_alt_rounded,
      'color': accentGreen,
      'change': '+12 this week',
    },
    {
      'title': 'Current Streak',
      'value': '15',
      'icon': Icons.local_fire_department_rounded,
      'color': accentRed,
      'change': 'days',
    },
    {
      'title': 'Time Saved',
      'value': '23h',
      'icon': Icons.schedule_rounded,
      'color': accentBlue,
      'change': 'this month',
    },
  ];

  // Professional account options
  final List<Map<String, dynamic>> _accountOptions = [
    {
      'title': "Personal Information",
      'subtitle': "Manage your account details and preferences",
      'icon': Icons.person_outline_rounded,
      'color': accentGreen,
      'category': 'account',
    },
    {
      'title': "Learning Progress",
      'subtitle': "View detailed analytics and achievements",
      'icon': Icons.trending_up_rounded,
      'color': secondaryAccent,
      'category': 'account',
    },
    {
      'title': "Subscription & Billing",
      'subtitle': "Manage your premium subscription",
      'icon': Icons.credit_card_rounded,
      'color': tertiaryAccent,
      'category': 'account',
    },
    {
      'title': "Privacy & Security",
      'subtitle': "Control your data and security settings",
      'icon': Icons.security_rounded,
      'color': accentPurple,
      'category': 'account',
    },
  ];

  final List<Map<String, dynamic>> _appOptions = [
    {
      'title': "Notifications",
      'subtitle': "Customize your notification preferences",
      'icon': Icons.notifications_outlined,
      'color': accentBlue,
      'category': 'app',
    },
    {
      'title': "Accessibility",
      'subtitle': "Adjust app settings for better accessibility",
      'icon': Icons.accessibility_rounded,
      'color': accentTeal,
      'category': 'app',
    },
    {
      'title': "Language & Region",
      'subtitle': "Set your preferred language and region",
      'icon': Icons.language_rounded,
      'color': accentYellow,
      'category': 'app',
    },
  ];

  final List<Map<String, dynamic>> _supportOptions = [
    {
      'title': "Help Center",
      'subtitle': "Get answers to frequently asked questions",
      'icon': Icons.help_outline_rounded,
      'color': accentBlue,
      'category': 'support',
    },
    {
      'title': "Contact Support",
      'subtitle': "Reach out to our support team",
      'icon': Icons.support_agent_rounded,
      'color': accentTeal,
      'category': 'support',
    },
    {
      'title': "Send Feedback",
      'subtitle': "Help us improve the app with your feedback",
      'icon': Icons.feedback_outlined,
      'color': accentGreen,
      'category': 'support',
    },
    {
      'title': "About",
      'subtitle': "App version and legal information",
      'icon': Icons.info_outline_rounded,
      'color': accentYellow,
      'category': 'support',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: primaryDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Collapsing Header with Profile Card
          SliverAppBar(
            backgroundColor: primaryDark,
            elevation: 0,
            floating: true,
            pinned: true,
            expandedHeight: 320,
            leading: const SizedBox.shrink(), // No back button on a main screen
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding: EdgeInsets.fromLTRB(24, topPadding + 20, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildEnhancedProfileCard(),
                  ],
                ),
              ),
            ),
          ),
          
          // Stats Section (SliverToBoxAdapter)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildStatsSection(),
            ),
          ),
          
          // Account Settings Section (SliverList)
          _buildSliverSection('Account Settings', _accountOptions),
          
          // App Settings Section (SliverList)
          _buildSliverSection('App Settings', _appOptions),
          
          // Support Section (SliverList)
          _buildSliverSection('Support', _supportOptions),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: _buildLogoutSection(),
            ),
          ),
          
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
          ),
        ],
      ),
    );
  }

  // Helper method for the profile header and edit button
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                color: textPrimary,
                fontSize: 28 * _textScale,
                fontWeight: FontWeight.w700,
                fontFamily: 'Lexend',
              ),
            ),
            Text(
              'Manage your account and preferences',
              style: TextStyle(
                color: textSecondary,
                fontSize: 14 * _textScale,
                fontFamily: 'Lexend',
              ),
            ),
          ],
        ),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildActionButton() {
    return Container(
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentGreen.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            // Implement edit profile logic here
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.edit_outlined,
              color: accentGreen,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
  
  // Helper method to build the enhanced profile card
  Widget _buildEnhancedProfileCard() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          // Professional Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [accentGreen.withOpacity(0.8), secondaryAccent.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: cardDark,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                size: 36,
                color: accentGreen,
              ),
            ),
          ),
          const SizedBox(width: 20),
          // User Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hari",
                  style: TextStyle(
                    fontSize: 20 * _textScale,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    fontFamily: 'Lexend',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "hari@example.com",
                  style: TextStyle(
                    fontSize: 14 * _textScale,
                    color: textSecondary,
                    fontFamily: 'Lexend',
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentGreen.withOpacity(0.2), secondaryAccent.withOpacity(0.2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accentGreen.withOpacity(0.3)),
                  ),
                  child: Text(
                    "Premium Member",
                    style: TextStyle(
                      fontSize: 12 * _textScale,
                      fontWeight: FontWeight.w600,
                      color: accentGreen,
                      fontFamily: 'Lexend',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to build the stats section
  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: TextStyle(
            color: textPrimary,
            fontSize: 18 * _textScale,
            fontWeight: FontWeight.w600,
            fontFamily: 'Lexend',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: _statsData.asMap().entries.map((entry) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: entry.key < _statsData.length - 1 ? 12 : 0,
                ),
                child: _buildStatCard(entry.value),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper method to build a stat card
  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (stat['color'] as Color).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            stat['icon'],
            color: stat['color'],
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            stat['value'],
            style: TextStyle(
              fontSize: 20 * _textScale,
              fontWeight: FontWeight.w700,
              color: textPrimary,
              fontFamily: 'Lexend',
            ),
          ),
          Text(
            stat['title'],
            style: TextStyle(
              fontSize: 11 * _textScale,
              color: textSecondary,
              fontFamily: 'Lexend',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat['change'],
            style: TextStyle(
              fontSize: 10 * _textScale,
              color: stat['color'],
              fontWeight: FontWeight.w500,
              fontFamily: 'Lexend',
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a sliver section
  Widget _buildSliverSection(String title, List<Map<String, dynamic>> options) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Text(
                title,
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 18 * _textScale,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Lexend',
                ),
              ),
            );
          }
          final option = options[index - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: _buildProfessionalOptionTile(
              context,
              option['icon'] as IconData,
              option['title'] as String,
              option['subtitle'] as String,
              option['color'] as Color,
            ),
          );
        },
        childCount: options.length + 1,
      ),
    );
  }

  // Helper method to build an interactive option tile
  Widget _buildProfessionalOptionTile(
      BuildContext context, IconData icon, String title, String subtitle, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _handleOptionTap(context, title);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15 * _textScale,
                          fontFamily: 'Lexend',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 12 * _textScale,
                          fontFamily: 'Lexend',
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: textSecondary.withOpacity(0.6),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Container(
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentRed.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _showLogoutDialog(context);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.logout_rounded, color: accentRed, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15 * _textScale,
                          fontFamily: 'Lexend',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Sign out of your account',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 12 * _textScale,
                          fontFamily: 'Lexend',
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: accentRed.withOpacity(0.6),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// OPTION HANDLER - Enhanced for professional options
  void _handleOptionTap(BuildContext context, String title) {
    switch (title) {
      case "Personal Information":
      case "Learning Progress":
      case "Subscription & Billing":
      case "Privacy & Security":
      case "Notifications":
      case "Accessibility":
      case "Language & Region":
      case "Help Center":
      case "Contact Support":
        _showComingSoonSnackBar(context, title);
        break;
      case "Send Feedback":
        _showFeedbackDialog(context);
        break;
      case "About":
        _showAppInfoDialog(context);
        break;
    }
  }

  void _showComingSoonSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$feature is coming soon!",
          style: TextStyle(fontFamily: 'Lexend', color: textPrimary),
        ),
        backgroundColor: cardDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// APP INFO DIALOG - Enhanced
  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.info_outline_rounded, color: accentYellow, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              "About LexiLearn",
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w700,
                fontFamily: 'Lexend',
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Version", "1.0.0"),
            _buildInfoRow("Build", "2024.12.1"),
            _buildInfoRow("Platform", "Flutter 3.16"),
            _buildInfoRow("License", "MIT License"),
            const SizedBox(height: 16),
            Text(
              "LexiLearn helps individuals with dyslexia improve their reading and comprehension through personalized AI assistance.",
              style: TextStyle(
                color: textSecondary,
                fontFamily: 'Lexend',
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(
                color: accentGreen,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lexend',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textSecondary,
              fontFamily: 'Lexend',
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textPrimary,
              fontFamily: 'Lexend',
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// FEEDBACK DIALOG - Enhanced professional design
  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();
    int selectedStars = 0;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: cardDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.feedback_outlined, color: accentGreen, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  "Send Feedback",
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Lexend',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Help us improve LexiLearn with your feedback",
                  style: TextStyle(
                    color: textSecondary,
                    fontFamily: 'Lexend',
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Star Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < selectedStars ? Icons.star_rounded : Icons.star_border_rounded,
                        color: selectedStars > index ? Colors.amber : textSecondary,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedStars = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                // Feedback Text Field
                TextField(
                  controller: feedbackController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Share your thoughts and suggestions...",
                    hintStyle: TextStyle(
                      color: textSecondary.withOpacity(0.6),
                      fontFamily: 'Lexend',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: accentGreen, width: 2),
                    ),
                    filled: true,
                    fillColor: secondaryDark,
                  ),
                  style: TextStyle(
                    color: textPrimary,
                    fontFamily: 'Lexend',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  feedbackController.dispose();
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: textSecondary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lexend',
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGreen,
                  foregroundColor: textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Thank you for your feedback! We appreciate your input.",
                          style: TextStyle(fontFamily: 'Lexend')),
                      backgroundColor: cardDark,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  feedbackController.dispose();
                },
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        });
      },
    ).then((_) => feedbackController.dispose());
  }

  /// LOGOUT DIALOG - Enhanced
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.logout_rounded, color: accentRed, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              "Sign Out",
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w700,
                fontFamily: 'Lexend',
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to sign out of your account?",
          style: TextStyle(
            color: textSecondary,
            fontFamily: 'Lexend',
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: textSecondary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lexend',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentRed,
              foregroundColor: textPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // This is a placeholder for Firebase sign-out logic
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: Text(
              "Sign Out",
              style: TextStyle(
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}