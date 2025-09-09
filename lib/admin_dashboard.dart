import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  // Professional color scheme
  static const Color primaryColor = Color(0xFF1A237E);
  static const Color secondaryColor = Color(0xFF3F51B5);
  static const Color accentColor = Color(0xFF536DFE);
  static const Color surfaceColor = Color(0xFFFAFAFA);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color successColor = Color(0xFF2E7D32);
  static const Color warningColor = Color(0xFFEF6C00);
  static const Color errorColor = Color(0xFFC62828);

  // Mock data for students
  final List<Map<String, dynamic>> _users = [
    {
      'name': 'Alex Johnson',
      'email': 'alex.j@university.edu',
    },
    {
      'name': 'Maria Garcia',
      'email': 'maria.g@university.edu',
    },
    {
      'name': 'Liam Chen',
      'email': 'liam.c@university.edu',
    },
    {
      'name': 'Sophia Rodriguez',
      'email': 'sophia.r@university.edu',
    },
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'Course Registration Deadline',
      'message': 'The deadline for Fall semester course registration is this Friday. Please complete your registration to avoid late fees.',
      'status': 'scheduled',
      'priority': 'high',
      'recipients': 'All Students',
      'recipientCount': 1247,
      'date': '2025-09-15',
      'createdBy': 'Registrar\'s Office',
      'type': 'maintenance'
    },
    {
      'id': 2,
      'title': 'New Library Resources Available',
      'message': 'We have added new digital resources and journals to the university library. Access them via the library portal.',
      'status': 'sent',
      'priority': 'medium',
      'recipients': 'Graduate Students',
      'recipientCount': 342,
      'date': '2025-09-08',
      'createdBy': 'Library Admin',
      'type': 'feature'
    },
    {
      'id': 3,
      'title': 'System Update for Campus Portal',
      'message': 'An important security update for the campus portal is now available. Please log in again to apply the changes.',
      'status': 'sent',
      'priority': 'high',
      'recipients': 'All Students',
      'recipientCount': 1247,
      'date': '2025-09-05',
      'createdBy': 'IT Services',
      'type': 'security'
    },
  ];

  final List<Map<String, dynamic>> _feedbacks = [
    {
      'id': 1,
      'user': 'Alexandra Smith',
      'email': 'alexandra.smith@email.com',
      'subject': 'Request for a new feature in the student portal',
      'message': 'The student portal is great, but could we get a feature to track our GPA in real-time? This would help us monitor our academic progress more effectively.',
      'category': 'Feature Request',
      'status': 'unread',
      'priority': 'medium',
      'date': '2025-09-08',
      'rating': 5,
      'department': 'Computer Science',
      'tags': ['portal', 'feature', 'gpa']
    },
    {
      'id': 2,
      'user': 'David Wilson',
      'email': 'david.wilson@email.com',
      'subject': 'Bug report: App crashing on Android',
      'message': 'The university mobile app is consistently crashing when I try to open the class schedule on my Android device. It is a critical issue that is affecting my daily routine.',
      'category': 'Bug Report',
      'status': 'in-progress',
      'priority': 'high',
      'date': '2025-09-07',
      'rating': 2,
      'department': 'Engineering',
      'tags': ['mobile', 'android', 'bug']
    },
    {
      'id': 3,
      'user': 'Jennifer Brown',
      'email': 'jennifer.brown@email.com',
      'subject': 'Need more study resources for the business department',
      'message': 'We would benefit greatly from more digital resources and case studies for the Business department. This would help us prepare for our exams more effectively.',
      'category': 'Feature Request',
      'status': 'resolved',
      'priority': 'low',
      'date': '2025-09-06',
      'rating': 4,
      'department': 'Business',
      'tags': ['resources', 'library', 'study']
    },
  ];

  Map<String, bool> _systemSettings = {
    'Email Notifications': true,
    'Push Notifications': true,
    'Student Registration': true,
    'Two-Factor Authentication': true,
    'API Access': true,
    'Data Export': true,
    'Audit Logging': true,
    'Automatic Backups': true,
  };

  Map<String, bool> _featureFlags = {
    'Advanced Analytics': true,
    'Real-time Chat': false,
    'Beta Features': false,
    'Third-party Integrations': true,
    'Mobile App Sync': true,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, secondaryColor],
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'University Management Console',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  _buildHeaderAction(Icons.notifications_outlined, 3),
                  const SizedBox(width: 12),
                  _buildHeaderAction(Icons.settings_outlined, 0),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Text(
                      'AD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(icon: Icon(Icons.dashboard_outlined, size: 20), text: 'Overview'),
                  Tab(icon: Icon(Icons.people_outline, size: 20), text: 'Users'),
                  Tab(icon: Icon(Icons.campaign_outlined, size: 20), text: 'Notifications'),
                  Tab(icon: Icon(Icons.feedback_outlined, size: 20), text: 'Feedback'),
                  Tab(icon: Icon(Icons.tune_outlined, size: 20), text: 'Settings'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildUsersTab(),
          _buildNotificationsTab(),
          _buildFeedbackTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, int badgeCount) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        if (badgeCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: errorColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildMetricCard(
                'Total Students',
                _users.length.toString(),
                '+12.5%',
                Icons.people_outline,
                successColor,
                'vs last semester',
              ),
              _buildMetricCard(
                'Active Sessions',
                'N/A', // Removed since status data is not available
                '+8.3%',
                Icons.trending_up_outlined,
                successColor,
                'vs last semester',
              ),
              _buildMetricCard(
                'Pending Issues',
                _feedbacks.where((f) => f['status'] == 'unread').length.toString(),
                '-15.2%',
                Icons.error_outline,
                errorColor,
                'vs last semester',
              ),
              _buildMetricCard(
                'System Health',
                '99.9%',
                '+0.1%',
                Icons.health_and_safety_outlined,
                successColor,
                'uptime',
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Charts and Analytics Section
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              SizedBox(
                width: 500, // Fixed width for a wider card
                child: _buildAnalyticsCard(),
              ),
              SizedBox(
                width: 300, // Fixed width for a narrower card
                child: _buildQuickActionsCard(),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent Activity
          _buildRecentActivityCard(),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return Column(
      children: [
        // Header with search and actions
        Container(
          padding: const EdgeInsets.all(24),
          color: cardColor,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search students by name or email...',
                          hintStyle: TextStyle(color: textSecondaryColor),
                          prefixIcon: Icon(Icons.search, color: textSecondaryColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    'Add Student',
                    Icons.person_add_outlined,
                    primaryColor,
                    () => _showAddUserDialog(),
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    'Export',
                    Icons.download_outlined,
                    textSecondaryColor,
                    () => _exportUsers(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All Students', true, _users.length),
                    const SizedBox(width: 8),
                    _buildFilterChip('Active', false, _users.length), // Placeholder as status is not in mock data
                  ],
                ),
              ),
            ],
          ),
        ),

        // Users List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: _users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final user = _users[index];
              return _buildUserCard(user);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsTab() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(24),
          color: cardColor,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notification Center',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage and send notifications to your students',
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButton(
                'Create Notification',
                Icons.add_outlined,
                primaryColor,
                () => _showCreateNotificationDialog(),
              ),
            ],
          ),
        ),

        // Notifications List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: _notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              return _buildNotificationCard(notification);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackTab() {
    return Column(
      children: [
        // Header with filters
        Container(
          padding: const EdgeInsets.all(24),
          color: cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Feedback',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Monitor and respond to student feedback',
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildActionButton(
                    'Export Feedback',
                    Icons.download_outlined,
                    textSecondaryColor,
                    () => _exportFeedback(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Filter options
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All Feedback', true, _feedbacks.length),
                    const SizedBox(width: 8),
                    _buildFilterChip('Unread', false,
                        _feedbacks.where((f) => f['status'] == 'unread').length),
                    const SizedBox(width: 8),
                    _buildFilterChip('High Priority', false,
                        _feedbacks.where((f) => f['priority'] == 'high').length),
                    const SizedBox(width: 8),
                    _buildFilterChip('Bug Reports', false,
                        _feedbacks.where((f) => f['category'] == 'Bug Report').length),
                    const SizedBox(width: 8),
                    _buildFilterChip('Feature Requests', false,
                        _feedbacks.where((f) => f['category'] == 'Feature Request').length),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Feedback List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: _feedbacks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final feedback = _feedbacks[index];
              return _buildFeedbackCard(feedback);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Configuration',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage system settings and feature configurations',
            style: TextStyle(
              fontSize: 14,
              color: textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),

          // System Settings
          _buildSettingsSection(
            'System Settings',
            'Core system functionality and security settings',
            _systemSettings,
          ),
          const SizedBox(height: 32),

          // Feature Flags
          _buildSettingsSection(
            'Feature Flags',
            'Enable or disable experimental and beta features',
            _featureFlags,
          ),
          const SizedBox(height: 32),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _saveSettings(),
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _resetSettings(),
                icon: const Icon(Icons.restore_outlined),
                label: const Text('Reset to Defaults'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: textSecondaryColor,
                  side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String change,
      IconData icon, Color changeColor, String subtitle) {
    return Container(
      width: 180, // Added fixed width to avoid overflow in Wrap
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primaryColor, size: 24),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: changeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textSecondaryColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: textSecondaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Student Activity Trends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textPrimaryColor,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz, color: textSecondaryColor),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'week', child: Text('This Week')),
                  const PopupMenuItem(value: 'month', child: Text('This Month')),
                  const PopupMenuItem(value: 'quarter', child: Text('This Quarter')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  accentColor.withOpacity(0.1),
                  accentColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 48,
                    color: accentColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Analytics Chart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Real-time data visualization',
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondaryColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildQuickAction(
            'Send Notification',
            'Broadcast message to students',
            Icons.campaign_outlined,
            accentColor,
            () => _showCreateNotificationDialog(),
          ),
          const SizedBox(height: 16),
          _buildQuickAction(
            'Add New Student',
            'Create student account',
            Icons.person_add_outlined,
            successColor,
            () => _showAddUserDialog(),
          ),
          const SizedBox(height: 16),
          _buildQuickAction(
            'System Backup',
            'Create system backup',
            Icons.backup_outlined,
            warningColor,
            () => _performBackup(),
          ),
          const SizedBox(height: 16),
          _buildQuickAction(
            'Generate Report',
            'Export analytics report',
            Icons.assessment_outlined,
            primaryColor,
            () => _generateReport(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, String subtitle, IconData icon,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: textSecondaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    final activities = [
      {
        'title': 'New student registration',
        'subtitle': 'Maria Garcia joined Business department',
        'time': '2 minutes ago',
        'icon': Icons.person_add_outlined,
        'color': successColor,
      },
      {
        'title': 'System notification sent',
        'subtitle': 'Course registration notice sent to 1,247 students',
        'time': '15 minutes ago',
        'icon': Icons.campaign_outlined,
        'color': accentColor,
      },
      {
        'title': 'High priority feedback received',
        'subtitle': 'Bug reported by David Wilson on mobile app',
        'time': '1 hour ago',
        'icon': Icons.priority_high_outlined,
        'color': errorColor,
      },
      {
        'title': 'Security update completed',
        'subtitle': 'System security patches applied successfully',
        'time': '3 hours ago',
        'icon': Icons.security_outlined,
        'color': successColor,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textPrimaryColor,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...activities.map((activity) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (activity['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        activity['icon'] as IconData,
                        color: activity['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activity['subtitle'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      activity['time'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: textSecondaryColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color == textSecondaryColor ? Colors.white : color,
        foregroundColor:
            color == textSecondaryColor ? textSecondaryColor : Colors.white,
        side: color == textSecondaryColor
            ? BorderSide(color: Colors.grey.withOpacity(0.3))
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: color == textSecondaryColor ? 0 : 2,
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? accentColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? accentColor : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : textSecondaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : textSecondaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    user['name'].toString().split(' ').map((n) => n[0]).join(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user['email'],
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: textSecondaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (value) => _handleUserAction(value, user),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_outlined, size: 18),
                        SizedBox(width: 12),
                        Text('View Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 12),
                        Text('Edit Student'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Delete Student', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getNotificationTypeColor(notification['type']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getNotificationTypeIcon(notification['type']),
                  color: _getNotificationTypeColor(notification['type']),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Created by ${notification['createdBy']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: notification['status'] == 'sent'
                      ? successColor.withOpacity(0.1)
                      : warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  notification['status'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: notification['status'] == 'sent' ? successColor : warningColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            notification['message'],
            style: TextStyle(
              fontSize: 14,
              color: textSecondaryColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildNotificationMetric(
                Icons.people_outline,
                '${notification['recipientCount']} Recipients',
              ),
              const SizedBox(width: 24),
              _buildNotificationMetric(
                Icons.schedule_outlined,
                notification['date'],
              ),
              const Spacer(),
              if (notification['priority'] == 'high')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'HIGH PRIORITY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: errorColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationMetric(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textSecondaryColor),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: feedback['status'] == 'unread'
            ? Border.all(color: accentColor.withOpacity(0.3), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    feedback['user'].toString().split(' ').map((n) => n[0]).join(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback['user'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      feedback['email'],
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _getPriorityColor(feedback['priority']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${feedback['priority'].toString().toUpperCase()} PRIORITY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _getPriorityColor(feedback['priority']),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            feedback['subject'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feedback['message'],
            style: TextStyle(
              fontSize: 14,
              color: textSecondaryColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFeedbackChip(feedback['category'], accentColor),
              _buildFeedbackChip(feedback['department'], primaryColor),
              ...((feedback['tags'] as List<String>?) ?? [])
                  .map((tag) => _buildFeedbackChip('#$tag', textSecondaryColor)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (feedback['rating'] as int)
                        ? Icons.star
                        : Icons.star_border,
                    size: 16,
                    color: warningColor,
                  );
                }),
              ),
              const SizedBox(width: 12),
              Text(
                feedback['date'],
                style: TextStyle(
                  fontSize: 12,
                  color: textSecondaryColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(feedback['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  feedback['status'].toString().replaceAll('-', ' ').toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(feedback['status']),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: textSecondaryColor, size: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (value) => _handleFeedbackAction(value, feedback),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'reply',
                    child: Row(
                      children: [
                        Icon(Icons.reply_outlined, size: 18),
                        SizedBox(width: 12),
                        Text('Reply to Student'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'mark_read',
                    child: Row(
                      children: [
                        Icon(Icons.mark_email_read_outlined, size: 18),
                        SizedBox(width: 12),
                        Text('Mark as Read'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'in_progress',
                    child: Row(
                      children: [
                        Icon(Icons.work_outline, size: 18),
                        SizedBox(width: 12),
                        Text('Mark In Progress'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'resolve',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 18),
                        SizedBox(width: 12),
                        Text('Mark Resolved'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
      String title, String subtitle, Map<String, bool> settings) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          ...settings.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Icon(
                    _getSettingIcon(entry.key),
                    color: accentColor,
                    size: 22,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textPrimaryColor,
                      ),
                    ),
                  ),
                  Switch.adaptive(
                    value: entry.value,
                    onChanged: (value) {
                      setState(() {
                        settings[entry.key] = value;
                      });
                    },
                    activeColor: accentColor,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // Helper methods for colors and icons
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return errorColor;
      case 'medium':
        return warningColor;
      case 'low':
        return successColor;
      default:
        return textSecondaryColor;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'unread':
        return errorColor;
      case 'in-progress':
        return warningColor;
      case 'resolved':
        return successColor;
      default:
        return textSecondaryColor;
    }
  }

  Color _getNotificationTypeColor(String type) {
    switch (type) {
      case 'maintenance':
        return warningColor;
      case 'feature':
        return accentColor;
      case 'security':
        return errorColor;
      default:
        return primaryColor;
    }
  }

  IconData _getNotificationTypeIcon(String type) {
    switch (type) {
      case 'maintenance':
        return Icons.build_outlined;
      case 'feature':
        return Icons.new_releases_outlined;
      case 'security':
        return Icons.security_outlined;
      default:
        return Icons.info_outlined;
    }
  }

  IconData _getSettingIcon(String setting) {
    switch (setting) {
      case 'Email Notifications':
        return Icons.mail_outline;
      case 'Push Notifications':
        return Icons.notifications_outlined;
      case 'Student Registration':
        return Icons.person_add_outlined;
      case 'Two-Factor Authentication':
        return Icons.security_outlined;
      case 'API Access':
        return Icons.api_outlined;
      case 'Data Export':
        return Icons.download_outlined;
      case 'Audit Logging':
        return Icons.history_outlined;
      case 'Automatic Backups':
        return Icons.backup_outlined;
      case 'Advanced Analytics':
        return Icons.analytics_outlined;
      case 'Real-time Chat':
        return Icons.chat_outlined;
      case 'Beta Features':
        return Icons.science_outlined;
      case 'Third-party Integrations':
        return Icons.extension_outlined;
      case 'Mobile App Sync':
        return Icons.sync_outlined;
      default:
        return Icons.settings_outlined;
    }
  }

  // Action handlers
  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add New Student'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                setState(() {
                  _users.add({
                    'name': nameController.text,
                    'email': emailController.text,
                  });
                });
                Navigator.pop(context);
                _showSuccessSnackBar('Student added successfully');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Student'),
          ),
        ],
      ),
    );
  }

  void _showCreateNotificationDialog() {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    String selectedPriority = 'medium';
    String selectedType = 'feature';
    String selectedRecipients = 'All Students';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Create Notification'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Notification Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Message Content',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      items: ['low', 'medium', 'high']
                          .map((priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(priority.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) => selectedPriority = value!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items: ['feature', 'maintenance', 'security', 'general']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) => selectedType = value!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRecipients,
                decoration: const InputDecoration(
                  labelText: 'Recipients',
                  border: OutlineInputBorder(),
                ),
                items: ['All Students', 'Active Students', 'Undergraduate Students', 'Graduate Students']
                    .map((recipient) => DropdownMenuItem(
                          value: recipient,
                          child: Text(recipient),
                        ))
                    .toList(),
                onChanged: (value) => selectedRecipients = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && messageController.text.isNotEmpty) {
                setState(() {
                  _notifications.insert(0, {
                    'id': _notifications.length + 1,
                    'title': titleController.text,
                    'message': messageController.text,
                    'status': 'sent',
                    'priority': selectedPriority,
                    'recipients': selectedRecipients,
                    'recipientCount': selectedRecipients == 'All Students' ? 1247 : 342,
                    'date': DateTime.now().toString().split(' ')[0],
                    'createdBy': 'Admin',
                    'type': selectedType,
                  });
                });
                Navigator.pop(context);
                _showSuccessSnackBar('Notification sent successfully');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Notification'),
          ),
        ],
      ),
    );
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    switch (action) {
      case 'view':
        _showUserDetailsDialog(user);
        break;
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(
          'Delete Student',
          'Are you sure you want to delete ${user['name']}? This action cannot be undone.',
          () {
            setState(() {
              _users.removeWhere((u) => u['name'] == user['name']);
            });
            _showSuccessSnackBar('Student deleted successfully');
          },
        );
        break;
    }
  }

  void _handleFeedbackAction(String action, Map<String, dynamic> feedback) {
    switch (action) {
      case 'reply':
        _showReplyDialog(feedback);
        break;
      case 'mark_read':
        _updateFeedbackStatus(feedback, 'read');
        break;
      case 'in_progress':
        _updateFeedbackStatus(feedback, 'in-progress');
        break;
      case 'resolve':
        _updateFeedbackStatus(feedback, 'resolved');
        break;
      case 'delete':
        _showDeleteConfirmationDialog(
          'Delete Feedback',
          'Are you sure you want to delete this feedback? This action cannot be undone.',
          () {
            setState(() {
              _feedbacks.removeWhere((f) => f['id'] == feedback['id']);
            });
            _showSuccessSnackBar('Feedback deleted successfully');
          },
        );
        break;
    }
  }

  void _updateFeedbackStatus(Map<String, dynamic> feedback, String newStatus) {
    setState(() {
      final index = _feedbacks.indexWhere((f) => f['id'] == feedback['id']);
      if (index != -1) {
        _feedbacks[index]['status'] = newStatus;
      }
    });
    _showSuccessSnackBar('Feedback status updated');
  }

  void _showUserDetailsDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Student Details: ${user['name']}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Email', user['email']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    final nameController = TextEditingController(text: user['name']);
    final emailController = TextEditingController(text: user['email']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Student: ${user['name']}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = _users.indexWhere((u) => u['name'] == user['name']);
                if (index != -1) {
                  _users[index] = {
                    ..._users[index],
                    'name': nameController.text,
                    'email': emailController.text,
                  };
                }
              });
              Navigator.pop(context);
              _showSuccessSnackBar('Student updated successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Update Student'),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(Map<String, dynamic> feedback) {
    final replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Reply to ${feedback['user']}'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Original Feedback:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      feedback['message'],
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: replyController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Your Reply',
                  border: OutlineInputBorder(),
                  hintText: 'Type your response here...',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _updateFeedbackStatus(feedback, 'resolved');
                _showSuccessSnackBar('Reply sent to ${feedback['user']}');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Reply'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Additional action methods
  void _exportUsers() {
    _showSuccessSnackBar('Student data exported successfully');
  }

  void _exportFeedback() {
    _showSuccessSnackBar('Feedback data exported successfully');
  }

  void _saveSettings() {
    _showSuccessSnackBar('Settings saved successfully');
  }

  void _resetSettings() {
    setState(() {
      _systemSettings = _systemSettings.map((key, value) => MapEntry(key, true));
      _featureFlags = _featureFlags.map((key, value) => MapEntry(key, false));
    });
    _showSuccessSnackBar('Settings reset to defaults');
  }

  void _performBackup() {
    _showSuccessSnackBar('System backup initiated');
  }

  void _generateReport() {
    _showSuccessSnackBar('Analytics report generated');
  }
}