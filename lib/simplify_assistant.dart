import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

void main() {
  runApp(SimplifyAssistant());
}

class SimplifyAssistant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simplify Assistant',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark, // Changed to dark brightness
        ),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ),
      home: AssistantDashboard(),
      routes: {
        '/tools': (context) => ToolsPage(),
      },
    );
  }
}

class AssistantDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Changed background color to dark
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Hero Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6),
                        Color(0xFFEC4899),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Simplify Assistant',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Transform complex text into clear, easy-to-understand content',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  'Available Tools',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white, // Changed text color to white
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Choose the tool that best fits your needs',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFFB3B3B3), // Changed text color to light gray
                  ),
                ),

                const SizedBox(height: 24),

                // Main Tool Card - Simplify Text (leads to combined tools page)
                _buildMainToolCard(
                  context: context,
                  title: 'Simplify Text',
                  subtitle: 'Access text simplification and syllable breakdown tools',
                  icon: Icons.text_format_rounded,
                  color: const Color(0xFF10B981),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ToolsPage()),
                  ),
                ),

                const SizedBox(height: 40),

                // Features Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E), // Changed card background to dark gray
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF333333), // Changed border color
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Powerful Features',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white, // Changed text color to white
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFeatureItem(
                              icon: Icons.text_fields,
                              title: 'Text Simplification',
                              description: 'Convert complex sentences into simple, clear language',
                              color: const Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildFeatureItem(
                              icon: Icons.spatial_audio_off_rounded,
                              title: 'Syllable Breakdown',
                              description: 'Break words into syllables for better pronunciation',
                              color: const Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Stats Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E), // Changed card background to dark gray
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF333333), // Changed border color
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Trusted by Students & Professionals',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white, // Changed text color to white
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('1M+', 'Words\nProcessed'),
                          _buildStatItem('50K+', 'Users\nHelped'),
                          _buildStatItem('99%', 'Accuracy\nRate'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainToolCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF5F5F5), // Changed text color to white
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFB3B3B3), // Changed text color to light gray
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6366F1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFB3B3B3), // Changed text color to light gray
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

// Combined Tools Page with Tab Navigation
class ToolsPage extends StatefulWidget {
  @override
  _ToolsPageState createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Changed background color to dark
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Changed background color to dark gray
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF333333)), // Changed border color
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white, // Changed icon color to white
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Simplify Tools',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white, // Changed text color to white
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Changed container background to dark gray
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF333333)), // Changed border color
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
              ),
              indicatorPadding: const EdgeInsets.all(4),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF9CA3AF), // Changed text color to a lighter gray
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.text_fields, size: 18),
                      const SizedBox(width: 8),
                      Text('Text Simplification'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.spatial_audio_off_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text('Syllable Breakdown'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TextSimplificationTab(),
          SyllableBreakdownTab(),
        ],
      ),
    );
  }
}

// Text Simplification Tab
class TextSimplificationTab extends StatefulWidget {
  @override
  _TextSimplificationTabState createState() => _TextSimplificationTabState();
}

