import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/assistants');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/chat');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/profile');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A), // Deep dark background
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
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF00E5A0), // Bright teal
            unselectedItemColor: const Color(0xFF6B7280),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 26), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.apps_rounded, size: 26), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded, size: 26), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded, size: 26), label: ''),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Header Section with modern styling
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
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateTime.now().toString().substring(0, 10),
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
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
                        color: const Color(0xFF1C1F2B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFF00E5A0).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Color(0xFF00E5A0),
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
                    color: const Color(0xFF1C1F2B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF00E5A0).withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E5A0).withOpacity(0.05),
                        offset: const Offset(0, 4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search_rounded, color: Color(0xFF00E5A0), size: 24),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: "Start typing... I've got your back!",
                            hintStyle: TextStyle(
                              color: Color(0xFF6B7280),
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

                // Progress Card with financial app styling
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00E5A0),
                        const Color(0xFF00C4CC),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E5A0).withOpacity(0.3),
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

                // Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Assistants',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5A0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF00E5A0).withOpacity(0.2),
                        ),
                      ),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: Color(0xFF00E5A0),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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
                      color: Color(0xFF00E5A0),
                    ),
                    FinancialAssistantTile(
                      icon: Icons.tips_and_updates_rounded,
                      title: 'Simplify',
                      subtitle: 'Text Helper',
                      color: Color(0xFF6366F1),
                    ),
                    FinancialAssistantTile(
                      icon: Icons.keyboard_alt_rounded,
                      title: 'LexiType',
                      subtitle: 'Smart Typing',
                      color: Color(0xFFEC4899),
                    ),
                    FinancialAssistantTile(
                      icon: Icons.fact_check_outlined,
                      title: 'Correct Me',
                      subtitle: 'Grammar Check',
                      color: Color(0xFFF59E0B),
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
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Icon(
                      Icons.more_horiz,
                      color: Color(0xFF6B7280),
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
                  color: Color(0xFF00E5A0),
                ),
                const SizedBox(height: 16),
                const FinancialRecentCard(
                  icon: Icons.history_rounded,
                  title: "Last Used",
                  subtitle: "Text-to-Speech • 2 hours ago",
                  amount: "2h ago",
                  color: Color(0xFF6366F1),
                ),
                const SizedBox(height: 16),
                const FinancialRecentCard(
                  icon: Icons.lightbulb_outline_rounded,
                  title: "Updated",
                  subtitle: "New features available",
                  amount: "New",
                  color: Color(0xFFEC4899),
                ),

                const SizedBox(height: 100), // Extra space for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
          color: const Color(0xFF1C1F2B),
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
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
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

  @override
  Widget build(BuildContext context) {
    return Container(
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

// Placeholder assistant pages (keeping your existing ones)
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

// Updated shared scaffold widget
class AssistantScaffold extends StatelessWidget {
  final String title;
  final String message;

  const AssistantScaffold({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF1C1F2B),
        foregroundColor: const Color(0xFF00E5A0),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(color: Color(0xFF00E5A0), fontSize: 18),
        ),
      ),
    );
  }
}