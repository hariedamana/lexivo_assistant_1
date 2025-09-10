import 'package:flutter/material.dart';
import 'dictionary_screen.dart';
import 'word_coach.dart';
import 'lexi_type.dart';
import 'simplify_assistant.dart';

class AssistantsDashboard extends StatefulWidget {
  const AssistantsDashboard({super.key});

  @override
  State<AssistantsDashboard> createState() => _AssistantsDashboardState();
}

class _AssistantsDashboardState extends State<AssistantsDashboard> {
  int _selectedIndex = 1;
  String _searchQuery = '';

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
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

  final List<Map<String, dynamic>> assistants = [
    {
      'name': 'Lexi The AI Assistant',
      'icon': Icons.smart_toy_rounded,
      'color': Color(0xFF00796B),
      'category': 'AI',
    },
    {
      'name': 'Text-to-Speech',
      'icon': Icons.record_voice_over_rounded,
      'color': Color(0xFF00796B),
      'category': 'Voice',
    },
    {
      'name': 'Simplify',
      'icon': Icons.auto_fix_high_rounded,
      'color': Color(0xFF0288D1),
      'category': 'Text',
    },
    {
      'name': 'LexiType',
      'icon': Icons.keyboard_alt_rounded,
      'color': Color(0xFF43A047),
      'category': 'Typing',
    },
    {
      'name': 'Dictionary',
      'icon': Icons.menu_book_rounded,
      'color': Color(0xFF8E24AA),
      'category': 'Reference',
    },
    {
      'name': 'PDF/Doc Reader',
      'icon': Icons.picture_as_pdf_rounded,
      'color': Color(0xFFD32F2F),
      'category': 'Documents',
    },
    {
      'name': 'Word Coach',
      'icon': Icons.school_rounded,
      'color': Color(0xFF6A1B9A),
      'category': 'Learning',
    },
    {
      'name': 'Speak To Type',
      'icon': Icons.mic_rounded,
      'color': Color(0xFF0288D1),
      'category': 'Voice',
    },
    {
      'name': 'Correct Me',
      'icon': Icons.spellcheck_rounded,
      'color': Color(0xFF43A047),
      'category': 'Grammar',
    },
    {
      'name': 'Read Along',
      'icon': Icons.chrome_reader_mode_rounded,
      'color': Color(0xFFF57C00),
      'category': 'Reading',
    },
  ];

  List<Map<String, dynamic>> get filteredAssistants {
    if (_searchQuery.isEmpty) return assistants;
    return assistants
        .where(
          (assistant) => assistant['name'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Color(0xFF00796B),
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Smart Assistants',
                          style: TextStyle(
                            color: Color(0xFF1C1C2A),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Color(0xFF00796B),
                          size: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Search
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF00796B),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            style: const TextStyle(
                              color: Color(0xFF1C1C2A),
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Search assistants...",
                              hintStyle: TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF9E9E9E),
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _searchQuery.isEmpty
                            ? '${assistants.length} assistants available'
                            : '${filteredAssistants.length} results found',
                        style: const TextStyle(
                          color: Color(0xFF616161),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00796B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'All Active',
                          style: TextStyle(
                            color: Color(0xFF00796B),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredAssistants.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final assistant = filteredAssistants[index];
                    return LightAssistantCard(
                      name: assistant['name'],
                      icon: assistant['icon'],
                      color: assistant['color'],
                      category: assistant['category'],
                      onTap: () {
                        if (assistant['name'] == 'Lexi The AI Assistant') {
                          Navigator.pushNamed(context, '/chat');
                        } else if (assistant['name'] == 'Dictionary') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DictionaryScreen(),
                            ),
                          );
                        } else if (assistant['name'] == 'Word Coach') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WordCoachScreen(),
                            ),
                          );
                        } else if (assistant['name'] == 'LexiType') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LexiTypeScreen(),
                            ),
                          );
                        } else if (assistant['name'] == 'Simplify') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  SimplifyAssistant(),
                            ),
                          );
                        }else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${assistant['name']} activated'),
                              backgroundColor: assistant['color'],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(20),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF00796B),
            unselectedItemColor: const Color(0xFF9E9E9E),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 24),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apps_rounded, size: 24),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_rounded, size: 24),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded, size: 24),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LightAssistantCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final String category;
  final VoidCallback onTap;

  const LightAssistantCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            // Name + category
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1C1C2A),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            // Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Ready',
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: color, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