class _TextSimplificationTabState extends State<TextSimplificationTab> {
  TextEditingController _inputController = TextEditingController();
  String _simplifiedText = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.text_fields,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Text Simplification',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Transform complex sentences into clear, simple language that everyone can understand',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Input Section
            Text(
              'Enter Complex Text',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white, // Changed text color to white
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Paste or type the complex text you want to simplify',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFFB3B3B3), // Changed text color to light gray
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), // Changed container background to dark gray
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF333333)), // Changed border color
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _inputController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Enter your complex text here...\n\nExample: "The implementation of sophisticated algorithms necessitates comprehensive understanding of computational paradigms."',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    height: 1.5,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E), // Changed fill color to dark gray
                  contentPadding: const EdgeInsets.all(20),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white, // Changed text color to white
                ),
                onChanged: (text) {
                  setState(() {}); // Trigger rebuild to update button state
                },
              ),
            ),

            const SizedBox(height: 24),

            // Action Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _inputController.text.trim().isEmpty || _isLoading 
                    ? null 
                    : _simplifyText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: const Color(0xFF333333), // Changed disabled background to a darker gray
                  disabledForegroundColor: const Color(0xFF9CA3AF),
                ),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Simplifying...',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_fix_high, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Simplify Text',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 32),

            // Output Section
            if (_simplifiedText.isNotEmpty) ...[
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Simplified Result',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white, // Changed text color to white
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), // Changed container background to dark gray
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF10B981).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _simplifiedText,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white, // Changed text color to white
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333), // Changed background color to a darker gray
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFF10B981),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Complexity reduced by ~${_calculateComplexityReduction()}%',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB3B3B3), // Changed text color to light gray
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action buttons for result
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _simplifiedText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.white), // Changed icon color
                      label: const Text('Copy Result', style: TextStyle(color: Colors.white)), // Changed text color
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF333333)), // Changed border color
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _inputController.clear();
                          _simplifiedText = '';
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 18, color: Color(0xFF9CA3AF)), // Changed icon color
                      label: const Text('Clear All', style: TextStyle(color: Color(0xFF9CA3AF))), // Changed text color
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF333333)), // Changed border color
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Tips Section (when no result)
            if (_simplifiedText.isEmpty && _inputController.text.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), // Changed container background to dark gray
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF333333)), // Changed border color
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.lightbulb_rounded,
                            color: Color(0xFF3B82F6),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tips for Better Results',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white, // Changed text color to white
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Use complete sentences or paragraphs\n'
                      '• Academic or technical text works best\n'
                      '• Longer text provides better context\n'
                      '• Check the simplified result for accuracy',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFB3B3B3), // Changed text color to light gray
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _simplifyText() {
    if (_inputController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call with better processing time
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        String inputText = _inputController.text;
        String simplifiedText = _generateSimplifiedText(inputText);
        _simplifiedText = simplifiedText;
        _isLoading = false;
      });
    });
  }

  String _generateSimplifiedText(String originalText) {
    // Enhanced text simplification with more comprehensive replacements
    Map<String, String> replacements = {
      // Complex to simple word replacements
      'utilize|utilization': 'use',
      'facilitate|facilitation': 'help',
      'demonstrate|demonstration': 'show',
      'acquire|acquisition': 'get',
      'commence|commencement': 'start',
      'terminate|termination': 'end',
      'comprehend|comprehension': 'understand',
      'subsequently': 'then',
      'furthermore': 'also',
      'nevertheless': 'but',
      'approximately': 'about',
      'modification': 'change',
      'assistance': 'help',
      'regarding': 'about',
      'preliminary': 'early',
      'sufficient': 'enough',
      'implement|implementation': 'put in place',
      'sophisticated': 'advanced',
      'necessitates': 'needs',
      'comprehensive': 'complete',
      'computational': 'computer',
      'paradigms': 'methods',
      'establish|establishment': 'set up',
      'methodology': 'method',
      'optimization': 'improvement',
      'parameters': 'settings',
      'articulate': 'express',
      'prevalent': 'common',
      'substantial': 'large',
      'constitute': 'make up',
      'endeavor': 'try',
      'expedite': 'speed up',
      'magnitude': 'size',
      'pertaining': 'about',
      'pursuant': 'following',
      'ascertain': 'find out',
      'ameliorate': 'improve',
      'consolidate': 'combine',
      'corroborate': 'confirm',
      'diminish': 'reduce',
      'elucidate': 'explain',
      'fluctuate': 'change',
      'generate': 'create',
      'hypothesize': 'guess',
      'illuminate': 'light up',
      'incorporate': 'include',
      'predominant': 'main',
      'proficient': 'skilled',
    };

    String result = originalText;
    
    replacements.forEach((complex, simple) {
      result = result.replaceAll(
        RegExp(r'\b(' + complex + r')\b', caseSensitive: false), 
        simple
      );
    });

    // Split long sentences and simplify structure
    List<String> sentences = result.split(RegExp(r'[.!?]+'));
    List<String> simplifiedSentences = [];

    for (String sentence in sentences) {
      if (sentence.trim().isEmpty) continue;
      
      String trimmed = sentence.trim();
      
      // Break down complex sentences with multiple clauses
      if (trimmed.contains(',') && trimmed.length > 50) {
        List<String> clauses = trimmed.split(',');
        for (int i = 0; i < clauses.length; i++) {
          String clause = clauses[i].trim();
          if (clause.isNotEmpty) {
            if (i == 0) {
              simplifiedSentences.add(clause + '.');
            } else {
              // Make dependent clauses into simple sentences
              if (!clause.toLowerCase().startsWith('and') && 
                  !clause.toLowerCase().startsWith('but') &&
                  !clause.toLowerCase().startsWith('or')) {
                simplifiedSentences.add('Also, ' + clause.toLowerCase() + '.');
              } else {
                simplifiedSentences.add(clause.substring(0, 1).toUpperCase() + 
                                       clause.substring(1) + '.');
              }
            }
          }
        }
      } else {
        simplifiedSentences.add(trimmed + '.');
      }
    }

    return simplifiedSentences.join(' ').replaceAll('..', '.');
  }

  int _calculateComplexityReduction() {
    if (_inputController.text.isEmpty || _simplifiedText.isEmpty) return 0;
    
    int originalWords = _inputController.text.split(' ').length;
    int simplifiedWords = _simplifiedText.split(' ').length;
    
    // Calculate based on word count and average word length
    double originalAvgLength = _inputController.text.replaceAll(' ', '').length / originalWords;
    double simplifiedAvgLength = _simplifiedText.replaceAll(' ', '').length / simplifiedWords;
    
    double reduction = ((originalAvgLength - simplifiedAvgLength) / originalAvgLength * 100);
    return reduction.clamp(5, 85).round();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}

