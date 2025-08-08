import 'package:flutter/material.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Image.asset('assets/images/lexivo_bot.png', height: 200),
            ),
            const SizedBox(height: 24),
            const Text(
              'Lexivo',
              style: TextStyle(
                color: Color(0xFF00FF84),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Because learning should never feel hard',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SwipeableButtonView(
                buttonText: "Swipe to Get Started",
                buttonWidget: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                ),
                activeColor: const Color(0xFF00FF84),
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}