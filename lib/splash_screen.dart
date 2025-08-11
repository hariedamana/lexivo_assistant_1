import 'package:flutter/material.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isFinished = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Professional color palette from the reference
  static const Color primaryTeal = Color(0xFF00D4AA);
  static const Color secondaryTeal = Color(0xFF1DE9B6);
  static const Color accentBlue = Color(0xFF4FC3F7);
  static const Color darkBackground = Color(0xFF0A0E27);
  static const Color cardBackground = Color(0xFF1A1E3A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<double>(
      begin: 40.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Professional background pattern
            _buildProfessionalBackground(),
            
            // Floating geometric shapes
            _buildFloatingElements(),
            
            // Main content
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        
                        // Professional logo card
                        _buildProfessionalLogoCard(),
                        
                        const SizedBox(height: 48),
                        
                        // Professional text content
                        _buildProfessionalTextContent(),
                        
                        const SizedBox(height: 24),
                        
                        // Trust indicators
                        _buildTrustIndicators(),
                        
                        const Spacer(flex: 3),
                        
                        // Professional swipe button
                        _buildProfessionalSwipeButton(),
                        
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: ProfessionalBackgroundPainter(),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Stack(
      children: [
        // Large circle - top left
        Positioned(
          top: 60,
          left: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryTeal.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
        ),
        // Medium circle - top right
        Positioned(
          top: 100,
          right: -60,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: accentBlue.withOpacity(0.08),
                width: 1,
              ),
            ),
          ),
        ),
        // Professional grid dots
        Positioned(
          bottom: 100,
          left: 50,
          child: _buildGridDots(),
        ),
      ],
    );
  }

  Widget _buildGridDots() {
    return SizedBox(
      width: 60,
      height: 60,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 16,
        itemBuilder: (context, index) {
          return Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: primaryTeal.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfessionalLogoCard() {
    return Container(
      width: 320,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardBackground.withOpacity(0.9),
            const Color(0xFF2A2E54).withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: primaryTeal.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryTeal.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Professional diagonal pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(
                painter: CardDiagonalPainter(),
              ),
            ),
          ),
          
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Your bot image with professional styling
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        primaryTeal.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Image.asset('assets/images/lexivo_bot.png', height: 140),
                ),
                
                const SizedBox(height: 24),
                
                // Professional decorative elements
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProfessionalDot(),
                    const SizedBox(width: 16),
                    _buildProfessionalDot(),
                    const SizedBox(width: 16),
                    _buildProfessionalDot(),
                  ],
                ),
              ],
            ),
          ),
          
          // Corner accent
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: secondaryTeal,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryTeal, secondaryTeal],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryTeal.withOpacity(0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalTextContent() {
    return Column(
      children: [
        // Professional app name
        Text(
          'Lexivo',
          style: TextStyle(
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [primaryTeal, secondaryTeal],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            fontSize: 42,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            'Because learning should never feel hard',
            style: TextStyle(
              color: textSecondary,
              fontSize: 16,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTrustIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTrustIndicator(Icons.security, 'Secure'),
          _buildTrustIndicator(Icons.psychology, 'AI-Powered'),
          _buildTrustIndicator(Icons.verified, 'Trusted'),
        ],
      ),
    );
  }

  Widget _buildTrustIndicator(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: primaryTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: primaryTeal.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: primaryTeal,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalSwipeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: primaryTeal.withOpacity(0.3),
              blurRadius: 25,
              spreadRadius: 0,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: SwipeableButtonView(
          buttonText: "Swipe to Get Started",
          buttonWidget: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryTeal, secondaryTeal],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryTeal.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          activeColor: primaryTeal,
          isFinished: isFinished,
          onWaitingProcess: () {
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                isFinished = true;
              });
            });
          },
          onFinish: () async {
            await Navigator.pushReplacementNamed(context, '/login');
            setState(() {
              isFinished = false;
            });
          },
        ),
      ),
    );
  }
}

class ProfessionalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 0.8;

    // Professional diagonal lines
    paint.color = const Color(0xFF00D4AA).withOpacity(0.08);
    for (int i = 0; i < 30; i++) {
      final startX = (i * 25.0) - 150;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + size.height * 0.4, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CardDiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D4AA).withOpacity(0.06)
      ..strokeWidth = 0.5;

    // Subtle diagonal lines on card
    for (int i = 0; i < 12; i++) {
      final startX = (i * 30.0) - 60;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + size.height * 0.25, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}