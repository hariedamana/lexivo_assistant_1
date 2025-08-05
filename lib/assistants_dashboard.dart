import 'package:flutter/material.dart';

class AssistantsDashboard extends StatelessWidget {
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
        title: Text('Smart Assistants', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for an assistant...',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Subtitle
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tap an assistant to get started',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            SizedBox(height: 20),

            // Assistants Grid
            Expanded(
              child: GridView.builder(
                itemCount: assistants.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final assistant = assistants[index];
                  return GestureDetector(
                    onTap: () {
                      // You can later add navigation to specific pages
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
                          SizedBox(height: 10),
                          Text(
                            assistant['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
      // Optional: Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Assistants',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
