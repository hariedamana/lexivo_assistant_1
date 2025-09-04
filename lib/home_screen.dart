import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:ui';
import 'assistants_dashboard.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  // New Brand Colors from LoginScreen
  static const Color primaryTeal = Color(0xFF00796B);
  static const Color secondaryBlue = Color(0xFF0288D1);
  static const Color accentGreen = Color(0xFF43A047);
  static const Color textColor = Color(0xFF1C1C2A);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightCard = Colors.white;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the bottom safe area padding
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: lightBackground, // Changed background color
      body: Stack(
        children: [
          // Main content of the screen
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              // Your existing home screen content
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 100 + bottomPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Header Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hey, Hari!',
                                  style: TextStyle(
                                    color: textColor, // Changed text color
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateTime.now().toString().substring(0, 10),
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.6), // Changed text color
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: lightCard, // Changed background color
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: primaryTeal.withOpacity(0.2), // Changed border color
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: primaryTeal, // Changed icon color
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Enhanced Search Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: lightCard, // Changed background color
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: primaryTeal.withOpacity(0.1), // Changed border color
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryTeal.withOpacity(0.05), // Changed shadow color
                              offset: const Offset(0, 4),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded, color: primaryTeal, size: 24), // Changed icon color
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                  color: textColor, // Changed text color
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Start typing... I've got your back!",
                                  hintStyle: TextStyle(
                                    color: textColor.withOpacity(0.6), // Changed hint color
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Progress Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              primaryTeal, // Changed gradient colors
                              secondaryBlue,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: primaryTeal.withOpacity(0.3), // Changed shadow color
                              offset: const Offset(0, 8),
                              blurRadius: 32,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Image.asset(
                                    'assets/images/lexivo_bot.png',
                                    height: 32,
                                    width: 32,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.android, color: Colors.white, size: 32),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Learning Progress',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Keep it up!',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Completed',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '75%',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                CircularPercentIndicator(
                                  radius: 40.0,
                                  lineWidth: 8.0,
                                  percent: 0.75,
                                  animation: true,
                                  animationDuration: 1200,
                                  center: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.trending_up,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  progressColor: Colors.white,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  circularStrokeCap: CircularStrokeCap.round,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Assistants Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Assistants',
                            style: TextStyle(
                              color: textColor, // Changed text color
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: primaryTeal.withOpacity(0.1), // Changed background color
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: primaryTeal.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Assistant Grid
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 0.85,
                        children: const [
                          FinancialAssistantTile(
                            icon: Icons.record_voice_over_rounded,
                            title: 'Text-to-Speech',
                            subtitle: 'Voice Assistant',
                            color: primaryTeal,
                          ),
                          FinancialAssistantTile(
                            icon: Icons.tips_and_updates_rounded,
                            title: 'Simplify',
                            subtitle: 'Text Helper',
                            color: secondaryBlue,
                          ),
                          FinancialAssistantTile(
                            icon: Icons.keyboard_alt_rounded,
                            title: 'LexiType',
                            subtitle: 'Smart Typing',
                            color: accentGreen,
                          ),
                          FinancialAssistantTile(
                            icon: Icons.fact_check_outlined,
                            title: 'Correct Me',
                            subtitle: 'Grammar Check',
                            color: primaryTeal, // Using a consistent primary color
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Recent Activities Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Activities',
                            style: TextStyle(
                              color: textColor, // Changed text color
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Icon(
                            Icons.more_horiz,
                            color: textColor.withOpacity(0.6), // Changed icon color
                            size: 24,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const FinancialRecentCard(
                        icon: Icons.people_rounded,
                        title: "In Progress",
                        subtitle: "3 active sessions",
                        amount: "Active",
                        color: primaryTeal, // Changed color
                      ),
                      const SizedBox(height: 16),
                      const FinancialRecentCard(
                        icon: Icons.history_rounded,
                        title: "Last Used",
                        subtitle: "Text-to-Speech • 2 hours ago",
                        amount: "2h ago",
                        color: secondaryBlue, // Changed color
                      ),
                      const SizedBox(height: 16),
                      const FinancialRecentCard(
                        icon: Icons.lightbulb_outline_rounded,
                        title: "Updated",
                        subtitle: "New features available",
                        amount: "New",
                        color: accentGreen, // Changed color
                      ),
                    ],
                  ),
                ),
              ),
              const AssistantsDashboard(),
              const ProfileScreen(),
            ],
          ),

          // Custom Floating Navigation Bar positioned at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 20.0 + bottomPadding,
              ),
              child: CustomFloatingNavBar(
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemTapped,
                iconData: const [
                  Icons.home_rounded,
                  Icons.apps_rounded,
                  Icons.person_rounded,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// UI Helper Widgets
// -----------------------------------------------------------------------------

class FinancialAssistantTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const FinancialAssistantTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  // Using the same color scheme as the main screen
  static const Color lightCard = Colors.white;
  static const Color textColor = Color(0xFF1C1C2A);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Widget targetPage;
        switch (title) {
          case 'Text-to-Speech':
            targetPage = const TextToSpeechPage();
            break;
          case 'Simplify':
            targetPage = const SimplifyPage();
            break;
          case 'LexiType':
            targetPage = const LexiTypePage();
            break;
          case 'Correct Me':
            targetPage = const CorrectMePage();
            break;
          default:
            targetPage = const AssistantsPage();
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: lightCard, // Changed card background color
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                size: 28,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: textColor, // Changed text color
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: textColor.withOpacity(0.6), // Changed text color
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FinancialRecentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color color;

  const FinancialRecentCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.color,
  });

  static const Color lightCard = Colors.white;
  static const Color textColor = Color(0xFF1C1C2A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightCard, // Changed card background color
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
                    color: textColor, // Changed text color
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor.withOpacity(0.6), // Changed text color
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  amount,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Placeholder Pages
// -----------------------------------------------------------------------------

class TextToSpeechPage extends StatelessWidget {
  const TextToSpeechPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "Text-to-Speech",
      message: "This is the Text-to-Speech Assistant.",
    );
  }
}

