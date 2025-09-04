import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

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

  // Theme Colors
  static const Color primaryTeal = Color(0xFF00796B);
  static const Color secondaryBlue = Color(0xFF0288D1);
  static const Color accentGreen = Color(0xFF43A047);
  static const Color textColor = Color(0xFF1C1C2A);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightCard = Colors.white;

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': text});
      messages.add({'role': 'bot', 'text': 'You said: "$text"'});
    });

    _controller.clear();
  }

  Widget _buildUserMessage(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: accentGreen.withOpacity(0.2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ),
      ),
    );
  }

  Widget _buildBotMessage(Map<String, dynamic> message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: BoxDecoration(
        color: secondaryBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        message['text'] ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    return message['role'] == 'user'
        ? _buildUserMessage(message['text'])
        : _buildBotMessage(message);
  }

  void _showAssistantsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: lightCard,
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
                  color: primaryTeal, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...assistants.map(
              (a) => ListTile(
                leading: Icon(a['icon'], color: secondaryBlue),
                title: Text(a['label'], style: const TextStyle(color: textColor)),
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryTeal, secondaryBlue],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.bubble_chart_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Lexi',
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold, fontSize: 21),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: lightCard.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.more_horiz, color: textColor),
                      onPressed: _showAssistantsMenu,
                    ),
                  ),
                ],
              ),
            ),

            // Chat messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 10, top: 8),
                itemCount: messages.length,
                itemBuilder: (context, idx) => _buildMessage(messages[idx]),
              ),
            ),

            // Input bar
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: lightCard.withOpacity(0.08),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: primaryTeal.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: textColor, fontSize: 14),
                        maxLines: 4,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w300),
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
                          colors: [primaryTeal, secondaryBlue],
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
    );
  }
}
