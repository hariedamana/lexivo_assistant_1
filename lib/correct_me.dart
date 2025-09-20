import 'package:flutter/material.dart';

class CorrectMePage extends StatefulWidget {
  const CorrectMePage({super.key});

  @override
  State<CorrectMePage> createState() => _CorrectMePageState();
}

class _CorrectMePageState extends State<CorrectMePage> {
  final TextEditingController _controller = TextEditingController();
  String _correctedText = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkGrammar() {
    // This is where you would integrate your actual grammar check logic.
    // For now, it's just a placeholder.
    String text = _controller.text;
    if (text.isEmpty) {
      setState(() {
        _correctedText = 'Please enter some text to check.';
      });
      return;
    }

    // Simulate a grammar check
    setState(() {
      _correctedText = 'Corrected text would appear here: $text';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grammar Check'),
        backgroundColor: Colors.blueGrey[900],
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your text below:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Start typing here...',
                filled: true,
                fillColor: Colors.blueGrey[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkGrammar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[400],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Check Grammar',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (_correctedText.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[700],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _correctedText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}