class SimplifyPage extends StatelessWidget {
  const SimplifyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "Simplify",
      message: "This is the Simplify Assistant.",
    );
  }
}

class LexiTypePage extends StatelessWidget {
  const LexiTypePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "LexiType",
      message: "This is the LexiType Assistant.",
    );
  }
}

class CorrectMePage extends StatelessWidget {
  const CorrectMePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "Correct Me",
      message: "This is the Correct Me Assistant.",
    );
  }
}

class AssistantsPage extends StatelessWidget {
  const AssistantsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "Assistants",
      message: "Welcome to Assistants Page!",
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "Chat",
      message: "This is the Chat Page.",
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "Profile",
      message: "This is the Profile Page.",
    );
  }
}

// Updated shared scaffold widget
class AssistantScaffold extends StatelessWidget {
  final String title;
  final String message;

  const AssistantScaffold({
    super.key,
    required this.title,
    required this.message,
  });

  // Using the same color scheme as the main screen
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightCard = Colors.white;
  static const Color primaryTeal = Color(0xFF00796B);
  static const Color textColor = Color(0xFF1C1C2A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: lightCard,
        foregroundColor: primaryTeal,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryTeal),
        titleTextStyle: const TextStyle(
          color: primaryTeal,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(color: primaryTeal, fontSize: 18),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Custom Navigation Bar
// -----------------------------------------------------------------------------

class CustomFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final List<IconData> iconData;

  const CustomFloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.iconData,
  });

  // Using the same color scheme as the main screen
  static const Color primaryTeal = Color(0xFF00796B);
  static const Color secondaryBlue = Color(0xFF0288D1);
  static const Color accentGreen = Color(0xFF43A047);
  static const Color textColor = Color(0xFF1C1C2A);
  static const Color lightCard = Colors.white;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonWidth = size.width / iconData.length;

    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: lightCard, // Changed background color
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          AnimatedAlign(
  duration: const Duration(milliseconds: 400),
  curve: Curves.easeInOut,
  alignment: Alignment(-1.0 + (2.0 / (iconData.length - 1)) * selectedIndex, 0.0),
  child: Container(
    height: 60,
    width: 60,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: const LinearGradient(
        colors: [primaryTeal, secondaryBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        ),
      boxShadow: [
          BoxShadow(
          color: primaryTeal.withOpacity(0.5),
          blurRadius: 15,
          spreadRadius: 2,
          ),
        ],
      ),
        child: Icon(
        iconData[selectedIndex],
        color: Colors.white,
        size: 28,
      ),
    ),
  ),

          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(iconData.length, (index) {
                return GestureDetector(
                  onTap: () => onItemSelected(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Opacity(
                      opacity: selectedIndex == index ? 0 : 1, // Hide the icon inside the bubble
                      child: Icon(
                        iconData[index],
                        color: textColor.withOpacity(0.6), // Changed icon color
                        size: 26,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}