import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LexiTypeScreen extends StatefulWidget {
  const LexiTypeScreen({super.key});

  @override
  State<LexiTypeScreen> createState() => _LexiTypeScreenState();
}

class _LexiTypeScreenState extends State<LexiTypeScreen>
    with TickerProviderStateMixin {
  List<String> _wordsShort = [];
  List<String> _wordsMedium = [];
  List<String> _wordsLong = [];
  List<String> _currentLevelWords = [];
  int _currentWordIndex = 0;
  String _currentWord = '';
  String _userInput = '';
  int _correctChars = 0;
  int _totalChars = 0;
  int _totalWordsTyped = 0;
  Timer? _timer;
  int _seconds = 0;
  int _level = 1; // 1: Short, 2: Medium, 3: Long
  double wpm = 0;
  double accuracy = 0;
  bool _isPaused = false;
  bool _isGameStarted = false;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  // Animation controllers
  late AnimationController _wordAnimationController;
  late AnimationController _accuracyAnimationController;
  late Animation<double> _wordScaleAnimation;
  late Animation<Color?> _accuracyColorAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadWords();
  }

  void _initializeAnimations() {
    _wordAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _accuracyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _wordScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _wordAnimationController,
      curve: Curves.elasticOut,
    ));

    _accuracyColorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.green,
    ).animate(_accuracyAnimationController);
  }

  Future<void> _loadWords() async {
    try {
      final String response = await rootBundle.loadString('assets/words.json');
      final Map<String, dynamic> data = json.decode(response);

      setState(() {
        _wordsShort = data.keys
            .where((w) => w.length <= 4)
            .map((e) => e.toString())
            .toList();
        _wordsMedium = data.keys
            .where((w) => w.length > 4 && w.length <= 7)
            .map((e) => e.toString())
            .toList();
        _wordsLong = data.keys
            .where((w) => w.length > 7)
            .map((e) => e.toString())
            .toList();
      });

      _setLevelWords();
    } catch (e) {
      // Fallback words if JSON loading fails
      setState(() {
        _wordsShort = ['cat', 'dog', 'run', 'jump', 'play', 'book', 'home', 'love'];
        _wordsMedium = ['house', 'computer', 'flutter', 'coding', 'design', 'mobile'];
        _wordsLong = ['programming', 'development', 'application', 'interface', 'technology'];
      });
      _setLevelWords();
    }
  }

  void _setLevelWords() {
    setState(() {
      switch (_level) {
        case 1:
          _currentLevelWords = List.from(_wordsShort)..shuffle();
          break;
        case 2:
          _currentLevelWords = List.from(_wordsMedium)..shuffle();
          break;
        case 3:
          _currentLevelWords = List.from(_wordsLong)..shuffle();
          break;
      }
      _currentWordIndex = 0;
      _currentWord = _currentLevelWords.isNotEmpty ? _currentLevelWords[0] : '';
      _resetStats();
      _wordAnimationController.forward();
    });
  }

  void _resetStats() {
    _userInput = '';
    _textController.clear();
    _correctChars = 0;
    _totalChars = 0;
    _totalWordsTyped = 0;
    _seconds = 0;
    _isPaused = false;
    _isGameStarted = false;
    wpm = 0;
    accuracy = 100;
  }

  void _startGame() {
    if (!_isGameStarted) {
      setState(() {
        _isGameStarted = true;
      });
      _startTimer();
    }
    _focusNode.requestFocus();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _seconds++;
          _calculateStats();
        });
      }
    });
  }

  void _pauseGame() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _restartLevel() {
    _timer?.cancel();
    _setLevelWords();
    _focusNode.requestFocus();
  }

  void _calculateStats() {
    final minutes = _seconds / 60;
    if (minutes > 0) {
      wpm = (_totalWordsTyped / minutes);
      // Alternative WPM calculation: (_correctChars / 5) / minutes
    } else {
      wpm = 0;
    }
    accuracy = _totalChars > 0 ? (_correctChars / _totalChars) * 100 : 100;
    
    // Trigger accuracy color animation
    if (accuracy >= 95) {
      _accuracyAnimationController.forward();
    } else {
      _accuracyAnimationController.reverse();
    }
  }

  void _onInputChanged(String value) {
    if (!_isGameStarted) {
      _startGame();
    }

    setState(() {
      _userInput = value;
      _totalChars = _userInput.length;
      _correctChars = 0;
      
      // Calculate correct characters
      for (int i = 0; i < _userInput.length && i < _currentWord.length; i++) {
        if (_userInput[i].toLowerCase() == _currentWord[i].toLowerCase()) {
          _correctChars++;
        }
      }

      // Auto move to next word if correct
      if (_userInput.trim().toLowerCase() == _currentWord.toLowerCase()) {
        _nextWord();
      }
    });
  }

  void _nextWord() {
    _totalWordsTyped++;
    
    if (_currentWordIndex < _currentLevelWords.length - 1) {
      setState(() {
        _currentWordIndex++;
        _currentWord = _currentLevelWords[_currentWordIndex];
        _userInput = '';
        _textController.clear();
      });
      
      // Animate word change
      _wordAnimationController.reset();
      _wordAnimationController.forward();
      
      // Haptic feedback
      HapticFeedback.lightImpact();
    } else {
      _showLevelCompleteDialog();
    }
  }

  void _showLevelCompleteDialog() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Text('Level $_level Completed!'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatCard('Time', '$_seconds seconds', Icons.timer),
              _buildStatCard('WPM', '${wpm.toStringAsFixed(1)}', Icons.speed),
              _buildStatCard('Accuracy', '${accuracy.toStringAsFixed(1)}%', Icons.track_changes),
              _buildStatCard('Words Typed', '$_totalWordsTyped', Icons.text_fields),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartLevel();
            },
            child: const Text('Retry Level'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (_level < 3) {
                setState(() {
                  _level++;
                  _setLevelWords();
                });
              } else {
                // Show completion dialog
                _showGameCompleteDialog();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(_level < 3 ? 'Next Level' : 'Complete Game'),
          ),
        ],
      ),
    );
  }

  void _showGameCompleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 32),
            SizedBox(width: 8),
            Text('Congratulations!'),
          ],
        ),
        content: Text(
          'You have completed all levels!\n\nWould you like to start over?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay Here'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _level = 1;
                _setLevelWords();
              });
            },
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          SizedBox(width: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getInputBorderColor() {
    if (_userInput.isEmpty) return Colors.grey[400]!;
    
    bool isCorrect = true;
    for (int i = 0; i < _userInput.length && i < _currentWord.length; i++) {
      if (_userInput[i].toLowerCase() != _currentWord[i].toLowerCase()) {
        isCorrect = false;
        break;
      }
    }
    
    return isCorrect ? Colors.green : Colors.red;
  }

  Widget _buildWordDisplay() {
    return AnimatedBuilder(
      animation: _wordScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _wordScaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurple.shade50,
                  Colors.deepPurple.shade100,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: _buildStyledWord(),
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<TextSpan> _buildStyledWord() {
    List<TextSpan> spans = [];
    
    for (int i = 0; i < _currentWord.length; i++) {
      Color textColor;
      Color backgroundColor = Colors.transparent;
      
      if (i < _userInput.length) {
        if (_userInput[i].toLowerCase() == _currentWord[i].toLowerCase()) {
          textColor = Colors.green;
          backgroundColor = Colors.green.withOpacity(0.1);
        } else {
          textColor = Colors.red;
          backgroundColor = Colors.red.withOpacity(0.1);
        }
      } else {
        textColor = Colors.deepPurple;
      }
      
      spans.add(TextSpan(
        text: _currentWord[i].toUpperCase(),
        style: TextStyle(
          color: textColor,
          backgroundColor: backgroundColor,
        ),
      ));
    }
    
    return spans;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wordAnimationController.dispose();
    _accuracyAnimationController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLevelWords.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.deepPurple),
              SizedBox(height: 16),
              Text('Loading words...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('LexiType', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _pauseGame,
            tooltip: _isPaused ? 'Resume' : 'Pause',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartLevel,
            tooltip: 'Restart Level',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Level indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.deepPurple.shade300],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Level $_level - ${_level == 1 ? 'Short Words' : _level == 2 ? 'Medium Words' : 'Long Words'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Word display
              _buildWordDisplay(),
              
              const SizedBox(height: 24),
              
              // Input field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  autofocus: true,
                  onChanged: _onInputChanged,
                  style: const TextStyle(fontSize: 18, letterSpacing: 2),
                  decoration: InputDecoration(
                    hintText: _isGameStarted ? 'Type the word here...' : 'Start typing to begin!',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: _getInputBorderColor(), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: _getInputBorderColor(), width: 3),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Stats row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatWidget('Time', '$_seconds s', Icons.timer, Colors.blue),
                    Container(height: 40, width: 1, color: Colors.grey[300]),
                    _buildStatWidget('WPM', '${wpm.toStringAsFixed(1)}', Icons.speed, Colors.orange),
                    Container(height: 40, width: 1, color: Colors.grey[300]),
                    AnimatedBuilder(
                      animation: _accuracyColorAnimation,
                      builder: (context, child) {
                        return _buildStatWidget(
                          'Accuracy', 
                          '${accuracy.toStringAsFixed(1)}%', 
                          Icons.track_changes, 
                          _accuracyColorAnimation.value ?? Colors.green,
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Progress indicator
              Column(
                children: [
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: LinearProgressIndicator(
                      value: (_currentWordIndex + 1) / _currentLevelWords.length,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Word ${_currentWordIndex + 1} of ${_currentLevelWords.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${((_currentWordIndex + 1) / _currentLevelWords.length * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              if (_isPaused)
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pause_circle, color: Colors.amber.shade700),
                      SizedBox(width: 8),
                      Text(
                        'Game Paused',
                        style: TextStyle(
                          color: Colors.amber.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatWidget(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}