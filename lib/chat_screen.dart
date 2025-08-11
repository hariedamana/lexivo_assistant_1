import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'assistants_dashboard.dart';
import 'profile_screen.dart';

class ChatbotScreen extends StatefulWidget {
  final int initialTabIndex;

  const ChatbotScreen({
    super.key,
    this.initialTabIndex = 2,
  });

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> chatHistory = [
    "Project Help",
    "Travel Plan",
    "PDF Summary",
  ];

  final List<Map<String, dynamic>> assistants = [
    {'label': 'TTS (Text-to-Speech)', 'icon': Icons.record_voice_over},
    {'label': 'STT (Speech-to-Text)', 'icon': Icons.mic},
    {'label': 'Dictionary', 'icon': Icons.book},
    {'label': 'PDF/Doc Reader', 'icon': Icons.picture_as_pdf},
    {'label': 'Simplify', 'icon': Icons.lightbulb_outline},
  ];

  List<Map<String, dynamic>> messages = [
    {'role': 'bot', 'text': 'How can I assist you today?'},
  ];

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
  }

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': text});
      messages.add({
        'role': 'bot',
        'text': 'You said: "$text"',
      });
    });

    _controller.clear();
  }

  Widget _buildUserMessage(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBotMessage(Map<String, dynamic> message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        message['text'] ?? '',
        style: const TextStyle(
          color: Color(0xFFBDF6FF),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    if (message['role'] == 'user') {
      return _buildUserMessage(message['text']);
    }
    return _buildBotMessage(message);
  }

  void _showAssistantsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF122033),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Assistants",
              style: TextStyle(
                  color: Color(0xFFBDF6FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...assistants.map(
              (a) => ListTile(
                leading: Icon(a['icon'], color: const Color(0xFF32E0FC)),
                title: Text(
                  a['label'],
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    messages.add({
                      'role': 'bot',
                      'text': 'Switched to ${a['label']} assistant.',
                    });
                  });
                },
              ),
            ),
            const Divider(color: Color(0xFF223447)),
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Color(0xFF32E0FC)),
              title: const Text('New Chat', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  messages = [
                    {'role': 'bot', 'text': 'How can I assist you today?'},
                  ];
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Color(0xFF32E0FC)),
              title: const Text('Chat History', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showChatHistoryBottomSheet();
              },
            )
          ],
        ),
      ),
    );
  }

  void _showChatHistoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF132031),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Previous Chats",
              style: TextStyle(
                color: Color(0xFFBDF6FF),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            ...chatHistory.map(
              (e) => ListTile(
                leading: const Icon(Icons.chat_bubble_outline, color: Color(0xFFBDF6FF)),
                title: Text(e, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    messages = [
                      {
                        'role': 'bot',
                        'text': 'Resumed chat: $e\n\nHow can I assist you today?'
                      }
                    ];
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AssistantsDashboard()),
        );
        break;
      case 2:
        // Already on chat
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final grad = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0F1B2B),
        Color(0xFF1A2B3F),
        Color(0xFF223A54),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: grad),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7DF9FF), Color(0xFF32E0FC)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.bubble_chart_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Lexi',
                      style: TextStyle(
                        color: Color(0xFFBDF6FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.more_horiz, color: Color(0xFFBDF6FF)),
                        onPressed: _showAssistantsMenu,
                        tooltip: "Assistants, New Chat & History",
                      ),
                    ),
                  ],
                ),
              ),

              // Chat messages
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 120, top: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, idx) => _buildMessage(messages[idx]),
                ),
              ),

              // Input bar
              Container(
                margin: const EdgeInsets.only(bottom: 18, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.10)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Color(0xFFBDF6FF), fontSize: 14),
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: Color(0xFFBDF6FF), fontWeight: FontWeight.w300),
                          ),
                          onSubmitted: (_) => sendMessage(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF7DF9FF), Color(0xFF32E0FC)],
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                      onPressed: sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom nav bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1F2B),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onNavTapped,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF00E5A0),
            unselectedItemColor: const Color(0xFF6B7280),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 26),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apps_rounded, size: 26),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_rounded, size: 26),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded, size: 26),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
