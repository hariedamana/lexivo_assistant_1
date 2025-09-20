import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// The main entry point for the application.
void main() {
  runApp(const AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Register named routes for navigation.
      routes: {
        '/': (context) => const ProfessionalAdminDashboard(),
        '/login': (context) => const LoginPage(),
      },
      initialRoute: '/', // The app starts on the dashboard.
      debugShowCheckedModeBanner: false,
    );
  }
}

// A simple placeholder for a login page.
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.admin_panel_settings_outlined,
                size: 80,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(height: 16),
              const Text(
                'Admin Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You have been signed out.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the dashboard (for demonstration).
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Login Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfessionalAdminDashboard extends StatefulWidget {
  const ProfessionalAdminDashboard({Key? key}) : super(key: key);

  @override
  State<ProfessionalAdminDashboard> createState() => _ProfessionalAdminDashboardState();
}

class _ProfessionalAdminDashboardState extends State<ProfessionalAdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Enhanced color scheme
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color accentColor = Color(0xFF6366F1);
  static const Color surfaceColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1F2937);
  static const Color subtextColor = Color(0xFF6B7280);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF0EA5E9);

  // Mock data
  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'John Smith',
      'email': 'john.smith@university.edu',
      'role': 'Student',
      'status': 'active',
      'department': 'Computer Science',
      'joinDate': '2024-01-15',
      'lastLogin': '2 hours ago'
    },
    {
      'id': 2,
      'name': 'Emma Johnson',
      'email': 'emma.j@university.edu',
      'role': 'Student',
      'status': 'active',
      'department': 'Mathematics',
      'joinDate': '2023-09-10',
      'lastLogin': '1 day ago'
    },
    {
      'id': 3,
      'name': 'Dr. Sarah Wilson',
      'email': 'sarah.wilson@university.edu',
      'role': 'Faculty',
      'status': 'active',
      'department': 'Physics',
      'joinDate': '2020-08-15',
      'lastLogin': '30 minutes ago'
    },
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'System Maintenance',
      'message': 'Scheduled maintenance tonight from 2 AM to 4 AM',
      'type': 'warning',
      'status': 'active',
      'recipients': 1247,
      'date': '2024-09-11',
      'priority': 'high'
    },
    {
      'id': 2,
      'title': 'New Feature Release',
      'message': 'Mobile app version 2.1 is now available',
      'type': 'info',
      'status': 'sent',
      'recipients': 1500,
      'date': '2024-09-10',
      'priority': 'medium'
    },
  ];

  final List<Map<String, dynamic>> _feedback = [
    {
      'id': 1,
      'user': 'Alex Thompson',
      'subject': 'App Performance Issue',
      'message': 'The app is running slowly on my device',
      'rating': 3,
      'status': 'open',
      'priority': 'medium',
      'date': '2024-09-10',
      'category': 'Bug Report'
    },
    {
      'id': 2,
      'user': 'Maria Garcia',
      'subject': 'Great New Features',
      'message': 'Love the new dashboard design!',
      'rating': 5,
      'status': 'closed',
      'priority': 'low',
      'date': '2024-09-09',
      'category': 'Compliment'
    },
  ];

  Map<String, dynamic> _interfaceSettings = {
    'theme': 'light',
    'primaryColor': '#2563EB',
    'accentColor': '#6366F1',
    'showWelcomeMessage': true,
    'enableDarkMode': true,
    'compactView': false,
    'animationsEnabled': true,
    'sidebarCollapsed': false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Action method to handle signing out.
  void _handleSignOut() {
    // Navigate to the login page and replace the current route.
    Navigator.pushReplacementNamed(context, '/login');
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
                colors: [primaryColor, primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Professional Management System',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          actions: [
            _buildHeaderAction(Icons.notifications_outlined, 3),
            const SizedBox(width: 8),
            _buildHeaderAction(Icons.message_outlined, 2),
            const SizedBox(width: 8),
            _buildLogoutAction(),
            const SizedBox(width: 8),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            isScrollable: true,
            tabs: const [
              Tab(icon: Icon(Icons.dashboard_outlined, size: 18), text: 'Overview'),
              Tab(icon: Icon(Icons.people_outline, size: 18), text: 'Users'),
              Tab(icon: Icon(Icons.campaign_outlined, size: 18), text: 'Notifications'),
              Tab(icon: Icon(Icons.feedback_outlined, size: 18), text: 'Feedback'),
              Tab(icon: Icon(Icons.palette_outlined, size: 18), text: 'Interface'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardOverview(),
          _buildUserManagement(),
          _buildNotificationManagement(),
          _buildFeedbackManagement(),
          _buildInterfaceManagement(),
        ],
      ),
    );
  }
  
  // New widget for the sign-out button
  Widget _buildLogoutAction() {
    return IconButton(
      icon: const Icon(Icons.logout_outlined, color: Colors.white),
      onPressed: _handleSignOut,
      tooltip: 'Sign out',
    );
  }

  Widget _buildHeaderAction(IconData icon, int badgeCount) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        if (badgeCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: errorColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  // Dashboard Overview Tab
  Widget _buildDashboardOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Monitor key metrics and system performance',
            style: TextStyle(
              fontSize: 14,
              color: subtextColor,
            ),
          ),
          const SizedBox(height: 24),
          // Responsive Stats Grid
          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              int crossAxisCount = width > 1000 ? 4 : width > 700 ? 3 : width > 500 ? 2 : 1;
              double childAspectRatio = width < 600 ? 2.0 : 1.3;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final stats = [
                    {'title': 'Total Users', 'value': '${_users.length}', 'change': '+12%', 'icon': Icons.people_outline, 'color': primaryColor},
                    {'title': 'Active Sessions', 'value': '847', 'change': '+8%', 'icon': Icons.trending_up_outlined, 'color': successColor},
                    {'title': 'Notifications', 'value': '${_notifications.length}', 'change': '+5%', 'icon': Icons.campaign_outlined, 'color': infoColor},
                    {'title': 'Feedback Items', 'value': '${_feedback.length}', 'change': '-2%', 'icon': Icons.feedback_outlined, 'color': warningColor},
                  ];
                  final stat = stats[index];
                  return _buildStatsCard(
                    stat['title'] as String,
                    stat['value'] as String,
                    stat['change'] as String,
                    stat['icon'] as IconData,
                    stat['color'] as Color,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
          _buildRecentActivity(),
          const SizedBox(height: 24),
          _buildQuickActions(),
        ],
      ),
    );
  }

  // User Management Tab
  Widget _buildUserManagement() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: cardColor,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'User Management',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage user accounts and permissions',
                          style: TextStyle(
                            fontSize: 14,
                            color: subtextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person_add_outlined, size: 16),
                    label: const Text('Add User'),
                    onPressed: _showAddUserDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    hintStyle: TextStyle(color: subtextColor),
                    prefixIcon: Icon(Icons.search, color: subtextColor, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildUserCard(_users[index]),
          ),
        ),
      ],
    );
  }

  // Notification Management Tab
  Widget _buildNotificationManagement() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: cardColor,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notification Management',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create and manage system notifications',
                      style: TextStyle(
                        fontSize: 14,
                        color: subtextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_outlined, size: 16),
                label: const Text('Create'),
                onPressed: _showCreateNotificationDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildNotificationCard(_notifications[index]),
          ),
        ),
      ],
    );
  }

  // Feedback Management Tab
  Widget _buildFeedbackManagement() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: cardColor,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Feedback Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Monitor and respond to user feedback',
                style: TextStyle(
                  fontSize: 14,
                  color: subtextColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _feedback.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildFeedbackCard(_feedback[index]),
          ),
        ),
      ],
    );
  }

  // Interface Management Tab
  Widget _buildInterfaceManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interface Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Customize the user interface and app layout',
            style: TextStyle(
              fontSize: 14,
              color: subtextColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildThemeSettings(),
          const SizedBox(height: 16),
          _buildLayoutSettings(),
          const SizedBox(height: 16),
          _buildColorSettings(),
          const SizedBox(height: 24),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveInterfaceSettings,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _resetInterfaceSettings,
                  icon: const Icon(Icons.restore_outlined),
                  label: const Text('Reset to Default'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: subtextColor,
                    side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildStatsCard(String title, String value, String change,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: change.startsWith('+')
                      ? successColor.withOpacity(0.1)
                      : errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: change.startsWith('+') ? successColor : errorColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: primaryColor,
                child: Text(
                  user['name'].toString().split(' ').map((n) => n[0]).join(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user['email'],
                      style: TextStyle(
                        fontSize: 11,
                        color: subtextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: user['status'] == 'active'
                      ? successColor.withOpacity(0.1)
                      : errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  user['status'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: user['status'] == 'active' ? successColor : errorColor,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: subtextColor, size: 16),
                onSelected: (value) => _handleUserAction(value, user),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'view', child: Text('View Details')),
                  const PopupMenuItem(value: 'edit', child: Text('Edit User')),
                  const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: errorColor))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user['role'],
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                  ),
                ),
              ),
              Text(
                user['department'],
                style: TextStyle(
                  fontSize: 10,
                  color: subtextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _getNotificationTypeColor(notification['type']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getNotificationTypeIcon(notification['type']),
                  color: _getNotificationTypeColor(notification['type']),
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  notification['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: notification['status'] == 'sent'
                      ? successColor.withOpacity(0.1)
                      : warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  notification['status'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: notification['status'] == 'sent' ? successColor : warningColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notification['message'],
            style: TextStyle(
              fontSize: 12,
              color: subtextColor,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.people_outline, size: 12, color: subtextColor),
              const SizedBox(width: 4),
              Text(
                '${notification['recipients']} recipients',
                style: TextStyle(fontSize: 10, color: subtextColor),
              ),
              const SizedBox(width: 12),
              Icon(Icons.schedule_outlined, size: 12, color: subtextColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  notification['date'],
                  style: TextStyle(fontSize: 10, color: subtextColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (notification['status'] != 'sent') ...[
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _sendNotification(notification),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('Send', style: TextStyle(fontSize: 10)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                      feedback['subject'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'From: ${feedback['user']}',
                      style: TextStyle(
                        fontSize: 11,
                        color: subtextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) => Icon(
                  index < feedback['rating'] ? Icons.star : Icons.star_border,
                  color: warningColor,
                  size: 12,
                )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feedback['message'],
            style: TextStyle(
              fontSize: 12,
              color: subtextColor,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getFeedbackStatusColor(feedback['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  feedback['status'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: _getFeedbackStatusColor(feedback['status']),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  feedback['category'],
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                  ),
                ),
              ),
              Text(
                feedback['date'],
                style: TextStyle(fontSize: 10, color: subtextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            Icons.person_add_outlined,
            'New user registered',
            'John Doe joined Computer Science',
            '2 hours ago',
            successColor,
          ),
          _buildActivityItem(
            Icons.campaign_outlined,
            'Notification sent',
            'System maintenance notice sent',
            '4 hours ago',
            infoColor,
          ),
          _buildActivityItem(
            Icons.feedback_outlined,
            'Feedback received',
            'User reported performance issue',
            '6 hours ago',
            warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String description,
      String time, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: subtextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: subtextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              if (width < 600) {
                // Mobile layout - 2x2 grid
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            'Add User',
                            Icons.person_add_outlined,
                            primaryColor,
                            () => _showAddUserDialog(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildQuickActionButton(
                            'Send Notification',
                            Icons.campaign_outlined,
                            infoColor,
                            () => _showCreateNotificationDialog(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            'System Backup',
                            Icons.backup_outlined,
                            successColor,
                            () => _performBackup(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildQuickActionButton(
                            'View Reports',
                            Icons.assessment_outlined,
                            accentColor,
                            () => _viewReports(),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Desktop layout - single row
                return Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        'Add User',
                        Icons.person_add_outlined,
                        primaryColor,
                        () => _showAddUserDialog(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickActionButton(
                        'Send Notification',
                        Icons.campaign_outlined,
                        infoColor,
                        () => _showCreateNotificationDialog(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickActionButton(
                        'System Backup',
                        Icons.backup_outlined,
                        successColor,
                        () => _performBackup(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickActionButton(
                        'View Reports',
                        Icons.assessment_outlined,
                        accentColor,
                        () => _viewReports(),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Theme Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            'Enable Dark Mode',
            _interfaceSettings['enableDarkMode'],
            (value) => setState(() => _interfaceSettings['enableDarkMode'] = value),
          ),
          _buildSettingItem(
            'Show Welcome Message',
            _interfaceSettings['showWelcomeMessage'],
            (value) => setState(() => _interfaceSettings['showWelcomeMessage'] = value),
          ),
          _buildSettingItem(
            'Enable Animations',
            _interfaceSettings['animationsEnabled'],
            (value) => setState(() => _interfaceSettings['animationsEnabled'] = value),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Layout Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            'Compact View',
            _interfaceSettings['compactView'],
            (value) => setState(() => _interfaceSettings['compactView'] = value),
          ),
          _buildSettingItem(
            'Sidebar Collapsed',
            _interfaceSettings['sidebarCollapsed'],
            (value) => setState(() => _interfaceSettings['sidebarCollapsed'] = value),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Color Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildColorPicker('Primary Color', _interfaceSettings['primaryColor']),
          _buildColorPicker('Accent Color', _interfaceSettings['accentColor']),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: textColor,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(String title, String colorHex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showColorPicker(title, colorHex),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Change Color', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for colors and icons
  Color _getNotificationTypeColor(String type) {
    switch (type) {
      case 'warning': return warningColor;
      case 'error': return errorColor;
      case 'success': return successColor;
      default: return infoColor;
    }
  }

  IconData _getNotificationTypeIcon(String type) {
    switch (type) {
      case 'warning': return Icons.warning_outlined;
      case 'error': return Icons.error_outline;
      case 'success': return Icons.check_circle_outline;
      default: return Icons.info_outline;
    }
  }

  Color _getFeedbackStatusColor(String status) {
    switch (status) {
      case 'open': return warningColor;
      case 'in-progress': return infoColor;
      case 'closed': return successColor;
      default: return subtextColor;
    }
  }

  // Action methods
  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: ['Student', 'Faculty', 'Admin'].map((role) =>
                    DropdownMenuItem(value: role, child: Text(role))
                ).toList(),
                onChanged: (value) {},
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User added successfully')),
              );
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  void _showCreateNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Notification'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: ['info', 'warning', 'error', 'success'].map((type) =>
                    DropdownMenuItem(value: type, child: Text(type.toUpperCase()))
                ).toList(),
                onChanged: (value) {},
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification created successfully')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(String title, String currentColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose $title'),
        content: SizedBox(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  '#2563EB', '#10B981', '#F59E0B', '#EF4444',
                  '#6366F1', '#0EA5E9', '#F97316', '#84CC16'
                ].map((colorHex) => _buildColorOption(colorHex)).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(String colorHex) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Color updated to $colorHex')),
        );
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
      ),
    );
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Viewing details for ${user['name']}')),
        );
        break;
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Editing ${user['name']}')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(user);
        break;
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${user['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _users.removeWhere((u) => u['id'] == user['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user['name']} deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _sendNotification(Map<String, dynamic> notification) {
    setState(() {
      notification['status'] = 'sent';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification sent successfully')),
    );
  }

  void _saveInterfaceSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Interface settings saved successfully')),
    );
  }

  void _resetInterfaceSettings() {
    setState(() {
      _interfaceSettings = {
        'theme': 'light',
        'primaryColor': '#2563EB',
        'accentColor': '#6366F1',
        'showWelcomeMessage': true,
        'enableDarkMode': true,
        'compactView': false,
        'animationsEnabled': true,
        'sidebarCollapsed': false,
      };
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings reset to default')),
    );
  }

  void _performBackup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('System backup initiated')),
    );
  }

  void _viewReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening reports dashboard')),
    );
  }
}