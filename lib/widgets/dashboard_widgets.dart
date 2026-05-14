part of '../main.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({required this.onLogout, this.user, super.key});

  final VoidCallback onLogout;
  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppUser?>(
      valueListenable: CurrentUserStore.user,
      builder: (context, storedUser, _) {
        final appUser = user ?? storedUser;
        final displayName = _headerDisplayName(appUser);
        final roleLabel = appUser?.headerRoleLabel ?? 'User';

        return Row(
          children: [
            Container(
              height: 54,
              width: 54,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Image.asset('assets/splash_logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hindalco Entry',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$roleLabel: $displayName',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF7D8491),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: () => _showNotifications(context),
              icon: const Icon(Icons.notifications_outlined),
              tooltip: 'Notifications',
              color: const Color(0xFF111827),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFEAF6FC),
                fixedSize: const Size(46, 46),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: onLogout,
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Logout',
              color: const Color(0xFF111827),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFEAF6FC),
                fixedSize: const Size(46, 46),
              ),
            ),
          ],
        );
      },
    );
  }

  String _headerDisplayName(AppUser? appUser) {
    final name = appUser?.name.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }
    return 'User';
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: [
              Icon(icon, color: accentColor, size: 22),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF515A68),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class RecentEntryTile extends StatelessWidget {
  const RecentEntryTile({required this.entry, super.key});

  final TruckEntry entry;

  @override
  Widget build(BuildContext context) {
    final temperatureColor =
        entry.isNormal ? const Color(0xFF17A56B) : const Color(0xFFE5484D);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6FC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: Color(0xFF1BA7E1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.driverName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  entry.truckNumber,
                  style: const TextStyle(
                    color: Color(0xFF7D8491),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.temperature.toStringAsFixed(1)} F',
                style: TextStyle(
                  color: temperatureColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                entry.entryTime,
                style: const TextStyle(color: Color(0xFF9AA2AF), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
