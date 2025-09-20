import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_circular_progress.dart';
import 'dart:ui';

// Import actual screens
import 'assistants_dashboard.dart'; // ✅ Real dashboard only
import 'profile_screen.dart';
import 'tts_service.dart';
import 'lexi_type.dart';
import 'simplify_assistant.dart';
import 'correct_me.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Dyslexic-friendly settings
  bool _isDarkMode = true;
  double _textScale = 1.0;
  bool _voiceEnabled = true;

  // Professional Color Palette
  static const Color primaryDark = Color(0xFF0F0F0F);
  static const Color secondaryDark = Color(0xFF1A1A1A);
  static const Color cardDark = Color(0xFF242424);
  static const Color accentGreen = Color(0xFF00D4AA);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentOrange = Color(0xFFFA5252);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFF333333);

  // Light theme colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1F2937);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _isDarkMode ? primaryDark : lightBackground,
      body: Stack(
        children: [
          // Main PageView with 3 tabs
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              // 1. Main Home Content
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 120 + bottomPadding),
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfessionalHeader(),
                            const SizedBox(height: 24),
                            _buildSearchAndQuickActions(),
                            const SizedBox(height: 32),
                            _buildProgressCard(),
                            const SizedBox(height: 32),
                            _buildToolsSection(),
                            const SizedBox(height: 32),
                            _buildRecentActivity(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 2. Tools Tab
              const AssistantsDashboard(),

              // 3. Profile Tab
              const ProfileScreen(),
            ],
          ),

          // Bottom Navigation
          Positioned(
            bottom: 24 + bottomPadding,
            left: 24,
            right: 24,
            child: _buildProfessionalNavigation(),
          ),
        ],
      ),
    );
  }

  // --------------------------
  // Header Section
  // --------------------------
  Widget _buildProfessionalHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Hari 👋',
                style: TextStyle(
                  color: _isDarkMode ? textPrimary : lightText,
                  fontSize: 28 * _textScale,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  fontFamily: 'Lexend',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ready to learn today?',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 16 * _textScale,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Lexend',
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _buildHeaderButton(
              Icons.accessibility_rounded,
              onTap: _showAccessibilityPanel,
            ),
            const SizedBox(width: 12),
            _buildHeaderButton(
              Icons.notifications_none_rounded,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderButton(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _isDarkMode ? cardDark : lightCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor.withOpacity(0.1)),
        ),
        child: Icon(
          icon,
          color: textSecondary,
          size: 20,
        ),
      ),
    );
  }

  // --------------------------
  // Search + Quick Actions
  // --------------------------
  Widget _buildSearchAndQuickActions() {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isDarkMode ? cardDark : lightCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isDarkMode ? 0.2 : 0.05),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: _isDarkMode ? textPrimary : lightText,
                    fontSize: 16 * _textScale,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lexend',
                  ),
                  decoration: InputDecoration(
                    hintText: "Search tools, lessons, or ask me anything...",
                    hintStyle: TextStyle(
                      color: textSecondary,
                      fontSize: 16 * _textScale,
                      fontFamily: 'Lexend',
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: accentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.mic_rounded,
                  color: accentGreen,
                  size: 16,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Quick Actions
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Scan Text',
                Icons.camera_alt_rounded,
                accentBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Voice Mode',
                Icons.record_voice_over_rounded,
                accentPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Quick Type',
                Icons.keyboard_rounded,
                accentOrange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: _isDarkMode ? cardDark : lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isDarkMode ? 0.2 : 0.05),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: _isDarkMode ? textPrimary : lightText,
                fontSize: 12 * _textScale,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lexend',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------
  // Tools Section
  // --------------------------
  Widget _buildToolsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Tools',
              style: TextStyle(
                color: _isDarkMode ? textPrimary : lightText,
                fontSize: 22 * _textScale,
                fontWeight: FontWeight.w700,
                fontFamily: 'Lexend',
              ),
            ),
            Text(
              'See all',
              style: TextStyle(
                color: accentGreen,
                fontSize: 14 * _textScale,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lexend',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildToolCard(
              'Text-to-Speech',
              'Listen to any text',
              Icons.record_voice_over_rounded,
              accentBlue,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TtsPage())),
            ),
            _buildToolCard(
              'Simplify',
              'Make text easier',
              Icons.auto_fix_high_rounded,
              accentPurple,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => SimplifyAssistant())),
            ),
            _buildToolCard(
              'LexiType',
              'Smart typing help',
              Icons.keyboard_rounded,
              accentOrange,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WordTypingScreen())),
            ),
            _buildToolCard(
              'Grammar Check',
              'Writing assistant',
              Icons.fact_check_rounded,
              accentGreen,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CorrectMePage())),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isDarkMode ? cardDark : lightCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isDarkMode ? 0.2 : 0.05),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                color: _isDarkMode ? textPrimary : lightText,
                fontSize: 16 * _textScale,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lexend',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: textSecondary,
                fontSize: 12 * _textScale,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lexend',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------
  // Bottom Navigation
  // --------------------------
  Widget _buildProfessionalNavigation() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _isDarkMode ? cardDark.withOpacity(0.95) : lightCard.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isDarkMode ? 0.3 : 0.1),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_rounded, 'Home', 0),
          _buildNavItem(Icons.dashboard_rounded, 'Tools', 1),
          _buildNavItem(Icons.person_rounded, 'Profile', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _onItemTapped(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : textSecondary,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14 * _textScale,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Lexend',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --------------------------
  // Accessibility Panel
  // --------------------------
  void _showAccessibilityPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _isDarkMode ? cardDark : lightCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.accessibility_rounded,
                    color: accentGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Accessibility',
                  style: TextStyle(
                    color: _isDarkMode ? textPrimary : lightText,
                    fontSize: 20 * _textScale,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Lexend',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Text Size Slider
            Text(
              'Text Size',
              style: TextStyle(
                color: _isDarkMode ? textPrimary : lightText,
                fontSize: 16 * _textScale,
                fontWeight: FontWeight.w600,
                                fontFamily: 'Lexend',
              ),
            ),
            Slider(
              value: _textScale,
              min: 0.8,
              max: 1.5,
              divisions: 7,
              activeColor: accentGreen,
              onChanged: (value) {
                setState(() {
                  _textScale = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Dark Mode Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: _isDarkMode ? textPrimary : lightText,
                    fontSize: 16 * _textScale,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lexend',
                  ),
                ),
                Switch(
                  value: _isDarkMode,
                  activeColor: accentGreen,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Voice Assistant Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Voice Assistance',
                  style: TextStyle(
                    color: _isDarkMode ? textPrimary : lightText,
                    fontSize: 16 * _textScale,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lexend',
                  ),
                ),
                Switch(
                  value: _voiceEnabled,
                  activeColor: accentGreen,
                  onChanged: (value) {
                    setState(() {
                      _voiceEnabled = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16 * _textScale,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lexend',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------
  // Progress Card
  // --------------------------
  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? cardDark : lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CustomCircularProgress(
            progress: 0.65,
            size: 64,
            color: accentGreen,
            backgroundColor: borderColor.withOpacity(0.2),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Progress',
                  style: TextStyle(
                    color: _isDarkMode ? textPrimary : lightText,
                    fontSize: 16 * _textScale,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Lexend',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You are 65% ahead of last week!',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12 * _textScale,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lexend',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------
  // Recent Activity Section
  // --------------------------
  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            color: _isDarkMode ? textPrimary : lightText,
            fontSize: 22 * _textScale,
            fontWeight: FontWeight.w700,
            fontFamily: 'Lexend',
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            _buildActivityItem('Simplified a text passage', '2h ago'),
            _buildActivityItem('Generated speech from text', '5h ago'),
            _buildActivityItem('Checked grammar mistakes', 'Yesterday'),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _isDarkMode ? cardDark : lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.history_rounded,
            color: accentGreen,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: _isDarkMode ? textPrimary : lightText,
                fontSize: 14 * _textScale,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lexend',
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: textSecondary,
              fontSize: 12 * _textScale,
              fontFamily: 'Lexend',
            ),
          ),
        ],
      ),
    );
  }
}
