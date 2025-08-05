import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'assistants_dashboard.dart'; // <-- Import this

void main() {
  runApp(const LexivoApp());
}

class LexivoApp extends StatelessWidget {
  const LexivoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lexivo Assistant',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/assistants': (context) => AssistantsDashboard(), // <-- Add this
      },
    );
  }
}
