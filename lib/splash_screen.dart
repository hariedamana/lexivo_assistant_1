import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Professional Dark Theme Colors
  static const Color primaryDark = Color(0xFF0F0F0F);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color accentGreen = Color(0xFF00D4AA);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);

  double progress = 0.0;
  Timer? _timer;
  bool _showProgressBar = false;

  // Animation Controllers
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late AnimationController _progressController;

  // Animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _titleSlideAnimation;
  late Animation<double> _titleOpacityAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _progressFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSequence();
  }

  void _initializeAnimations() {
    // Logo Animation Controller (2.5s)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Particle Animation Controller (continuous)
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Pulse Animation Controller (continuous)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Progress Animation Controller
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Logo Animations
    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Title Animations
    _titleSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _titleOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _subtitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Pulse Animation
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Particle Animation
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    // Progress Fade Animation
    _progressFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
  }

  void _startSequence() async {
    // Start logo animation
    _logoController.forward();

    // Show progress bar after logo animation
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() => _showProgressBar = true);
    _progressController.forward();

    // Start progress simulation
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        progress += 1 / 80; // ~4 seconds total
        if (progress >= 1) {
          progress = 1;
          _timer?.cancel();
          _navigateToNext();
        }
      });
    });
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      HapticFeedback.lightImpact();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _logoController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryDark,
              const Color(0xFF1A1A1A),
              primaryDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildAnimatedBackground(),
              _buildFloatingParticles(),
              _buildMainContent(),
              if (_showProgressBar) _buildProgressSection(),
              _buildVersionInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Dynamic gradient orbs
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return Stack(
              children: [
                // Top left orb
                Positioned(
                  top: -100 + (50 * math.sin(_particleAnimation.value * 2 * math.pi)),
                  left: -80 + (30 * math.cos(_particleAnimation.value * 2 * math.pi)),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          accentBlue.withOpacity(0.15),
                          accentBlue.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Bottom right orb
                Positioned(
                  bottom: -120 + (40 * math.cos(_particleAnimation.value * 2 * math.pi * 0.7)),
                  right: -90 + (60 * math.sin(_particleAnimation.value * 2 * math.pi * 0.7)),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          accentGreen.withOpacity(0.15),
                          accentGreen.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Center accent orb
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3,
                  right: -70 + (20 * math.sin(_particleAnimation.value * math.pi)),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          accentPurple.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(12, (index) {
            final double offsetX = 100 + (index * 30) + (20 * math.sin(_particleAnimation.value * 2 * math.pi + index));
            final double offsetY = 150 + (index * 25) + (30 * math.cos(_particleAnimation.value * 2 * math.pi + index));
            final double opacity = (0.1 + (0.15 * math.sin(_particleAnimation.value * math.pi + index))).clamp(0.0, 0.3);
            
            return Positioned(
              left: offsetX % MediaQuery.of(context).size.width,
              top: offsetY % MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 4 + (index % 3) * 2,
                  height: 4 + (index % 3) * 2,
                  decoration: BoxDecoration(
                    color: index % 3 == 0 ? accentGreen : 
                           index % 3 == 1 ? accentBlue : accentPurple,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (index % 3 == 0 ? accentGreen : 
                               index % 3 == 1 ? accentBlue : accentPurple).withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: AnimatedBuilder(
        animation: _logoController,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo Container
              Transform.scale(
                scale: _logoScaleAnimation.value,
                child: Opacity(
                  opacity: _logoOpacityAnimation.value,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: _buildProfessionalLogo(),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Animated Title
              Transform.translate(
                offset: Offset(0, _titleSlideAnimation.value),
                child: Opacity(
                  opacity: _titleOpacityAnimation.value,
                  child: _buildBrandTitle(),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Animated Subtitle
              Opacity(
                opacity: _subtitleAnimation.value,
                child: _buildSubtitle(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfessionalLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: LinearGradient(
          colors: [accentGreen, accentBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accentGreen.withOpacity(0.4),
            offset: const Offset(0, 12),
            blurRadius: 32,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: accentBlue.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Image.asset(
            'assets/images/lexivo_bot.png', // Replaced the Icon with your image
            fit: BoxFit.contain, // Ensures the image fits inside the container
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandTitle() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [accentGreen, accentBlue, accentPurple],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: const Text(
            "Lexivo",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFamily: 'Lexend',
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 3,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [accentGreen, accentBlue],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Column(
      children: [
        Text(
          "AI-Powered Learning Companion",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textPrimary.withOpacity(0.9),
            fontFamily: 'Lexend',
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Personalized for every learning style",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textSecondary,
            fontFamily: 'Lexend',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _progressController,
        builder: (context, child) {
          return Opacity(
            opacity: _progressFadeAnimation.value,
            child: Column(
              children: [
                Text(
                  "Initializing your learning experience...",
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildEnhancedProgressBar(),
                const SizedBox(height: 16),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: TextStyle(
                    fontSize: 16,
                    color: accentGreen,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedProgressBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: cardDark.withOpacity(0.6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress < 0.3 ? accentBlue :
            progress < 0.7 ? accentGreen : accentPurple,
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Text(
        "Version 1.0.0 • Made with ❤️ for better learning",
        style: TextStyle(
          fontSize: 12,
          color: textSecondary.withOpacity(0.6),
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}