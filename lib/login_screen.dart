import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  // Enhanced Brand Colors - Professional Dark Theme
  static const Color primaryDark = Color(0xFF0F0F0F);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color accentGreen = Color(0xFF00D4AA);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color borderColor = Color(0xFF333333);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color surfaceColor = Color(0xFF242424);

  late AnimationController _fadeController;
  late AnimationController _logoController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _logoAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _logoController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _logoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Enhanced Login with Better UX
  void _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // --- Hardcoded Admin Login ---
    if (email == "admin1@lexivo.com" && password == "admin1@lexivo") {
      if (mounted) {
        _showSuccessSnackBar("Welcome back, Admin!");
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushReplacementNamed(context, '/adminHome');
      }
      setState(() => _isLoading = false);
      return;
    }

    // --- Firebase Login for Normal Users ---
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        _showSuccessSnackBar("Welcome back to Lexivo!");
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email address.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
        default:
          errorMessage = 'Login failed. Please check your credentials.';
          break;
      }
      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: accentGreen, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: cardDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: errorColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: cardDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryDark, const Color(0xFF1A1A1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildBackgroundDecorations(),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AnimatedBuilder(
                    animation: _fadeController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        _buildWelcomeHeader(),
                        const SizedBox(height: 40),
                        _buildLoginCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Professional Welcome Header
  Widget _buildWelcomeHeader() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoAnimation.value,
          child: Column(
            children: [
              // Professional Logo
              Container(
                width: 100,
                height: 100,
                child: Image.asset(
                  'assets/images/lexivo_bot.png', // Replace with your file path
                  fit: BoxFit.contain,
                ),
              ),
              
              const SizedBox(height: 24),
              // Welcome Text
              Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 18,
                  color: textSecondary,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [accentGreen, accentBlue],
                ).createShader(bounds),
                child: const Text(
                  "Lexivo",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Lexend',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your AI-powered learning companion',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Professional Glass Login Card
  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: cardDark.withOpacity(0.8),
        border: Border.all(
          color: borderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 32,
            offset: const Offset(0, 12),
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Login Header
                Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    fontFamily: 'Lexend',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue your learning journey',
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    fontFamily: 'Lexend',
                  ),
                ),
                const SizedBox(height: 32),
                
                // Email Field
                _buildProfessionalInputField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Password Field
                _buildProfessionalInputField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                      HapticFeedback.selectionClick();
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Remember Me & Forgot Password
                _buildRememberMeRow(),
                const SizedBox(height: 32),
                
                // Login Button
                _buildPrimaryButton(),
                const SizedBox(height: 24),
                
                // Divider
                _buildDivider(),
                const SizedBox(height: 24),
                
                // Social Buttons
                _buildSocialButtons(),
                const SizedBox(height: 24),
                
                // Sign Up Link
                _buildBottomLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Professional Input Field
  Widget _buildProfessionalInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            fontFamily: 'Lexend',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontFamily: 'Lexend',
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: textSecondary.withOpacity(0.6),
              fontFamily: 'Lexend',
            ),
            prefixIcon: Icon(
              icon,
              color: accentGreen,
              size: 20,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: surfaceColor.withOpacity(0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: borderColor.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: accentGreen,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: errorColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: errorColor,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
            errorStyle: TextStyle(
              color: errorColor,
              fontSize: 12,
              fontFamily: 'Lexend',
            ),
          ),
        ),
      ],
    );
  }

  /// Remember Me Row
  Widget _buildRememberMeRow() {
    return Row(
      children: [
        Transform.scale(
          scale: 0.9,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() => _rememberMe = value ?? false);
              HapticFeedback.selectionClick();
            },
            fillColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return accentGreen;
              }
              return Colors.transparent;
            }),
            side: BorderSide(color: textSecondary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        Text(
          'Remember me',
          style: TextStyle(
            color: textSecondary,
            fontSize: 14,
            fontFamily: 'Lexend',
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            _showForgotPasswordDialog();
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: accentGreen,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lexend',
            ),
          ),
        ),
      ],
    );
  }

  /// Enhanced Login Button
  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _loginUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: accentGreen.withOpacity(0.6),
        ),
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lexend',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
      ),
    );
  }

  /// Professional Divider
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: borderColor.withOpacity(0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Or continue with",
            style: TextStyle(
              color: textSecondary,
              fontSize: 14,
              fontFamily: 'Lexend',
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: borderColor.withOpacity(0.3))),
      ],
    );
  }

  /// Enhanced Social Buttons
  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(
          icon: Icons.g_mobiledata,
          label: 'Google',
          onPressed: () => _handleSocialLogin('Google'),
        ),
        _buildSocialButton(
          icon: Icons.apple,
          label: 'Apple',
          onPressed: () => _handleSocialLogin('Apple'),
        ),
        _buildSocialButton(
          icon: Icons.facebook,
          label: 'Facebook',
          onPressed: () => _handleSocialLogin('Facebook'),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        width: 80,
        height: 56,
        decoration: BoxDecoration(
          color: surfaceColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor.withOpacity(0.3)),
        ),
        child: Icon(
          icon,
          color: textPrimary,
          size: 24,
        ),
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$provider login coming soon!',
          style: TextStyle(fontFamily: 'Lexend'),
        ),
        backgroundColor: cardDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Professional Bottom Link
  Widget _buildBottomLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          HapticFeedback.selectionClick();
          Navigator.pushNamed(context, '/signup');
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: textSecondary,
              fontSize: 14,
              fontFamily: 'Lexend',
            ),
            children: [
              TextSpan(
                text: "Sign up",
                style: TextStyle(
                  color: accentGreen,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Lexend',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.lock_reset_rounded, color: accentGreen, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'Reset Password',
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w700,
                fontFamily: 'Lexend',
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: TextStyle(
            color: textSecondary,
            fontFamily: 'Lexend',
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: textSecondary,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Password reset link sent to your email!');
            },
            child: Text(
              'Send Link',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Enhanced Background Decorations
  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        // Top left gradient orb
        Positioned(
          top: -80,
          left: -60,
          child: Container(
            width: 200,
            height: 200,
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
        // Bottom right gradient orb
        Positioned(
          bottom: -100,
          right: -80,
          child: Container(
            width: 250,
            height: 250,
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
        // Additional subtle decoration
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          right: -50,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  accentGreen.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}