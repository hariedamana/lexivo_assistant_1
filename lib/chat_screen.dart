import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            const Text(
              'Lexi – Your AI Buddy',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/lexi_icon.png', // Replace with your mascot icon
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Placeholder for chat bubbles (ListView or whatever you use)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Placeholder(
                color: Colors.green,
              ), // Remove this once chat bubbles are added
            ),
          ),

          // Bottom Chat Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () {
                    // Open menu or more options
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.greenAccent),
                  onPressed: () {
                    // Voice input logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
