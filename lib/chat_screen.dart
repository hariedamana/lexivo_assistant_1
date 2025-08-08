import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, String>> messages = [
    {
      'role': 'bot',
      'text': 'Hey! I’m Lexi 👾 — your AI buddy. Pick an assistant from the menu or ask me anything.',
    },
  ];

  String selectedAssistant = "General AI";

  final List<Map<String, dynamic>> assistantsMenu = [
    {'value': 'General AI', 'icon': Icons.smart_toy},
    {'value': 'PDF Upload', 'icon': Icons.picture_as_pdf},
    {'value': 'Text-to-Speech', 'icon': Icons.record_voice_over},
    {'value': 'Word Coach', 'icon': Icons.school},
    {'value': 'Read Along', 'icon': Icons.chrome_reader_mode},
    {'value': 'Speak To Type', 'icon': Icons.mic},
  ];

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': text});
      messages.add({'role': 'bot', 'text': '🤖 Thinking...'});
    });

    _controller.clear();

    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() {
        messages.removeWhere((m) => m['text'] == '🤖 Thinking...');
        messages.add({
          'role': 'bot',
          'text': '[$selectedAssistant] Demo response from Lexi — you asked: "$text".'
        });
      });
    });
  }

  void _onAssistantSelected(String value) {
    if (value == 'PDF Upload') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF Upload selected — (demo)')),
      );
    }
    setState(() {
      selectedAssistant = value;
      messages.add({'role': 'bot', 'text': 'Assistant switched to: $value. Ready when you are.'});
    });
  }

  Widget buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'user';
    final bubbleColor = isUser ? const Color(0xFF00FF7F) : const Color(0xFF1A1A1A);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            message['text'] ?? '',
            style: TextStyle(
              color: isUser ? Colors.black : const Color(0xFF00FF7F),
              fontSize: 15,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF000000); // Pure black
    const appBarColor = Color(0xFF0D0D0D);
    const inputBarColor = Color(0xFF0D0D0D);
    const accentGreen = Color(0xFF00FF7F);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: accentGreen),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Image.asset('assets/images/lexivo_bot.png', height: 32, width: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lexi – Your AI Buddy 👾',
                    style: TextStyle(color: accentGreen, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(selectedAssistant, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, idx) => buildMessage(messages[idx]),
            ),
          ),
          Container(
            color: inputBarColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Attachment (demo)')),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline, color: accentGreen),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              maxLines: null,
                              style: const TextStyle(color: accentGreen),
                              decoration: const InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => sendMessage(),
                            ),
                          ),
                          PopupMenuButton<String>(
                            tooltip: 'Assistants',
                            icon: const Icon(Icons.more_vert, color: accentGreen),
                            color: appBarColor,
                            onSelected: _onAssistantSelected,
                            itemBuilder: (ctx) {
                              return assistantsMenu.map((item) {
                                return PopupMenuItem<String>(
                                  value: item['value'],
                                  child: Row(
                                    children: [
                                      Icon(item['icon'], color: accentGreen, size: 18),
                                      const SizedBox(width: 10),
                                      Text(item['value'], style: const TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.all(14),
                      elevation: 0,
                    ),
                    child: const Icon(Icons.send, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
