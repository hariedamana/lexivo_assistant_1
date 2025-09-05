import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class WordCoachScreen extends StatefulWidget {
  const WordCoachScreen({super.key});

  @override
  State<WordCoachScreen> createState() => _WordCoachScreenState();
}

class _WordCoachScreenState extends State<WordCoachScreen>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> _words = [];
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
  late Animation<double> _celebrationAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _streakAnimation;

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

    _celebrationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _celebrationController, curve: Curves.elasticOut),
    );
    
    _cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack),
    );
    
    _streakAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _streakController, curve: Curves.elasticOut),
    );
  }

  Future<void> _loadWords() async {
    try {
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
      
      // Shuffle and take first 20 words for a session
      allWords.shuffle();
      setState(() {
        _words = allWords.take(20).toList();
        _prepareWord();
      });
      
      _cardController.forward();
    } catch (e) {
      _showSnack('❌ Error loading words: $e');
    }
  }

  void _prepareWord() {
    if (_words.isEmpty) return;
    final currentWord = _words[_currentIndex]['word'] as String;
    _shuffledLetters = currentWord.split('')..shuffle();
    _userAnswer = List.filled(currentWord.length, null);
    _showHint = false;
    _isAnswerComplete = false;
    _showingResult = false;
    setState(() {});
  }

  void _onLetterPlaced(String letter, int position) {
    setState(() {
      _userAnswer[position] = letter;
      _shuffledLetters.remove(letter);
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
            _streakController.reset();
          });
        }
      } else {
        _streak = 0;
      }
    });

    _showSnack(isCorrect 
        ? _getSuccessMessage() 
        : '❌ Incorrect! The word was: $currentWord');

    // Auto advance after showing result
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted && _showingResult) {
        _nextWord();
      }
    });
  }

  String _getSuccessMessage() {
    if (_streak >= 5) return '🔥 Amazing! ${_streak} in a row!';
    if (_streak >= 3) return '⚡ Great streak! ${_streak} correct!';
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
        content: Text(msg),
        backgroundColor: const Color(0xFF6A4C93),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showResultDialog() {
    final accuracy = ((_score / _words.length) * 100).round();
    final performance = accuracy >= 80 
        ? 'Excellent!' 
        : accuracy >= 60 
            ? 'Good job!' 
            : 'Keep practicing!';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple[400]!, Colors.purple[600]!],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_events, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Session Complete!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
              const SizedBox(height: 16),
              Text(performance, style: const TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 20),
              _buildStatRow('Score', '$_score / ${_words.length}', Icons.star),
              _buildStatRow('Accuracy', '$accuracy%', Icons.track_changes),
              _buildStatRow('Best Streak', '$_bestStreak', Icons.local_fire_department),
              _buildStatRow('Hints Used', '$_hintsUsed', Icons.lightbulb),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple[600],
                        side: BorderSide(color: Colors.purple[300]!),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _restartGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Play Again'),
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

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.purple[400]),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    return _confusableLetters.containsKey(letter.toLowerCase()) ||
            _confusableLetters.containsValue(letter.toLowerCase())
        ? Colors.orange[600]!
        : const Color(0xFF6A4C93);
  }

  Widget _buildLetterSlot(int index) {
    final hasLetter = _userAnswer[index] != null;
    
    return DragTarget<String>(
      onAccept: (letter) => _onLetterPlaced(letter, index),
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: hasLetter ? () => _onLetterRemoved(index) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: hasLetter ? Colors.purple[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: candidateData.isNotEmpty 
                    ? Colors.purple[400]! 
                    : hasLetter 
                        ? Colors.purple[300]! 
                        : Colors.grey[400]!,
                width: candidateData.isNotEmpty ? 3 : 2,
              ),
            ),
            child: Center(
              child: hasLetter
                  ? Text(
                      _userAnswer[index]!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                    )
                  : Icon(
                      Icons.add,
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple[400],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
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
      childWhenDragging: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          letter.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _getLetterColor(letter),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          letter.toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _cardController.dispose();
    _streakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_words.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF6A4C93)),
              SizedBox(height: 16),
              Text('Loading word coach...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    final current = _words[_currentIndex];
    final currentWord = current['word'] as String;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Word Coach', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6A4C93),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Center(
            child: AnimatedBuilder(
              animation: _streakAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _streakAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _streak > 2 ? Colors.orange[400] : Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 16,
                          color: _streak > 2 ? Colors.white : Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$_streak',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _streak > 2 ? Colors.white : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _cardAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _cardAnimation.value,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Progress indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${_currentIndex + 1} of ${_words.length}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Score: $_score',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (_currentIndex + 1) / _words.length,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[400]!),
                      minHeight: 6,
                    ),
                    const SizedBox(height: 24),
                    
                    // Definition card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple[400]!, Colors.purple[600]!],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.quiz, color: Colors.white, size: 32),
                          const SizedBox(height: 12),
                          Text(
                            'Spell the word:',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            current['meaning'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_showHint) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Hint: ${currentWord[0].toUpperCase()}${'•' * (currentWord.length - 2)}${currentWord[currentWord.length - 1].toUpperCase()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Answer slots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        currentWord.length,
                        (index) => _buildLetterSlot(index),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Available letters
                    Text(
                      'Drag letters here:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: _shuffledLetters.map(_buildDraggableLetter).toList(),
                    ),
                    
                    const Spacer(),
                    
                    // Result indicator
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
                                color: isCorrect ? Colors.green[100] : Colors.red[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isCorrect ? Colors.green : Colors.red,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle : Icons.cancel,
                                    color: isCorrect ? Colors.green : Colors.red,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isCorrect ? _getSuccessMessage() : 'Incorrect - $currentWord',
                                    style: TextStyle(
                                      color: isCorrect ? Colors.green[700] : Colors.red[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _showHint ? null : () {
                              setState(() {
                                _showHint = true;
                                _hintsUsed++;
                              });
                              HapticFeedback.lightImpact();
                            },
                            icon: const Icon(Icons.lightbulb_outline),
                            label: Text(_showHint ? 'Hint Used' : 'Hint'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.purple[600],
                              side: BorderSide(color: Colors.purple[300]!),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _skipWord,
                            icon: const Icon(Icons.skip_next),
                            label: const Text('Skip'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[400],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
        },
      ),
    );
  }
}