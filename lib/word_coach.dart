import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:developer';

class WordCoachScreen extends StatefulWidget {
  const WordCoachScreen({super.key});

  @override
  State<WordCoachScreen> createState() => _WordCoachScreenState();
}

class _WordCoachScreenState extends State<WordCoachScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _words = [];
  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _bestStreak = 0;
  bool _showHint = false;
  List<String> _shuffledLetters = [];
  List<String?> _userAnswer = [];
  bool _isAnswerComplete = false;
  bool _showingResult = false;
  int _hintsUsed = 0;

  late AnimationController _celebrationController;
  late AnimationController _cardController;
  late AnimationController _streakController;
  late AnimationController _pulseController;
  late Animation<double> _celebrationAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _streakAnimation;
  late Animation<double> _pulseAnimation;

  final Map<String, String> _confusableLetters = {
    'b': 'd',
    'd': 'b',
    'p': 'q',
    'q': 'p',
    'm': 'n',
    'n': 'm',
    'u': 'v',
    'v': 'u',
    'i': 'l',
    'l': 'i',
    'r': 'n',
    'c': 'e',
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadWords();
  }

  void _initializeAnimations() {
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _streakController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _celebrationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _celebrationController, curve: Curves.elasticOut),
    );
    
    _cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack),
    );
    
    _streakAnimation = Tween<double>(begin: 1, end: 1.3).animate(
      CurvedAnimation(parent: _streakController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  Future<void> _loadWords() async {
    try {
      // NOTE: This assumes you have an 'assets/words.json' file in your project.
      // If not, you will need to create one or mock the data.
      final String response = await rootBundle.loadString('assets/words.json');
      final Map<String, dynamic> data = json.decode(response);
      
      List<Map<String, dynamic>> allWords = [];
      data.forEach((letter, words) {
        if (words is Map<String, dynamic>) {
          words.forEach((word, definition) {
            allWords.add({
              'word': word,
              'meaning': definition.toString(),
              'sentence': 'Example: ${word.toLowerCase()} is used in sentences.'
            });
          });
        }
      });
      
      allWords.shuffle();
      setState(() {
        _words.addAll(allWords.take(math.min(20, allWords.length)));
        _prepareWord();
      });
      
      _cardController.forward();
    } catch (e) {
      log('Error loading words: $e');
      _showSnack('❌ Error loading words: $e');
    }
  }

  void _prepareWord() {
    if (_words.isEmpty) return;
    final currentWord = _words[_currentIndex]['word'] as String;
    // Keep duplicates properly if word contains duplicate letters
    _shuffledLetters = List<String>.from(currentWord.split(''))..shuffle();
    _userAnswer = List<String?>.filled(currentWord.length, null);
    _showHint = false;
    _isAnswerComplete = false;
    _showingResult = false;
    setState(() {});
  }

  void _onLetterPlaced(String letter, int position) {
    setState(() {
      // If the slot already has a letter, return it first
      if (_userAnswer[position] != null) {
        _shuffledLetters.add(_userAnswer[position]!);
      }
      _userAnswer[position] = letter;
      // remove only one occurrence (first) of this letter from shuffled
      final idx = _shuffledLetters.indexOf(letter);
      if (idx >= 0) _shuffledLetters.removeAt(idx);
      _checkIfComplete();
    });
    HapticFeedback.lightImpact();
  }

  void _onLetterRemoved(int position) {
    if (_userAnswer[position] != null) {
      setState(() {
        _shuffledLetters.add(_userAnswer[position]!);
        _userAnswer[position] = null;
        _isAnswerComplete = false;
        _showingResult = false;
      });
      HapticFeedback.lightImpact();
    }
  }

  void _checkIfComplete() {
    _isAnswerComplete = _userAnswer.every((letter) => letter != null);
    if (_isAnswerComplete) {
      Future.delayed(const Duration(milliseconds: 500), _checkAnswer);
    }
  }

  void _checkAnswer() {
    final currentWord = _words[_currentIndex]['word'] as String;
    final userWord = _userAnswer.join('').toLowerCase();
    final isCorrect = userWord == currentWord.toLowerCase();

    setState(() {
      _showingResult = true;
      if (isCorrect) {
        _score++;
        _streak++;
        if (_streak > _bestStreak) {
          _bestStreak = _streak;
        }
        _celebrationController.forward().then((_) {
          _celebrationController.reset();
        });
        if (_streak > 2) {
          _streakController.forward().then((_) {
            _streakController.reverse();
          });
        }
      } else {
        _streak = 0;
      }
    });

    _showSnack(isCorrect ? _getSuccessMessage() : '❌ Incorrect! The word was: $currentWord');

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted && _showingResult) {
        _nextWord();
      }
    });
  }

  String _getSuccessMessage() {
    if (_streak >= 5) return '🔥 Amazing! $_streak in a row!';
    if (_streak >= 3) return '⚡ Great streak! $_streak correct!';
    return '✅ Correct!';
  }

  void _nextWord() {
    if (_currentIndex < _words.length - 1) {
      setState(() {
        _currentIndex++;
        _prepareWord();
      });
      _cardController.reset();
      _cardController.forward();
    } else {
      _showResultDialog();
    }
  }

  void _skipWord() {
    _streak = 0;
    _showSnack('⏭️ Word skipped!');
    _nextWord();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4ECDC4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showResultDialog() {
    final accuracy = ((_score / (_words.isEmpty ? 1 : _words.length)) * 100).round();
    final performance = accuracy >= 80
        ? 'Excellent!'
        : accuracy >= 60
            ? 'Good job!'
            : 'Keep practicing!';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: const Icon(Icons.emoji_events, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'Session Complete!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                performance,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    _buildStatRow('Score', '$_score / ${_words.length}', Icons.star, Colors.white),
                    _buildStatRow('Accuracy', '$accuracy%', Icons.track_changes, Colors.white),
                    _buildStatRow('Best Streak', '$_bestStreak', Icons.local_fire_department, const Color(0xFFFF6B6B)),
                    _buildStatRow('Hints Used', '$_hintsUsed', Icons.lightbulb, Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFF4ECDC4)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        onPressed: _restartGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          'Play Again',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    Navigator.pop(context);
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _streak = 0;
      _hintsUsed = 0;
      _words.shuffle();
      _prepareWord();
    });
    _cardController.reset();
    _cardController.forward();
  }

  Color _getLetterColor(String letter) {
    return _confusableLetters.containsKey(letter.toLowerCase()) || _confusableLetters.containsValue(letter.toLowerCase())
        ? const Color(0xFFFF6B6B)
        : const Color(0xFF4ECDC4);
  }

  Widget _buildLetterSlot(int index) {
    final hasLetter = _userAnswer[index] != null;
    final currentWord = _words[_currentIndex]['word'] as String;
    final isCorrectPosition = hasLetter && _userAnswer[index] == currentWord[index];

    return DragTarget<String>(
      onWillAccept: (data) => true,
      onAccept: (letter) {
        // Find the first empty slot
        int targetIndex = _userAnswer.indexOf(null);
        if (targetIndex != -1) {
          _onLetterPlaced(letter, targetIndex);
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isCandidate = candidateData.isNotEmpty;
        return GestureDetector(
          onTap: hasLetter ? () => _onLetterRemoved(index) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 55,
            height: 55,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              gradient: hasLetter
                  ? const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)])
                  : null,
              color: hasLetter ? null : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCandidate
                    ? const Color(0xFF4ECDC4)
                    : hasLetter
                        ? _showingResult
                            ? isCorrectPosition
                                ? const Color(0xFF6BCF7F)
                                : const Color(0xFFFF6B6B)
                            : Colors.transparent
                        : Colors.grey[300]!,
                width: isCandidate ? 3 : 2,
              ),
              boxShadow: [
                if (hasLetter || isCandidate)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Center(
              child: hasLetter
                  ? Text(
                      _userAnswer[index]!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.add_rounded,
                      color: Colors.grey[400],
                      size: 20,
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDraggableLetter(String letter) {
    return Draggable<String>(
      data: letter,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.2,
          child: Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_getLetterColor(letter), _getLetterColor(letter).withOpacity(0.85)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                letter.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 55,
        height: 55,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            letter.toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
        ),
      ),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final isConfusable = _confusableLetters.containsKey(letter.toLowerCase()) || _confusableLetters.containsValue(letter.toLowerCase());
          return Transform.scale(
            scale: isConfusable ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 55,
              height: 55,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_getLetterColor(letter), _getLetterColor(letter).withOpacity(0.85)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _getLetterColor(letter).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  letter.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDraggableLettersGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: _shuffledLetters.map((l) => _buildDraggableLetter(l)).toList(),
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _cardController.dispose();
    _streakController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_words.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final current = _words[_currentIndex];
    final currentWord = current['word'] as String;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "Word Coach",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      AnimatedBuilder(
                        animation: _streakAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _streakAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: _streak > 2
                                    ? const LinearGradient(colors: [Color(0xFFFFD93D), Color(0xFFFF6B6B)])
                                    : null,
                                color: _streak > 2 ? null : Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    size: 18,
                                    color: _streak > 2 ? Colors.white : Colors.white70,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$_streak',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _streak > 2 ? Colors.white : Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                AnimatedBuilder(
                  animation: _cardAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _cardAnimation.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            // Progress Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Question ${_currentIndex + 1} of ${_words.length}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Score: $_score',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  LinearProgressIndicator(
                                    value: (_currentIndex + 1) / _words.length,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                    minHeight: 8,
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Definition Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.quiz, color: Colors.white, size: 28),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Spell the word:',
                                    style: TextStyle(
                                      color: Color(0xFF2C3E50),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    current['meaning'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF2C3E50),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (_showHint) ...[
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFFFD93D), Color(0xFF6BCF7F)],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Hint: ${currentWord[0].toUpperCase()}${'•' * (currentWord.length - 2)}${currentWord[currentWord.length - 1].toUpperCase()}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Answer Slots
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  currentWord.length,
                                  (index) => _buildLetterSlot(index),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Available Letters
                            Text(
                              'Drag letters here:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: _shuffledLetters.map(_buildDraggableLetter).toList(),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Result Indicator
                            if (_showingResult)
                              AnimatedBuilder(
                                animation: _celebrationAnimation,
                                builder: (context, child) {
                                  final currentWord = _words[_currentIndex]['word'] as String;
                                  final userWord = _userAnswer.join('').toLowerCase();
                                  final isCorrect = userWord == currentWord.toLowerCase();
                                  
                                  return Transform.scale(
                                    scale: _celebrationAnimation.value,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: isCorrect 
                                            ? const LinearGradient(colors: [Color(0xFF6BCF7F), Color(0xFF4ECDC4)])
                                            : const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8A65)]),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Flexible(
                                            child: Text(
                                              isCorrect ? _getSuccessMessage() : 'Incorrect - $currentWord',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            
                            const SizedBox(height: 24),
                            
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: TextButton.icon(
                                      onPressed: _showHint ? null : () {
                                        setState(() {
                                          _showHint = true;
                                          _hintsUsed++;
                                        });
                                        HapticFeedback.lightImpact();
                                      },
                                      icon: Icon(
                                        _showHint ? Icons.lightbulb : Icons.lightbulb_outline,
                                        color: _showHint ? Colors.white.withOpacity(0.5) : Colors.white,
                                      ),
                                      label: Text(
                                        _showHint ? 'Hint Used' : 'Hint',
                                        style: TextStyle(
                                          color: _showHint ? Colors.white.withOpacity(0.5) : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFFD93D), Color(0xFFFF6B6B)],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: _skipWord,
                                      icon: const Icon(Icons.skip_next_rounded, color: Colors.white),
                                      label: const Text(
                                        'Skip',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}