part of '../main.dart';

enum _AdminUserFilter {
  all('all', 'All'),
  supervisor('supervisor', 'Supervisor'),
  security('security', 'Security');

  const _AdminUserFilter(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

class AdminPage extends StatefulWidget {
  const AdminPage({required this.user, required this.onLogout, super.key});

  final AppUser? user;
  final VoidCallback onLogout;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _adminUserService = AdminUserService();
  _AdminUserFilter _selectedFilter = _AdminUserFilter.all;
  List<ManagedUser> _users = const [];
  bool _isLoading = true;
  bool _isActionRunning = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.user?.canAccessAdminPanel == true) {
      _loadUsers();
    } else {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user?.canAccessAdminPanel != true) {
      return const AccessDeniedView();
    }

    return RefreshIndicator(
      onRefresh: _loadUsers,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(onLogout: widget.onLogout, user: widget.user),
                  const SizedBox(height: 24),
                  const Text(
                    'Admin Tools',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _RolePermissionsCard(),
                  const SizedBox(height: 22),
                  _UserManagementHeader(
                    isLoading: _isLoading,
                    onRefresh: _loadUsers,
                  ),
                  const SizedBox(height: 12),
                  _AdminUserFilters(
                    selectedFilter: _selectedFilter,
                    onChanged: _changeFilter,
                  ),
                  const SizedBox(height: 14),
                  if (_isLoading) ...[
                    const LinearProgressIndicator(minHeight: 2),
                    const SizedBox(height: 14),
                  ],
                  if (_errorMessage != null && !_isLoading)
                    _AdminErrorState(
                      message: _errorMessage!,
                      onRetry: _loadUsers,
                    )
                  else if (!_isLoading && _users.isEmpty)
                    const _AdminEmptyState()
                  else
                    ..._users.map(
                      (user) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ManagedUserCard(
                          user: user,
                          isActionRunning: _isActionRunning,
                          onEnable: () => _confirmEnable(user),
                          onDisable: () => _confirmDisable(user),
                          onDelete: () => _confirmDelete(user),
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

  Future<void> _loadUsers() async {
    if (widget.user?.canAccessAdminPanel != true) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await _adminUserService.getUsers(
        role: _selectedFilter.apiValue,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = _cleanAuthError(error);
      });
    }
  }

  void _changeFilter(_AdminUserFilter filter) {
    if (_selectedFilter == filter) {
      return;
    }
    setState(() => _selectedFilter = filter);
    _loadUsers();
  }

  Future<void> _confirmDisable(ManagedUser user) async {
    final confirmed = await _showConfirmationDialog(
      title: 'Disable user?',
      message: 'This user will not be able to access the app.',
      confirmLabel: 'Disable',
      isDanger: true,
    );
    if (confirmed) {
      await _runUserAction(
        () => _adminUserService.disableUser(user.id),
        fallbackMessage: 'User disabled successfully.',
      );
    }
  }

  Future<void> _confirmEnable(ManagedUser user) async {
    final confirmed = await _showConfirmationDialog(
      title: 'Enable user?',
      message: 'This user will regain app access.',
      confirmLabel: 'Enable',
    );
    if (confirmed) {
      await _runUserAction(
        () => _adminUserService.enableUser(user.id),
        fallbackMessage: 'User enabled successfully.',
      );
    }
  }

  Future<void> _confirmDelete(ManagedUser user) async {
    final confirmed = await _showConfirmationDialog(
      title: 'Permanently delete user?',
      message:
          'This will permanently delete the user from the system and Cognito. '
          'This action cannot be undone. Historical gate-entry records will '
          'remain for audit.',
      confirmLabel: 'Delete',
      isDanger: true,
    );
    if (confirmed) {
      await _runUserAction(
        () => _adminUserService.deleteUser(user.id),
        fallbackMessage: 'User deleted successfully.',
      );
    }
  }

  Future<void> _runUserAction(
    Future<ManagedUser> Function() action, {
    required String fallbackMessage,
  }) async {
    setState(() => _isActionRunning = true);
    try {
      await action();
      if (!mounted) {
        return;
      }
      _showAuthMessage(
        context,
        _adminUserService.lastMessage?.trim().isNotEmpty == true
            ? _adminUserService.lastMessage!
            : fallbackMessage,
      );
      await _loadUsers();
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showAuthMessage(context, _cleanAuthError(error));
    } finally {
      if (mounted) {
        setState(() => _isActionRunning = false);
      }
    }
  }

  Future<bool> _showConfirmationDialog({
    required String title,
    required String message,
    required String confirmLabel,
    bool isDanger = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      isDanger
                          ? const Color(0xFFE5484D)
                          : const Color(0xFF111827),
                  foregroundColor: Colors.white,
                ),
                child: Text(confirmLabel),
              ),
            ],
          ),
    );
    return confirmed == true;
  }
}

