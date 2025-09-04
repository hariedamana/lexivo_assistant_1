import 'dart:ui';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Brand Colors (same as Login screen)
  static const Color primaryTeal = Color(0xFF00796B);
  static const Color secondaryBlue = Color(0xFF0288D1);
  static const Color textColor = Color(0xFF1C1C2A);

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                          child: child,
                        ),
                      );
                    },
                    child: _buildGlassCard(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard() {
    return Container(
      padding: const EdgeInsets.all(28),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [primaryTeal, secondaryBlue],
              ).createShader(bounds),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Email
          _buildInputField(
            controller: _emailController,
            hint: "Email",
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),

          // Password
          _buildInputField(
            controller: _passwordController,
            hint: "Password",
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Confirm Password
          _buildInputField(
            controller: _confirmPasswordController,
            hint: "Confirm Password",
            icon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              child: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Sign Up Button
          _buildPrimaryButton(),
          const SizedBox(height: 24),

          // Navigation to Login
          _buildBottomLink(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.5),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: textColor, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: primaryTeal.withOpacity(0.7)),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: primaryTeal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            : const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildBottomLink() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, '/login'),
        child: RichText(
          text: TextSpan(
            text: "Already have an account? ",
            style: TextStyle(color: textColor.withOpacity(0.7)),
            children: const [
              TextSpan(
                text: "Login",
                style: TextStyle(
                  color: primaryTeal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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