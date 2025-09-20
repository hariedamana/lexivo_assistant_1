import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WordTypingScreen extends StatefulWidget {
  const WordTypingScreen({super.key});

  @override
  State<WordTypingScreen> createState() => _WordTypingScreenState();
}

class _WordTypingScreenState extends State<WordTypingScreen>
    with TickerProviderStateMixin {
  final List<String> words = [
    'apple',
    'ball',
    'cat',
    'dog',
    'elephant',
    'school',
    'computer',
    'friend',
    'garden'
  ];

  final TextEditingController _controller = TextEditingController();
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late AnimationController _progressController;
  late Animation<double> _slideAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _progressAnimation;

  int currentIndex = 0;
  int correctCount = 0;
  int totalTyped = 0;
  bool _showCorrect = false;
  bool _showIncorrect = false;

  DateTime? startTime;
  bool _isLoading = false;
  bool _isFinished = false;

  // Professional Dark Theme Colors
  static const Color primaryDark = Color(0xFF0D1117);
  static const Color secondaryDark = Color(0xFF161B22);
  static const Color cardDark = Color(0xFF21262D);
  static const Color borderDark = Color(0xFF30363D);
  static const Color accentBlue = Color(0xFF58A6FF);
  static const Color accentGreen = Color(0xFF3FB950);
  static const Color accentRed = Color(0xFFF85149);
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF656D76);

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _slideController.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _slideController.dispose();
    _bounceController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  double calculateWPM() {
    if (startTime == null) return 0;
    final duration = DateTime.now().difference(startTime!).inSeconds / 60;
    return duration > 0 ? correctCount / duration : 0;
  }

  Future<void> saveProgress() async {
    try {
      setState(() => _isLoading = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      await FirebaseFirestore.instance
          .collection('progress')
          .doc(user.uid)
          .set({
        'correctCount': correctCount,
        'totalWords': words.length,
        'accuracy': ((correctCount / words.length) * 100).toStringAsFixed(2),
        'wpm': calculateWPM().toStringAsFixed(2),
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 12),
                Text("Progress saved successfully!", style: TextStyle(color: Colors.white)),
              ],
            ),
            backgroundColor: accentGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text("Error saving progress: $e", style: const TextStyle(color: Colors.white))),
              ],
            ),
            backgroundColor: accentRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void checkWord() {
    if (startTime == null) {
      startTime = DateTime.now();
    }

    final isCorrect = _controller.text.trim().toLowerCase() ==
        words[currentIndex].toLowerCase();

    setState(() {
      totalTyped++;
      if (isCorrect) {
        correctCount++;
        _showCorrect = true;
        _bounceController.forward().then((_) {
          _bounceController.reverse();
          Future.delayed(const Duration(milliseconds: 800), () {
            setState(() => _showCorrect = false);
          });
        });
      } else {
        _showIncorrect = true;
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() => _showIncorrect = false);
        });
      }

      if (currentIndex < words.length - 1) {
        Future.delayed(const Duration(milliseconds: 800), () {
          _slideController.reset();
          _slideController.forward();
          setState(() {
            currentIndex++;
            _controller.clear();
          });
        });
      } else {
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _isFinished = true;
          });
          saveProgress();
        });
      }

      if (!_isFinished && currentIndex < words.length - 1) {
        _progressController.reset();
        _progressController.forward();
      }
    });

    if (!isCorrect) {
      _controller.clear();
    }
  }

  void resetGame() {
    setState(() {
      currentIndex = 0;
      correctCount = 0;
      totalTyped = 0;
      startTime = null;
      _isFinished = false;
      _showCorrect = false;
      _showIncorrect = false;
      _controller.clear();
    });
    _slideController.reset();
    _slideController.forward();
    _progressController.reset();
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      body: SafeArea(
        child: _isFinished ? _buildSummaryScreen() : _buildTypingScreen(),
      ),
    );
  }

  Widget _buildTypingScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Professional Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderDark, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: accentBlue.withOpacity(0.3)),
                    ),
                    child: const Icon(
                      Icons.keyboard,
                      color: accentBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Typing Practice",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      Text(
                        "Professional Training Module",
                        style: TextStyle(
                          fontSize: 12,
                          color: textMuted,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: accentBlue.withOpacity(0.3)),
                    ),
                    child: Text(
                      "Session ${currentIndex + 1}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: accentBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Progress Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderDark, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Progress",
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${currentIndex + 1} of ${words.length}",
                        style: const TextStyle(
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (currentIndex / words.length) +
                              (1 / words.length * _progressAnimation.value),
                          backgroundColor: secondaryDark,
                          valueColor: const AlwaysStoppedAnimation<Color>(accentBlue),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // Current Word Display
            Center(
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * _slideAnimation.value),
                    child: AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _bounceAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 32,
                            ),
                            decoration: BoxDecoration(
                              color: cardDark,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderDark, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Type this word:",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  words[currentIndex],
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),

            // Feedback Messages
            SizedBox(
              height: 40,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _showCorrect
                      ? Container(
                          key: const ValueKey("correct"),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: accentGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: accentGreen.withOpacity(0.3)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_outline, color: accentGreen, size: 18),
                              SizedBox(width: 8),
                              Text(
                                "Correct!",
                                style: TextStyle(
                                  color: accentGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _showIncorrect
                          ? Container(
                              key: const ValueKey("incorrect"),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: accentRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: accentRed.withOpacity(0.3)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.close, color: accentRed, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    "Try again!",
                                    style: TextStyle(
                                      color: accentRed,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // Typing Input
            Container(
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderDark, width: 1),
              ),
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                autofocus: true,
                onSubmitted: (_) => checkWord(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: "Enter your answer...",
                  hintStyle: TextStyle(
                    color: textMuted,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: accentBlue, width: 1),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: checkWord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Submit Answer",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Stats Grid
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderDark, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Performance Metrics",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem("Correct", "$correctCount", Icons.check_circle_outline),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatItem("WPM", calculateWPM().toStringAsFixed(1), Icons.speed),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatItem("Accuracy", "${((correctCount / (totalTyped > 0 ? totalTyped : 1)) * 100).toStringAsFixed(1)}%", Icons.track_changes),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondaryDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderDark, width: 1),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: accentBlue,
            size: 18,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryScreen() {
    final accuracy = ((correctCount / words.length) * 100).toStringAsFixed(1);
    final wpm = calculateWPM().toStringAsFixed(1);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 1000),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: accentGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: accentGreen.withOpacity(0.3), width: 2),
                    ),
                    child: const Icon(
                      Icons.emoji_events_outlined,
                      size: 64,
                      color: accentGreen,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            const Text(
              "Session Complete",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Excellent work! Your performance has been recorded.",
              style: TextStyle(
                fontSize: 14,
                color: textSecondary,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Results Grid
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderDark, width: 1),
              ),
              child: Column(
                children: [
                  const Text(
                    "Final Results",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard("Words Completed", "$correctCount/${words.length}", Icons.text_fields),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard("Accuracy Rate", "$accuracy%", Icons.track_changes),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                      _buildSummaryCard("Typing Speed", "$wpm WPM", Icons.speed),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            if (_isLoading)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentBlue),
                strokeWidth: 2,
              )
            else
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: resetGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Start New Session",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textSecondary,
                        side: const BorderSide(color: borderDark),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Back to Menu",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderDark, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: accentBlue, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: textMuted,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}