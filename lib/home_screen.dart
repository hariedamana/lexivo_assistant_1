import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(
    const MaterialApp(home: HomeScreen(), debugShowCheckedModeBanner: false),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.textsms_rounded), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Start typing... I've got your back!",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Mascot and Progress in Rectangular Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/images/lexivo_bot.png', height: 90),
                    CircularPercentIndicator(
                      radius: 45.0,
                      lineWidth: 6.0,
                      percent: 0.75,
                      animation: true,
                      animationDuration: 1200,
                      center: const Text(
                        "75%\nCompleted",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      progressColor: Colors.greenAccent,
                      backgroundColor: Colors.grey.shade800,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Assistants",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Assistant Grid
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  AssistantTile(
                    icon: Icons.record_voice_over,
                    title: 'Text-to-Speech',
                  ),
                  AssistantTile(
                    icon: Icons.tips_and_updates,
                    title: 'Simplify',
                  ),
                  AssistantTile(icon: Icons.keyboard_alt, title: 'LexiType'),
                  AssistantTile(
                    icon: Icons.fact_check_outlined,
                    title: 'Correct Me',
                  ),
                ],
              ),

              const SizedBox(height: 25),
              const Text(
                "Recent Activities",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              const RecentCard(icon: Icons.people, title: "In Progress"),
              const SizedBox(height: 10),
              const RecentCard(
                icon: Icons.history_toggle_off,
                title: "Last Used",
              ),
              const SizedBox(height: 10),
              const RecentCard(icon: Icons.lightbulb_outline, title: "Updated"),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class AssistantTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const AssistantTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Widget targetPage;

        switch (title) {
          case 'Text-to-Speech':
            targetPage = const TextToSpeechPage();
            break;
          case 'Simplify':
            targetPage = const SimplifyPage();
            break;
          case 'LexiType':
            targetPage = const LexiTypePage();
            break;
          case 'Correct Me':
            targetPage = const CorrectMePage();
            break;
          default:
            targetPage = const AssistantsPage();
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.greenAccent),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.greenAccent),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class RecentCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const RecentCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

// Placeholder pages for each assistant
class TextToSpeechPage extends StatelessWidget {
  const TextToSpeechPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "Text-to-Speech",
      message: "This is the Text-to-Speech Assistant.",
    );
  }
}

class SimplifyPage extends StatelessWidget {
  const SimplifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "Simplify",
      message: "This is the Simplify Assistant.",
    );
  }
}

class LexiTypePage extends StatelessWidget {
  const LexiTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "LexiType",
      message: "This is the LexiType Assistant.",
    );
  }
}

class CorrectMePage extends StatelessWidget {
  const CorrectMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "Correct Me",
      message: "This is the Correct Me Assistant.",
    );
  }
}

class AssistantsPage extends StatelessWidget {
  const AssistantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssistantScaffold(
      title: "Assistants",
      message: "Welcome to Assistants Page!",
    );
  }
}

// Reusable Scaffold Widget for assistant pages
class AssistantScaffold extends StatelessWidget {
  final String title;
  final String message;

  const AssistantScaffold({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.greenAccent, fontSize: 18),
        ),
      ),
    );
  }
}
