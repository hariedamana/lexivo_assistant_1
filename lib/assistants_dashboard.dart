import 'package:flutter/material.dart';

class AssistantsDashboard extends StatefulWidget {
  const AssistantsDashboard({super.key});

  @override
  State<AssistantsDashboard> createState() => _AssistantsDashboardState();
}

class _AssistantsDashboardState extends State<AssistantsDashboard> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/chat'); // <-- Navigate to Chatbot
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<Map<String, dynamic>> assistants = [
    {'name': 'Text-to-Speech', 'icon': Icons.record_voice_over},
    {'name': 'Simplify', 'icon': Icons.auto_fix_high},
    {'name': 'LexiType', 'icon': Icons.keyboard_alt},
    {'name': 'Dictionary', 'icon': Icons.menu_book},
    {'name': 'PDF/Doc Reader', 'icon': Icons.picture_as_pdf},
    {'name': 'Word Coach', 'icon': Icons.school},
    {'name': 'Speak To Type', 'icon': Icons.mic},
    {'name': 'Correct Me', 'icon': Icons.spellcheck},
    {'name': 'Read Along', 'icon': Icons.chrome_reader_mode},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Smart Assistants',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for an assistant...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Subtitle
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tap an assistant to get started',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Assistants Grid
            Expanded(
              child: GridView.builder(
                itemCount: assistants.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final assistant = assistants[index];
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${assistant['name']} clicked')),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            assistant['icon'],
                            color: Colors.greenAccent,
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            assistant['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

      // Matching Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
