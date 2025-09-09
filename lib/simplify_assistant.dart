import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SimplifyAssistant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simplify Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: AssistantDashboard(),
      routes: {
        '/simplify-text': (context) => SimplifyTextPage(),
        '/syllables': (context) => SyllableBreakdownPage(),
      },
    );
  }
}

class AssistantDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Simplify Assistant',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.assistant, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Welcome to Simplify Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Choose a tool to get started',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              Text(
                'Available Tools',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 15),

              // Simplify Text Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SimplifyTextPage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.green.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.text_fields,
                          color: Colors.green[600],
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Simplify Text',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Make complex text easier to understand',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              // Syllable Breakdown Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SyllableBreakdownPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.speaker_notes,
                          color: Colors.orange[600],
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Syllable Breakdown',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Break words into syllables for easier reading',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              Spacer(),

              // Footer
              Center(
                child: Text(
                  'Choose a tool above to get started',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimplifyTextPage extends StatefulWidget {
  @override
  _SimplifyTextPageState createState() => _SimplifyTextPageState();
}

class _SimplifyTextPageState extends State<SimplifyTextPage> {
  TextEditingController _inputController = TextEditingController();
  String _simplifiedText = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Simplify Text',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[600],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.text_fields,
                          color: Colors.green[600],
                          size: 30,
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Text Simplification',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Enter complex text below and get a simplified version that\'s easier to understand.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Input Section
              Text(
                'Enter Text to Simplify',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _inputController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter complex text here...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Simplify Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _simplifyText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Simplifying...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                      : Text(
                          'Simplify Text',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 20),

              // Output Section
              if (_simplifiedText.isNotEmpty) ...[
                Text(
                  'Simplified Text',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),

                SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Text(
                    _simplifiedText,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _simplifyText() {
    if (_inputController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _simplifiedText = 'Simplified version: ${_inputController.text}';
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}

class SyllableBreakdownPage extends StatefulWidget {
  @override
  _SyllableBreakdownPageState createState() => _SyllableBreakdownPageState();
}

class _SyllableBreakdownPageState extends State<SyllableBreakdownPage> {
  TextEditingController _inputController = TextEditingController();
  List<String> _syllables = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Syllable Breakdown',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[600],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.speaker_notes,
                          color: Colors.orange[600],
                          size: 30,
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Syllable Breakdown',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Enter a word to break it down into syllables for easier pronunciation and reading.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Input Section
              Text(
                'Enter Word',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    hintText: 'Enter a word...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(15),
                    prefixIcon: Icon(
                      Icons.text_fields,
                      color: Colors.orange[600],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Break Down Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _breakDownSyllables,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[600],
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Breaking Down...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                      : Text(
                          'Break Into Syllables',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 20),

              // Output Section
              if (_syllables.isNotEmpty) ...[
                Text(
                  'Syllable Breakdown',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),

                SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _syllables.map((syllable) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.orange[300]!),
                            ),
                            child: Text(
                              syllable,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[800],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 15),
                      Text(
                        '${_syllables.length} syllable${_syllables.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _breakDownSyllables() async {
    final word = _inputController.text.trim();
    if (word.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Use 10.0.2.2 for Android emulator to access localhost backend
      final url = Uri.parse('http://10.0.2.2:8000/syllables');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'word': word}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> syllables = List<String>.from(data['syllables']);
        setState(() {
          _syllables = syllables;
        });
      } else {
        print('Backend error: ${response.statusCode}');
        // Optionally handle error UI here
      }
    } catch (e) {
      print('Failed to connect to backend: $e');
      // Optionally handle connection error UI here
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> _simpleSyllableBreakdown(String word) {
    // Keeping your local fallback logic intact (optional)
    if (word.length <= 3) return [word];

    List<String> vowels = ['a', 'e', 'i', 'o', 'u', 'y'];
    List<String> syllables = [];
    String currentSyllable = '';

    for (int i = 0; i < word.length; i++) {
      currentSyllable += word[i];

      if (vowels.contains(word[i]) && currentSyllable.length >= 2) {
        if (i < word.length - 1 && !vowels.contains(word[i + 1])) {
          syllables.add(currentSyllable);
          currentSyllable = '';
        }
      }
    }

    if (currentSyllable.isNotEmpty) {
      if (syllables.isNotEmpty) {
        syllables.last += currentSyllable;
      } else {
        syllables.add(currentSyllable);
      }
    }

    return syllables.isEmpty ? [word] : syllables;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
