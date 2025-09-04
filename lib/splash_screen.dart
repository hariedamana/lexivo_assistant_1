import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Brand colors
  static const Color primaryTeal = Color(0xFF00796B);
  static const Color secondaryBlue = Color(0xFF0288D1);
  static const Color accentGreen = Color(0xFF43A047);
  static const Color textColor = Color(0xFF1C1C2A);

  double progress = 0.0;
  Timer? _timer;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Logo fade + slide in
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));
    _fadeController.forward();

    // Progress bar timer (~6s)
    _timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      setState(() {
        progress += 1 / 100;
        if (progress >= 1) {
          progress = 1;
          _timer?.cancel();
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAFAFA), Color(0xFFE3F2FD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildBackgroundDecorations(),

              // Main content with animation
              Center(
                child: AnimatedBuilder(
                  animation: _fadeController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLogoCard(),
                            const SizedBox(height: 50),
                            _buildLoadingBar(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Glassmorphic Logo Card
  Widget _buildLogoCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.65),
            Colors.white.withOpacity(0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/lexivo_bot.png',
            height: 120,
          ),
          const SizedBox(height: 20),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [primaryTeal, secondaryBlue],
            ).createShader(bounds),
            child: const Text(
              "Lexivo",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Learning made simple & friendly",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Gradient Loading Bar
  Widget _buildLoadingBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      height: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade300,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [primaryTeal, secondaryBlue, accentGreen],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  /// Background glowing circles
  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: secondaryBlue.withOpacity(0.15),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: secondaryBlue.withOpacity(0.25),
                  blurRadius: 50,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          right: -50,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: primaryTeal.withOpacity(0.15),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryTeal.withOpacity(0.25),
                  blurRadius: 60,
                  spreadRadius: 25,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