// Syllable Breakdown Tab
class SyllableBreakdownTab extends StatefulWidget {
  @override
  _SyllableBreakdownTabState createState() => _SyllableBreakdownTabState();
}

class _SyllableBreakdownTabState extends State<SyllableBreakdownTab> {
  TextEditingController _inputController = TextEditingController();
  List<String> _syllables = [];
  bool _isLoading = false;
  String _currentWord = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.spatial_audio_off_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Syllable Breakdown',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Break down words into syllables for better pronunciation and reading practice',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Input Section
            Text(
              'Enter a Word',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white, // Changed text color to white
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Type any word to see its syllable breakdown',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFFB3B3B3), // Changed text color to light gray
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), // Changed container background to dark gray
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF333333)), // Changed border color
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: 'Enter a word... (e.g., "beautiful", "computer", "elephant")',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E), // Changed fill color to dark gray
                  contentPadding: const EdgeInsets.all(20),
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.spatial_audio_off_rounded,
                      color: Color(0xFFF59E0B),
                      size: 20,
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 16, color: Colors.white), // Changed text color to white
                onChanged: (text) {
                  setState(() {}); // Trigger rebuild to update button state
                },
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty && !_isLoading) {
                    _breakDownSyllables();
                  }
                },
              ),
            ),

            const SizedBox(height: 24),

            // Action Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _inputController.text.trim().isEmpty || _isLoading
                    ? null
                    : _breakDownSyllables,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: const Color(0xFF333333), // Changed disabled background to a darker gray
                  disabledForegroundColor: const Color(0xFF9CA3AF),
                ),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Breaking Down...',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.graphic_eq, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Break Into Syllables',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 32),

            // Output Section
            if (_syllables.isNotEmpty) ...[
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFFF59E0B),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Syllable Breakdown',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white, // Changed text color to white
                          ),
                        ),
                        Text(
                          'Word: "$_currentWord"',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFB3B3B3), // Changed text color to light gray
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), // Changed container background to dark gray
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    // Syllable chips with animations
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _syllables.asMap().entries.map((entry) {
                        final index = entry.key;
                        final syllable = entry.value;
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          curve: Curves.easeOutBack,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFF59E0B).withOpacity(0.9),
                                const Color(0xFFD97706).withOpacity(0.9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF59E0B).withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                syllable,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Pronunciation Guide
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333), // Changed background color to a darker gray
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF59E0B).withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.record_voice_over,
                                color: const Color(0xFFF59E0B),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pronunciation: ${_syllables.join(' • ')}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white, // Changed text color to white
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatColumn(
                                '${_syllables.length}',
                                _syllables.length == 1 ? 'Syllable' : 'Syllables',
                                Icons.graphic_eq,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: const Color(0xFFE5E7EB).withOpacity(0.3), // Changed divider color
                              ),
                              _buildStatColumn(
                                '${_currentWord.length}',
                                'Letters',
                                Icons.text_fields,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: const Color(0xFFE5E7EB).withOpacity(0.3), // Changed divider color
                              ),
                              _buildStatColumn(
                                _getDifficultyLevel(),
                                'Difficulty',
                                Icons.trending_up,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action buttons for result
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        String syllableText = _syllables.join(' • ');
                        Clipboard.setData(ClipboardData(text: syllableText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Syllables copied to clipboard!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.white), // Changed icon color
                      label: const Text('Copy Result', style: TextStyle(color: Colors.white)), // Changed text color
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF333333)), // Changed border color
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _inputController.clear();
                          _syllables = [];
                          _currentWord = '';
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 18, color: Color(0xFF9CA3AF)), // Changed icon color
                      label: const Text('Try Another', style: TextStyle(color: Color(0xFF9CA3AF))), // Changed text color
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF333333)), // Changed border color
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 32),

            // Tips Section (when no result)
            if (_syllables.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), // Changed container background to dark gray
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF333333)), // Changed border color
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.lightbulb_rounded,
                            color: Color(0xFF3B82F6),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Syllable Tips',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white, // Changed text color to white
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Try words like "beautiful" (beau•ti•ful), "computer" (com•pu•ter)\n'
                      '• Each syllable usually contains one vowel sound\n'
                      '• Syllables help with pronunciation and spelling\n'
                      '• Longer words typically have more syllables',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFB3B3B3), // Changed text color to light gray
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

            // Example words section
            if (_syllables.isEmpty)
              const SizedBox(height: 16),
            
            if (_syllables.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), // Changed container background to dark gray
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF333333)), // Changed border color
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Try These Example Words',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white, // Changed text color to white
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'beautiful', 'computer', 'elephant', 'wonderful',
                        'fantastic', 'incredible', 'amazing', 'telephone'
                      ].map((word) => GestureDetector(
                        onTap: () {
                          _inputController.text = word;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFF59E0B).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            word,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFF59E0B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFFF59E0B),
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF59E0B),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFFB3B3B3), // Changed text color to light gray
          ),
        ),
      ],
    );
  }

  String _getDifficultyLevel() {
    int syllableCount = _syllables.length;
    if (syllableCount <= 2) return 'Easy';
    if (syllableCount <= 4) return 'Medium';
    return 'Hard';
  }

  void _breakDownSyllables() async {
    final word = _inputController.text.trim();
    if (word.isEmpty) return;

    setState(() {
      _isLoading = true;
      _currentWord = word;
    });

    try {
      // Try to connect to backend first
      final url = Uri.parse('http://10.0.2.2:8000/syllables');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'word': word}),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> syllables = List<String>.from(data['syllables']);
        setState(() {
          _syllables = syllables.isNotEmpty ? syllables : _simpleSyllableBreakdown(word);
        });
      } else {
        log('Backend error: ${response.statusCode}');
        setState(() {
          _syllables = _simpleSyllableBreakdown(word);
        });
      }
    } catch (e) {
      log('Failed to connect to backend: $e');
      // Use local fallback algorithm
      setState(() {
        _syllables = _simpleSyllableBreakdown(word);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> _simpleSyllableBreakdown(String word) {
    if (word.length <= 3) return [word];

    String cleanWord = word.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (cleanWord.isEmpty) return [word];

    List<String> vowels = ['a', 'e', 'i', 'o', 'u', 'y'];
    List<String> syllables = [];
    String currentSyllable = '';

    for (int i = 0; i < cleanWord.length; i++) {
      currentSyllable += cleanWord[i];

      // Check if current character is a vowel and we have a decent syllable length
      if (vowels.contains(cleanWord[i]) && currentSyllable.length >= 2) {
        // Look ahead to see if we should break here
        if (i < cleanWord.length - 1) {
          String nextChar = cleanWord[i + 1];
          // Break if next character is a consonant (not a vowel)
          if (!vowels.contains(nextChar)) {
            syllables.add(currentSyllable);
            currentSyllable = '';
          }
        }
      }
    }

    // Add remaining characters to last syllable or create new one
    if (currentSyllable.isNotEmpty) {
      if (syllables.isNotEmpty && currentSyllable.length <= 2) {
        syllables.last += currentSyllable;
      } else {
        syllables.add(currentSyllable);
      }
    }

    // Ensure we don't return empty syllables
    syllables = syllables.where((s) => s.isNotEmpty).toList();
    return syllables.isEmpty ? [word] : syllables;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}