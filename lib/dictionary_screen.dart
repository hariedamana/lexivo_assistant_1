import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, HapticFeedback;

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen>
    with TickerProviderStateMixin {
  String _searchQuery = '';
  Map<String, String> _allWords = {};
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _searchAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _searchAnimation;
  late Animation<double> _fadeAnimation;

  // Professional Dark Theme Colors
  static const Color primaryDark = Color(0xFF0D1117);
  static const Color secondaryDark = Color(0xFF161B22);
  static const Color cardDark = Color(0xFF21262D);
  static const Color borderDark = Color(0xFF30363D);
  static const Color accentBlue = Color(0xFF58A6FF);
  static const Color accentGreen = Color(0xFF3FB950);
  static const Color accentOrange = Color(0xFFDB6D28);
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF656D76);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadDictionary();
  }

  void _initializeAnimations() {
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _loadDictionary() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    try {
      String jsonString = await rootBundle.loadString('assets/words.json');
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      Map<String, String> flatMap = {};
      jsonMap.forEach((letter, words) {
        (words as Map<String, dynamic>).forEach((word, definition) {
          flatMap[word] = definition.toString();
        });
      });

      setState(() {
        _allWords = flatMap;
        _isLoading = false;
      });
      
      _fadeAnimationController.forward();
    } catch (e) {
      setState(() {
        _allWords = {
          'apple': 'A round fruit with red or green skin and crisp flesh',
          'book': 'A set of written or printed pages bound together for reading',
          'computer': 'An electronic device for storing and processing data',
          'dictionary': 'A reference work containing words and their meanings',
          'education': 'The process of teaching and learning knowledge',
          'flutter': 'A UI toolkit for building natively compiled applications',
          'knowledge': 'Information and skills acquired through experience',
          'language': 'A system of communication used by humans',
          'learning': 'The process of acquiring new understanding',
          'programming': 'The process of creating computer software',
        };
        _isLoading = false;
      });
      _fadeAnimationController.forward();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    _searchAnimationController.reverse();
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: primaryDark,
        border: Border(
          bottom: BorderSide(
            color: borderDark,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cardDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: borderDark,
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: textSecondary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Dictionary',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                    fontFamily: 'Lexend',
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accentBlue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${_allWords.length} entries',
                    style: const TextStyle(
                      color: accentBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Lexend',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Professional dictionary for enhanced vocabulary',
              style: TextStyle(
                fontSize: 14,
                color: textMuted,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lexend',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderDark,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() => _searchQuery = value);
          if (value.isNotEmpty) {
            _searchAnimationController.forward();
          } else {
            _searchAnimationController.reverse();
          }
        },
        style: const TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w400,
          color: textPrimary,
          fontFamily: 'Lexend',
        ),
        decoration: InputDecoration(
          hintText: 'Search dictionary...',
          hintStyle: const TextStyle(
            color: textMuted,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Lexend',
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(14),
            child: const Icon(
              Icons.search_rounded,
              color: textSecondary,
              size: 20,
            ),
          ),
          suffixIcon: AnimatedBuilder(
            animation: _searchAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _searchAnimation.value,
                child: _searchQuery.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.all(8),
                        child: IconButton(
                          onPressed: _clearSearch,
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: textMuted.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: textMuted,
                              size: 14,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(width: 48),
              );
            },
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: accentBlue, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildWordCard(String word, int index, int totalCount) {
    final vowelCount = word.split('').where((c) => 'aeiouAEIOU'.contains(c)).length;
    final consonantCount = word.length - vowelCount;
    
    return AnimatedContainer(
      duration: Duration(milliseconds: 200 + (index * 50)),
      curve: Curves.easeOutCubic,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        decoration: BoxDecoration(
          color: cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderDark,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              HapticFeedback.lightImpact();
              _showWordDetails(word);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: accentBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: accentBlue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            word.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: accentBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Lexend',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              word,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: textPrimary,
                                fontFamily: 'Lexend',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: accentBlue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: accentBlue.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${word.length} chars',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: accentBlue,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Lexend',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: accentOrange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: accentOrange.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '$vowelCount vowels',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: accentOrange,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Lexend',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: secondaryDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: borderDark,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: textMuted,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: secondaryDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: borderDark,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _allWords[word]!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Lexend',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(int totalWords, int filteredWords) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderDark,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: accentBlue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              _searchQuery.isEmpty 
                  ? Icons.library_books_rounded 
                  : Icons.search_rounded,
              color: accentBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _searchQuery.isEmpty 
                      ? 'Dictionary Database' 
                      : 'Search Results',
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lexend',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _searchQuery.isEmpty 
                      ? '$totalWords entries available' 
                      : '$filteredWords results found',
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lexend',
                  ),
                ),
              ],
            ),
          ),
          if (_searchQuery.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: filteredWords > 0 
                    ? accentGreen.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: filteredWords > 0 
                      ? accentGreen.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                filteredWords > 0 
                    ? Icons.check_circle_outline_rounded
                    : Icons.error_outline_rounded,
                color: filteredWords > 0 
                    ? accentGreen
                    : Colors.red,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: cardDark,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: borderDark,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 40,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No results found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textPrimary,
              fontFamily: 'Lexend',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try different keywords or browse all entries',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: textMuted,
              fontFamily: 'Lexend',
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: accentBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton.icon(
              onPressed: _clearSearch,
              icon: const Icon(Icons.refresh_rounded, size: 18, color: Colors.white),
              label: const Text(
                'Clear Search',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Lexend',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: primaryDark,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: cardDark,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: borderDark,
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          color: accentBlue,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Loading Dictionary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                      fontFamily: 'Lexend',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Preparing vocabulary database',
                    style: TextStyle(
                      fontSize: 14,
                      color: textMuted,
                      fontFamily: 'Lexend',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWordDetails(String word) {
    final vowelCount = word.split('').where((c) => 'aeiouAEIOU'.contains(c)).length;
    final consonantCount = word.length - vowelCount;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: cardDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
            top: BorderSide(color: borderDark, width: 1),
            left: BorderSide(color: borderDark, width: 1),
            right: BorderSide(color: borderDark, width: 1),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: accentBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: accentBlue.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              word.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: accentBlue,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Lexend',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                word,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                  fontFamily: 'Lexend',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: accentBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: accentBlue.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '${word.length} letters',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: accentBlue,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Lexend',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: accentOrange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: accentOrange.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '$vowelCount vowels',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: accentOrange,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Lexend',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: accentGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: accentGreen.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '$consonantCount consonants',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: accentGreen,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Lexend',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: accentBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: accentBlue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            color: accentBlue,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Definition',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: accentBlue,
                              fontFamily: 'Lexend',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: secondaryDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: borderDark,
                            width: 1,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _allWords[word]!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: textSecondary,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Lexend',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          color: accentBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Lexend',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _fadeAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    final filteredWords = _searchQuery.isEmpty
        ? _allWords.keys.toList()
        : _allWords.keys
            .where((word) =>
                word.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: primaryDark,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchField(),
            _buildStatsCard(_allWords.length, filteredWords.length),
            Expanded(
              child: filteredWords.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: filteredWords.length,
                      itemBuilder: (context, index) {
                        final word = filteredWords[index];
                        return _buildWordCard(word, index, filteredWords.length);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}