import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// TTS Service Class
class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> init() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Future<void> pause() async {
    await _flutterTts.pause();
  }

  Future<void> setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }

  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  Future<void> setRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }
}

/// Main TTS Page with Glass UI
class TtsPage extends StatefulWidget {
  const TtsPage({super.key});

  @override
  State<TtsPage> createState() => _TtsPageState();
}

class _TtsPageState extends State<TtsPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final TtsService _ttsService = TtsService();

  double _pitch = 1.0;
  double _rate = 0.45;
  String _selectedLanguage = "en-US";
  bool _isSpeaking = false;

  // For smooth animations
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initTts();

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  Future<void> _initTts() async {
    await _ttsService.init();
  }

  void _speak() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter some text to speak"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    await _ttsService.speak(_controller.text);
    setState(() {
      _isSpeaking = true;
    });
  }

  void _stop() async {
    await _ttsService.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  void _pause() async {
    await _ttsService.pause();
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001F3F), Color(0xFF00796B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: AnimatedScale(
            scale: _scaleAnimation.value,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),

                    // Title
                    Text(
                      "Text-to-Speech",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Glass card container
                    GlassContainer(
                      height: 420,
                      width: double.infinity,
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderWidth: 1.5,
                      blur: 20,
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text Field
                            TextField(
                              controller: _controller,
                              maxLines: 4,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Type something here...",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Language dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.black87,
                                  value: _selectedLanguage,
                                  icon: const Icon(
                                    Icons.language,
                                    color: Colors.white,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: "en-US",
                                      child: Text(
                                        "English (US)",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "en-GB",
                                      child: Text(
                                        "English (UK)",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "hi-IN",
                                      child: Text(
                                        "Hindi (India)",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "es-ES",
                                      child: Text(
                                        "Spanish",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedLanguage = value;
                                      });
                                      _ttsService.setLanguage(value);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Pitch Slider
                            _buildCustomSlider(
                              label: "Pitch",
                              value: _pitch,
                              min: 0.5,
                              max: 2.0,
                              onChanged: (value) {
                                setState(() => _pitch = value);
                                _ttsService.setPitch(value);
                              },
                            ),

                            // Speech Rate Slider
                            _buildCustomSlider(
                              label: "Rate",
                              value: _rate,
                              min: 0.1,
                              max: 1.0,
                              onChanged: (value) {
                                setState(() => _rate = value);
                                _ttsService.setRate(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Glass control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildGlassButton(
                          icon: Icons.play_arrow_rounded,
                          label: "Speak",
                          color: Colors.greenAccent,
                          onTap: _speak,
                        ),
                        _buildGlassButton(
                          icon: Icons.pause_rounded,
                          label: "Pause",
                          color: Colors.orangeAccent,
                          onTap: _pause,
                        ),
                        _buildGlassButton(
                          icon: Icons.stop_rounded,
                          label: "Stop",
                          color: Colors.redAccent,
                          onTap: _stop,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Custom glass control button
  Widget _buildGlassButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GlassContainer(
      height: 70,
      width: 90,
      borderRadius: BorderRadius.circular(18),
      blur: 15,
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          color.withOpacity(0.8),
          Colors.transparent,
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom slider with label
  Widget _buildCustomSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ${value.toStringAsFixed(2)}",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            trackHeight: 3,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: 10,
            activeColor: Colors.cyanAccent,
            inactiveColor: Colors.white.withOpacity(0.3),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
