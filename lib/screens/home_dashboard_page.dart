part of '../main.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  static const _blue = Color(0xFF1BA7E1);
  int _selectedIndex = 0;
  AppUser? _currentUser;
  DashboardStats _dashboardStats = DashboardStats.empty();
  List<TruckEntry> _dashboardRecentEntries = const [];
  bool _isDashboardLoading = true;

  final List<TruckEntry> _recentEntries = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _DashboardHome(
              recentEntries: _dashboardRecentEntries,
              totalEntries: _dashboardStats.totalEntries,
              normalTemperature: _dashboardStats.normalTemperatureCount,
              highTemperature: _dashboardStats.highTemperatureCount,
              trucksInside: _dashboardStats.trucksInside,
              isLoading: _isDashboardLoading,
              user: _currentUser,
              onRefresh: _loadDashboardData,
              onNewEntry: () => setState(() => _selectedIndex = 1),
              onLogout: _logout,
            ),
            NewTruckEntryPage(
              existingEntries: _recentEntries,
              onLogout: _logout,
              user: _currentUser,
              onSubmit: _addTruckEntry,
            ),
            RecordsPage(
              entries: _recentEntries,
              onLogout: _logout,
              user: _currentUser,
            ),
            ProfilePage(onLogout: _logout, initialUser: _currentUser),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected:
            (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: _blue.withValues(alpha: 0.14),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: _blue),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded, color: _blue),
            label: 'New Entry',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded, color: _blue),
            label: 'Records',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: _blue),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await CurrentUserStore.load();
      if (!mounted) {
        return;
      }
      setState(() => _currentUser = user);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _currentUser = null);
    }
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isDashboardLoading = true);

    try {
      final results = await Future.wait<dynamic>([
        DashboardService().getStats(),
        DashboardService().getRecentEntries(limit: 5),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _dashboardStats = results[0] as DashboardStats;
        _dashboardRecentEntries = results[1] as List<TruckEntry>;
        _isDashboardLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _dashboardStats = DashboardStats.empty();
        _dashboardRecentEntries = const [];
        _isDashboardLoading = false;
      });
      _showAuthMessage(context, 'Unable to load dashboard data.');
    }
  }

  void _logout() {
    _performLogout();
  }

  Future<void> _performLogout() async {
    await CognitoAuthService().signOut();
    CurrentUserStore.clear();

    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  void _addTruckEntry(TruckEntry entry) {
    setState(() {
      _recentEntries.insert(0, entry);
    });
    _loadDashboardData();
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome({
    required this.recentEntries,
    required this.totalEntries,
    required this.normalTemperature,
    required this.highTemperature,
    required this.trucksInside,
    required this.isLoading,
    required this.user,
    required this.onRefresh,
    required this.onNewEntry,
    required this.onLogout,
  });

  final List<TruckEntry> recentEntries;
  final int totalEntries;
  final int normalTemperature;
  final int highTemperature;
  final int trucksInside;
  final bool isLoading;
  final AppUser? user;
  final Future<void> Function() onRefresh;
  final VoidCallback onNewEntry;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(onLogout: onLogout, user: user),
                  if (isLoading) ...[
                    const SizedBox(height: 14),
                    const LinearProgressIndicator(minHeight: 2),
                    const SizedBox(height: 6),
                  ] else
                    const SizedBox(height: 22),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.48,
                    children: [
                      SummaryCard(
                        title: 'Total Entries Today',
                        value: '$totalEntries',
                        icon: Icons.local_shipping_outlined,
                        accentColor: const Color(0xFF1BA7E1),
                      ),
                      SummaryCard(
                        title: 'Normal Temperature',
                        value: '$normalTemperature',
                        icon: Icons.thermostat_outlined,
                        accentColor: const Color(0xFF17A56B),
                      ),
                      SummaryCard(
                        title: 'High Temperature',
                        value: '$highTemperature',
                        icon: Icons.warning_amber_rounded,
                        accentColor: const Color(0xFFE5484D),
                      ),
                      SummaryCard(
                        title: 'Trucks Inside',
                        value: '$trucksInside',
                        icon: Icons.warehouse_outlined,
                        accentColor: const Color(0xFF111827),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton.icon(
                      onPressed: onNewEntry,
                      icon: const Icon(Icons.add_rounded, size: 26),
                      label: const Text('New Entry'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF111827),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Recent Entries',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.separated(
              itemCount: recentEntries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder:
                  (context, index) =>
                      RecentEntryTile(entry: recentEntries[index]),
            ),
          ),
        ],
      ),
    );
  }
}
