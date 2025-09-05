import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  String _searchQuery = '';
  Map<String, String> _allWords = {}; // Full A-Z dictionary
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDictionary();
  }

  Future<void> _loadDictionary() async {
    // Load the JSON file from assets
    String jsonString = await rootBundle.loadString('assets/words.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    // Flatten the nested A-Z map into one map
    Map<String, String> flatMap = {};
    jsonMap.forEach((letter, words) {
      (words as Map<String, dynamic>).forEach((word, definition) {
        flatMap[word] = definition.toString();
      });
    });

    setState(() {
      _allWords = flatMap;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredWords = _searchQuery.isEmpty
        ? _allWords.keys.toList()
        : _allWords.keys
            .where((word) =>
                word.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
        backgroundColor: const Color(0xFF00796B),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search field
                  TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search a word...',
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF00796B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Results list
                  Expanded(
                    child: filteredWords.isEmpty
                        ? const Center(
                            child: Text(
                              'No results found',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredWords.length,
                            itemBuilder: (context, index) {
                              final word = filteredWords[index];
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                child: ListTile(
                                  title: Text(
                                    word,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    _allWords[word]!,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
