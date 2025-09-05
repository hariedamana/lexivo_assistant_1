import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Enhanced color scheme
  static const Color primaryTeal = Color(0xFF00D4AA);
  static const Color darkBackground = Color(0xFF0A0E27);
  static const Color cardColor = Color(0xFF1A2235);
  static const Color accentColor = Color(0xFF4FC3F7);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color warningColor = Color(0xFFFF6B6B);
  static const Color successColor = Color(0xFF4ECDC4);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        setState(() => _selectedIndex = 0);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/userManagement');
        break;
      case 2:
        setState(() => _selectedIndex = 2);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      case 4:
        _showSignOutDialog();
        break;
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out', style: TextStyle(color: textPrimary)),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: accentColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: warningColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _DashboardPage(
              searchController: _searchController,
              onSearchChanged: (query) => setState(() => _searchQuery = query),
              signOutCallback: _signOut,
            ),
            // Placeholder for User Management screen
            const Center(child: CircularProgressIndicator(color: primaryTeal)),
            _ContentPage(tabController: _tabController),
            // Placeholder for Settings screen
            const Center(child: CircularProgressIndicator(color: primaryTeal)),
            // Placeholder for Sign Out screen (not used, handled by dialog)
            const SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1C1F2B).withOpacity(0.9),
            const Color(0xFF2A2D3A).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 30,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          selectedItemColor: primaryTeal,
          unselectedItemColor: const Color(0xFF6B7280),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedLabelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded, size: 24),
              activeIcon: Icon(Icons.dashboard_rounded, size: 28),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded, size: 24),
              activeIcon: Icon(Icons.people_rounded, size: 28),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded, size: 24),
              activeIcon: Icon(Icons.notifications_rounded, size: 28),
              label: 'Content',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded, size: 24),
              activeIcon: Icon(Icons.settings_rounded, size: 28),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout_rounded, size: 24),
              activeIcon: Icon(Icons.logout_rounded, size: 28),
              label: 'Sign Out',
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- Enhanced Dashboard Page --------------------
class _DashboardPage extends StatefulWidget {
  const _DashboardPage({
    required this.searchController,
    required this.onSearchChanged,
    required this.signOutCallback,
    super.key,
  });

  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback signOutCallback;

  @override
  State<_DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<_DashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Map<String, dynamic> _dashboardData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadDashboardData();
    _animationController.forward();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      final notificationsSnapshot = await FirebaseFirestore.instance.collection('notifications').get();

      // Get today's active users (simulated with recent signups)
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final activeUsersToday = usersSnapshot.docs.where((doc) {
        final data = doc.data();
        if (data['lastActiveAt'] != null) {
          final lastActive = (data['lastActiveAt'] as Timestamp).toDate();
          return lastActive.isAfter(startOfDay);
        }
        return false;
      }).length;
      // Get new signups this week
      final weekAgo = today.subtract(const Duration(days: 7));
      final newSignups = usersSnapshot.docs.where((doc) {
        final data = doc.data();
        if (data['createdAt'] != null) {
          final createdAt = (data['createdAt'] as Timestamp).toDate();
          return createdAt.isAfter(weekAgo);
        }
        return false;
      }).length;

