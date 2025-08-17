import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  static const Color primaryTeal = Color(0xFF00D4AA);
  static const Color darkBackground = Color(0xFF0A0E27);
  static const Color cardBackground = Color(0xFF1A1E3A);
  static const Color inputBackground = Color(0xFF2A2E54);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color borderColor = Color(0xFF3A3E5A);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        default:
          errorMessage = 'Login failed: ${e.message}';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            _buildMinimalBackground(),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildLoginCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: MinimalBackgroundPainter(),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cardBackground.withOpacity(0.95),
        border: Border.all(
          color: borderColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMinimalHeader(),
          const SizedBox(height: 32),
          _buildCleanInputs(),
          const SizedBox(height: 28),
          _buildPrimaryButton(),
          const SizedBox(height: 20),
          _buildMinimalDivider(),
          const SizedBox(height: 20),
          _buildSocialButtons(),
          const SizedBox(height: 24),
          _buildBottomLink(),
        ],
      ),
    );
  }

  Widget _buildMinimalHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: inputBackground.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: textPrimary, size: 16),
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Login",
          style: TextStyle(
            color: textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Enter your Email and Password.",
          style: TextStyle(
            color: textSecondary.withOpacity(0.8),
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildCleanInputs() {
    return Column(
      children: [
        _buildCleanInputField(
          controller: _emailController,
          hintText: "Email",
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildCleanInputField(
          controller: _passwordController,
          hintText: "Password",
          obscureText: _obscurePassword,
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: textSecondary.withOpacity(0.6),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCleanInputField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: inputBackground.withOpacity(0.6),
        border: Border.all(
          color: borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: textPrimary, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: textSecondary.withOpacity(0.6),
            fontSize: 16,
          ),
          suffixIcon: suffixIcon != null
              ? Padding(padding: const EdgeInsets.only(right: 12), child: suffixIcon)
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: primaryTeal.withOpacity(0.4),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: primaryTeal,
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _loginUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildMinimalDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: borderColor.withOpacity(0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Or",
            style: TextStyle(
              color: textSecondary.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: borderColor.withOpacity(0.3))),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        _buildSocialButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google Sign-In not yet implemented.')),
          ),
          icon: Icons.g_mobiledata,
          label: "Sign in with Google",
        ),
        const SizedBox(height: 12),
        _buildSocialButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Apple Sign-In not yet implemented.')),
          ),
          icon: Icons.apple,
          label: "Sign in with Apple",
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor.withOpacity(0.4), width: 1),
          color: inputBackground.withOpacity(0.3),
        ),
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: textPrimary, size: 20),
          label: Text(
            label,
            style: TextStyle(
              color: textPrimary.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomLink() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, '/signup'),
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: textSecondary.withOpacity(0.7),
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: "Sign Up",
                style: TextStyle(
                  color: primaryTeal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MinimalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 0.5;

    paint.color = const Color(0xFF00D4AA).withOpacity(0.03);
    for (int i = 0; i < 20; i++) {
      final startX = (i * 40.0) - 100;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + size.height * 0.2, size.height),
        paint,
      );
    }

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.8;

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.15),
      30,
      paint..color = const Color(0xFF00D4AA).withOpacity(0.05),
    );

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.85),
      20,
      paint..color = const Color(0xFF00D4AA).withOpacity(0.04),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