class _UserManagementHeader extends StatelessWidget {
  const _UserManagementHeader({
    required this.isLoading,
    required this.onRefresh,
  });

  final bool isLoading;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Management',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage supervisor and security users',
                style: TextStyle(
                  color: Color(0xFF7D8491),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: isLoading ? null : onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Refresh users',
          color: const Color(0xFF1BA7E1),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFEAF6FC),
            fixedSize: const Size(44, 44),
          ),
        ),
      ],
    );
  }
}

class _AdminUserFilters extends StatelessWidget {
  const _AdminUserFilters({
    required this.selectedFilter,
    required this.onChanged,
  });

  final _AdminUserFilter selectedFilter;
  final ValueChanged<_AdminUserFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children:
          _AdminUserFilter.values.map((filter) {
            final isSelected = selectedFilter == filter;
            return ChoiceChip(
              selected: isSelected,
              label: Text(filter.label),
              onSelected: (_) => onChanged(filter),
              selectedColor: const Color(0xFFEAF6FC),
              labelStyle: TextStyle(
                color:
                    isSelected
                        ? const Color(0xFF1BA7E1)
                        : const Color(0xFF515A68),
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color:
                      isSelected
                          ? const Color(0xFF1BA7E1)
                          : const Color(0xFFE5E7EB),
                ),
              ),
            );
          }).toList(),
    );
  }
}

class _ManagedUserCard extends StatelessWidget {
  const _ManagedUserCard({
    required this.user,
    required this.isActionRunning,
    required this.onEnable,
    required this.onDisable,
    required this.onDelete,
  });

  final ManagedUser user;
  final bool isActionRunning;
  final VoidCallback onEnable;
  final VoidCallback onDisable;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final statusColor =
        user.isActive ? const Color(0xFF17A56B) : const Color(0xFFE08A00);
    final siteName =
        user.siteName?.trim().isNotEmpty == true ? user.siteName! : 'Hindalco';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF6FC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  user.initials,
                  style: const TextStyle(
                    color: Color(0xFF1BA7E1),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name.isNotEmpty ? user.name : 'Unnamed User',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF7D8491),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(label: user.statusLabel, color: statusColor),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _UserMetaPill(
                  icon: Icons.badge_outlined,
                  label: user.displayRole,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _UserMetaPill(
                  icon: Icons.location_on_outlined,
                  label: siteName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child:
                    user.isActive
                        ? OutlinedButton.icon(
                          onPressed: isActionRunning ? null : onDisable,
                          icon: const Icon(Icons.block_rounded, size: 18),
                          label: const Text('Disable'),
                          style: _actionButtonStyle(
                            const Color(0xFFE08A00),
                          ),
                        )
                        : OutlinedButton.icon(
                          onPressed: isActionRunning ? null : onEnable,
                          icon: const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 18,
                          ),
                          label: const Text('Enable'),
                          style: _actionButtonStyle(
                            const Color(0xFF17A56B),
                          ),
                        ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isActionRunning ? null : onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text('Delete'),
                  style: _actionButtonStyle(const Color(0xFFE5484D)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ButtonStyle _actionButtonStyle(Color color) {
    return OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
    );
  }
}

class _UserMetaPill extends StatelessWidget {
  const _UserMetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1BA7E1), size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF515A68),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _AdminErrorState extends StatelessWidget {
  const _AdminErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFE5484D),
            size: 38,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF515A68),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1BA7E1),
              side: const BorderSide(color: Color(0xFF1BA7E1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminEmptyState extends StatelessWidget {
  const _AdminEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: const Column(
        children: [
          Icon(Icons.people_outline_rounded, color: Color(0xFF9AA2AF), size: 42),
          SizedBox(height: 10),
          Text(
            'No supervisor/security users found.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF515A68),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RolePermissionsCard extends StatelessWidget {
  const _RolePermissionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: Color(0xFF1BA7E1),
                size: 22,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Role Permissions',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'View role-wise app access',
            style: TextStyle(
              color: Color(0xFF7D8491),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 14),
          _PermissionRow(
            role: 'Admin',
            items: [
              'Full access',
              'Records and reports',
              'Material management',
              'User management',
            ],
          ),
          _PermissionRow(
            role: 'Supervisor',
            items: [
              'Gate operations',
              'Records',
              'Reports',
              'Material management',
            ],
          ),
          _PermissionRow(
            role: 'Security Guard',
            items: [
              'Entry creation',
              'Driver lookup',
              'Photo upload',
              'Limited records',
              'No report downloads',
              'No material creation',
            ],
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.role,
    required this.items,
    this.showDivider = true,
  });

  final String role;
  final List<String> items;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 104,
                child: Text(
                  role,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      items
                          .map((item) => _PermissionChip(label: item))
                          .toList(),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xFFE7EAF0)),
      ],
    );
  }
}

class _PermissionChip extends StatelessWidget {
  const _PermissionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF515A68),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