      setState(() {
        _dashboardData = {
          'totalUsers': usersSnapshot.docs.length,
          'activeToday': activeUsersToday,
          'newSignups': newSignups,
          'totalNotifications': notificationsSnapshot.docs.length,
        };
        _isLoading = false;
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied' || e.code == 'unauthenticated') {
        _showSessionExpiredDialog();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Firebase error: ${e.message}'),
              backgroundColor: _AdminDashboardScreenState.warningColor,
            ),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to mock data for any other unexpected errors.
      setState(() {
        _dashboardData = {
          'totalUsers': 1200,
          'activeToday': 450,
          'newSignups': 25,
          'totalNotifications': 12,
        };
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: _AdminDashboardScreenState.warningColor,
          ),
        );
      }
    }
  }

  void _showSessionExpiredDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session Expired', style: TextStyle(color: _AdminDashboardScreenState.textPrimary)),
        content: const Text(
          'Your session has expired. Please log in again.',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: _AdminDashboardScreenState.cardColor,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.signOutCallback();
            },
            child: const Text('OK', style: TextStyle(color: _AdminDashboardScreenState.accentColor)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      color: _AdminDashboardScreenState.primaryTeal,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedHeader(),
              const SizedBox(height: 32),
              _buildQuickStats(),
              const SizedBox(height: 32),
              _buildAnalyticsSection(),
              const SizedBox(height: 32),
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Admin',
                    style: TextStyle(
                      color: _AdminDashboardScreenState.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _AdminDashboardScreenState.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _AdminDashboardScreenState.primaryTeal.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.admin_panel_settings_rounded,
                color: _AdminDashboardScreenState.primaryTeal,
                size: 28,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: _AdminDashboardScreenState.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _AdminDashboardScreenState.accentColor.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _AdminDashboardScreenState.primaryTeal.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: widget.searchController,
            onChanged: widget.onSearchChanged,
            style: const TextStyle(color: _AdminDashboardScreenState.textPrimary),
            decoration: InputDecoration(
              icon: Icon(
                Icons.search_rounded,
                color: _AdminDashboardScreenState.accentColor,
                size: 24,
              ),
              hintText: 'Search dashboard, users, notifications...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'Total Students',
                value: _dashboardData['totalUsers'].toString(),
                change: '+12%',
                isPositive: true,
                icon: Icons.school_rounded,
                gradientColors: const [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _MetricCard(
                title: 'Active Today',
                value: _dashboardData['activeToday'].toString(),
                change: '+5%',
                isPositive: true,
                icon: Icons.person_rounded,
                gradientColors: const [Color(0xFFf093fb), Color(0xFFf5576c)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'New Signups',
                value: _dashboardData['newSignups'].toString(),
                change: '+25%',
                isPositive: true,
                icon: Icons.person_add_rounded,
                gradientColors: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _MetricCard(
                title: 'Notifications',
                value: _dashboardData['totalNotifications'].toString(),
                change: '+8%',
                isPositive: true,
                icon: Icons.notifications_rounded,
                gradientColors: const [Color(0xFF43e97b), Color(0xFF38f9d7)],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _AdminDashboardScreenState.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _AdminDashboardScreenState.accentColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: _AdminDashboardScreenState.primaryTeal,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'User Engagement Analytics',
                style: TextStyle(
                  color: _AdminDashboardScreenState.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 280,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 6,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        );
                        const months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec'
                        ];
                        final index = value.toInt();
                        return index < months.length
                            ? Text(months[index], style: style)
                            : const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        );
                        return Text('${(value * 100).toInt()}', style: style);
                      },
                    ),
                  ),
                  topTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.05),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 2.5),
                      FlSpot(2, 4),
                      FlSpot(3, 3.1),
                      FlSpot(4, 5),
                      FlSpot(5, 4.2),
                      FlSpot(6, 3.8),
                      FlSpot(7, 5.1),
                      FlSpot(8, 4.5),
                      FlSpot(9, 3.2),
                      FlSpot(10, 4.8),
                      FlSpot(11, 4.2),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [_AdminDashboardScreenState.primaryTeal, _AdminDashboardScreenState.accentColor],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: _AdminDashboardScreenState.primaryTeal,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          _AdminDashboardScreenState.primaryTeal.withOpacity(0.3),
                          _AdminDashboardScreenState.primaryTeal.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
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

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _AdminDashboardScreenState.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _AdminDashboardScreenState.accentColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history_rounded,
                color: _AdminDashboardScreenState.primaryTeal,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Recent Activity',
                style: TextStyle(
                  color: _AdminDashboardScreenState.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => Divider(
              color: Colors.white.withOpacity(0.1),
              height: 24,
            ),
            itemBuilder: (context, index) {
              final activities = [
                {'title': 'New user registered', 'time': '2 minutes ago', 'icon': Icons.person_add},
                {'title': 'Notification sent', 'time': '15 minutes ago', 'icon': Icons.notifications},
                {'title': 'User data updated', 'time': '1 hour ago', 'icon': Icons.edit},
                {'title': 'System backup completed', 'time': '3 hours ago', 'icon': Icons.backup},
                {'title': 'New admin logged in', 'time': '5 hours ago', 'icon': Icons.login},
              ];

              final activity = activities[index];
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _AdminDashboardScreenState.primaryTeal.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      activity['icon'] as IconData,
                      color: _AdminDashboardScreenState.primaryTeal,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'] as String,
                          style: const TextStyle(
                            color: _AdminDashboardScreenState.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          activity['time'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// -------------------- Enhanced Metric Card --------------------
class _MetricCard extends StatefulWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.gradientColors,
    super.key,
  });

  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final List<Color> gradientColors;

  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.first.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    widget.isPositive ? Icons.trending_up : Icons.trending_down,
                    color: Colors.white.withOpacity(0.8),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.change,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- Enhanced Content Page --------------------
class _ContentPage extends StatefulWidget {
  const _ContentPage({required this.tabController, super.key});
  final TabController tabController;
  @override
  State<_ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<_ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AdminDashboardScreenState.darkBackground,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notifications_rounded,
                      color: _AdminDashboardScreenState.primaryTeal,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Notification Management',
                      style: TextStyle(
                        color: _AdminDashboardScreenState.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TabBar(
                  controller: widget.tabController,
                  labelColor: _AdminDashboardScreenState.primaryTeal,
                  unselectedLabelColor: Colors.white54,
                  indicatorColor: _AdminDashboardScreenState.primaryTeal,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'All Notifications'),
                    Tab(text: 'Scheduled'),
                    Tab(text: 'Analytics'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: widget.tabController,
              children: const [
                Center(
                  child: Text(
                    'All Notifications Tab Content',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Center(
                  child: Text(
                    'Scheduled Notifications Tab Content',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Center(
                  child: Text(
                    'Analytics Tab Content',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}