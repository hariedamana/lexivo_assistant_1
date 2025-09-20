import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dictionary_screen.dart';
import 'word_coach.dart';
import 'lexi_type.dart';
import 'simplify_assistant.dart';
import 'tts_service.dart';
import 'correct_me.dart';

class AssistantsDashboard extends StatefulWidget {
  const AssistantsDashboard({super.key});

  @override
  State<AssistantsDashboard> createState() => _AssistantsDashboardState();
}

class _AssistantsDashboardState extends State<AssistantsDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Dark theme colors matching HomeScreen
  static const Color primaryDark = Color(0xFF0F0F0F);
  static const Color secondaryDark = Color(0xFF1A1A1A);
  static const Color cardDark = Color(0xFF242424);
  static const Color accentGreen = Color(0xFF00D4AA);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentOrange = Color(0xFFFA5252);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color borderColor = Color(0xFF333333);

  final List<Map<String, dynamic>> assistants = [
    {
      'name': 'Lexi Assistant',
      'description': 'Your AI learning companion',
      'icon': Icons.smart_toy_rounded,
      'color': accentGreen,
      'category': 'AI',
      'isActive': true,
    },
    {
      'name': 'Text-to-Speech',
      'description': 'Listen to any text content',
      'icon': Icons.record_voice_over_rounded,
      'color': accentBlue,
      'category': 'Voice',
      'isActive': true,
    },
    {
      'name': 'Simplify Text',
      'description': 'Make complex text easier',
      'icon': Icons.auto_fix_high_rounded,
      'color': accentPurple,
      'category': 'Text',
      'isActive': true,
    },
    {
      'name': 'LexiType',
      'description': 'Smart typing assistance',
      'icon': Icons.keyboard_rounded,
      'color': accentOrange,
      'category': 'Typing',
      'isActive': true,
    },
    {
      'name': 'Dictionary',
      'description': 'Word meanings & definitions',
      'icon': Icons.menu_book_rounded,
      'color': accentPurple,
      'category': 'Reference',
      'isActive': true,
    },
    {
      'name': 'Grammar Check',
      'description': 'Writing & grammar help',
      'icon': Icons.spellcheck_rounded,
      'color': accentGreen,
      'category': 'Writing',
      'isActive': true,
    },
    {
      'name': 'Word Coach',
      'description': 'Vocabulary building games',
      'icon': Icons.school_rounded,
      'color': accentBlue,
      'category': 'Learning',
      'isActive': true,
    },
    {
      'name': 'PDF Reader',
      'description': 'Read documents easily',
      'icon': Icons.picture_as_pdf_rounded,
      'color': accentRed,
      'category': 'Documents',
      'isActive': false,
    },
    {
      'name': 'Voice Input',
      'description': 'Speak to type text',
      'icon': Icons.mic_rounded,
      'color': accentYellow,
      'category': 'Voice',
      'isActive': false,
    },
    {
      'name': 'Read Along',
      'description': 'Interactive reading helper',
      'icon': Icons.chrome_reader_mode_rounded,
      'color': accentOrange,
      'category': 'Reading',
      'isActive': false,
    },
  ];

  final List<String> categories = ['All', 'AI', 'Voice', 'Text', 'Typing', 'Reference', 'Writing', 'Learning', 'Documents', 'Reading'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredAssistants {
    return assistants.where((assistant) {
      final matchesSearch = _searchQuery.isEmpty ||
          assistant['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          assistant['description'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || assistant['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _handleAssistantTap(Map<String, dynamic> assistant) {
    HapticFeedback.mediumImpact();
    
    switch (assistant['name']) {
      case 'Lexi Assistant':
        Navigator.pushNamed(context, '/chat');
        break;
      case 'Dictionary':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DictionaryScreen()));
        break;
      case 'Word Coach':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const WordCoachScreen()));
        break;
      case 'LexiType':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const WordTypingScreen()));
        break;
      case 'Simplify Text':
        Navigator.push(context, MaterialPageRoute(builder: (context) => SimplifyAssistant()));
        break;
      case 'Text-to-Speech':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TtsPage()));
        break;
      case 'Grammar Check':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CorrectMePage()));
        break;
      default:
        _showComingSoonDialog(assistant['name']);
    }
  }

  void _showComingSoonDialog(String assistantName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Coming Soon',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Lexend',
          ),
        ),
        content: Text(
          '$assistantName will be available in the next update!',
          style: TextStyle(
            color: textSecondary,
            fontFamily: 'Lexend',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
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

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: primaryDark,
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header (SliverAppBar)
                SliverAppBar(
                  backgroundColor: primaryDark,
                  elevation: 0,
                  floating: true,
                  pinned: true,
                  expandedHeight: 180, // Reduced expanded height
                  leading: const SizedBox.shrink(), // Removed the back button
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: accentGreen.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.dashboard_rounded,
                                  color: accentGreen,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Smart Assistants',
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Lexend',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Your AI-powered learning tools',
                                      style: TextStyle(
                                        color: textSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Lexend',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: cardDark,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: borderColor.withOpacity(0.3)),
                                ),
                                child: const Icon(
                                  Icons.tune_rounded,
                                  color: Color(0xFF00D4AA),
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSearchBar(),
                        ],
                      ),
                    ),
                  ),
                ),
                // Other slivers
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: _buildCategoryFilter(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: _buildStats(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final assistant = filteredAssistants[index];
                        return _buildAssistantCard(assistant, index);
                      },
                      childCount: filteredAssistants.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withOpacity(0.3)),
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
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: TextStyle(
                color: textPrimary,
                fontSize: 16,
                fontFamily: 'Lexend',
              ),
              decoration: InputDecoration(
                hintText: "Search assistants...",
                hintStyle: TextStyle(
                  color: textSecondary,
                  fontSize: 16,
                  fontFamily: 'Lexend',
                ),
                border: InputBorder.none,
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
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: textSecondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: textSecondary,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: EdgeInsets.only(right: index == categories.length - 1 ? 0 : 12),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? accentGreen : cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? accentGreen : borderColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lexend',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStats() {
    final activeCount = filteredAssistants.where((a) => a['isActive'] == true).length;
    final totalCount = filteredAssistants.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$totalCount ${totalCount == 1 ? 'assistant' : 'assistants'} available',
          style: TextStyle(
            color: textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Lexend',
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: accentGreen.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accentGreen.withOpacity(0.3)),
          ),
          child: Text(
            '$activeCount Active',
            style: TextStyle(
              color: accentGreen,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lexend',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssistantCard(Map<String, dynamic> assistant, int index) {
    final isActive = assistant['isActive'] as bool;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 50),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () => _handleAssistantTap(assistant),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive 
                        ? (assistant['color'] as Color).withOpacity(0.3) 
                        : borderColor.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with icon and status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: (assistant['color'] as Color).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            assistant['icon'] as IconData,
                            color: assistant['color'] as Color,
                            size: 24,
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive ? accentGreen : textSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Title and description
                    Text(
                      assistant['name'] as String,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Lexend',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      assistant['description'] as String,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lexend',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Footer with category and status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (assistant['color'] as Color).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            assistant['category'] as String,
                            style: TextStyle(
                              color: assistant['color'] as Color,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Lexend',
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: isActive ? (assistant['color'] as Color) : textSecondary,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}