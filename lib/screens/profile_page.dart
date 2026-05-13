part of '../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.onLogout, this.initialUser, super.key});

  final VoidCallback onLogout;
  final AppUser? initialUser;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppUser? _user;
  bool _isLoading = true;
  bool _hasError = false;

  AppUser? get _displayUser => _user ?? widget.initialUser;

  @override
  void initState() {
    super.initState();
    _user = widget.initialUser;
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await UserService().getCurrentUser();
      if (!mounted) {
        return;
      }
      CurrentUserStore.setUser(user);
      setState(() {
        _user = user;
        _isLoading = false;
        _hasError = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      _showAuthMessage(
        context,
        'Unable to load profile. Showing fallback data.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _displayUser;
    final displayName =
        user?.name.isNotEmpty == true ? user!.name : 'Supervisor';
    final initials = user?.initials ?? 'U';
    final email =
        user?.email.isNotEmpty == true
            ? user!.email
            : 'supervisor@hindalco.com';
    final role = user?.displayRole ?? 'Supervisor';
    final siteName =
        user?.siteName?.trim().isNotEmpty == true
            ? user!.siteName!
            : 'Hindalco';

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              children: [
                DashboardHeader(onLogout: widget.onLogout, user: user),
                const SizedBox(height: 26),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE7EAF0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 82,
                        width: 82,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAF6FC),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Color(0xFF1BA7E1),
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Color(0xFF7D8491),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_isLoading) ...[
                        const SizedBox(height: 12),
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                      if (_hasError) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Profile data unavailable',
                          style: TextStyle(
                            color: Color(0xFFE5484D),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: ProfileInfoPill(label: 'Role', value: role),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ProfileInfoPill(
                              label: 'Plant Name',
                              value: siteName,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE7EAF0)),
                  ),
                  child: Column(
                    children: [
                      ProfileOptionTile(
                        icon: Icons.lock_reset_rounded,
                        title: 'Change Password',
                        onTap:
                            () => _showAuthMessage(
                              context,
                              'Change password will be available soon.',
                            ),
                      ),
                      const ProfileOptionDivider(),
                      ProfileOptionTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notification Settings',
                        onTap:
                            () => _showAuthMessage(
                              context,
                              'Notification settings will be available soon.',
                            ),
                      ),
                      const ProfileOptionDivider(),
                      ProfileOptionTile(
                        icon: Icons.info_outline_rounded,
                        title: 'About App',
                        onTap:
                            () => _showAuthMessage(
                              context,
                              'Hindalco Truck Entry App v1.0.0',
                            ),
                      ),
                      const ProfileOptionDivider(),
                      ProfileOptionTile(
                        icon: Icons.logout_rounded,
                        title: 'Logout',
                        isDestructive: true,
                        onTap: widget.onLogout,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 24),
                const Text(
                  'App Version 1.0.0',
                  style: TextStyle(
                    color: Color(0xFF9AA2AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
