part of '../main.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.highlightedTitle,
    required this.child,
    required this.imageHeight,
    this.imagePath = 'assets/login_page_img.jpg',
    this.showBackButton = false,
    super.key,
  });

  final String title;
  final String highlightedTitle;
  final Widget child;
  final double imageHeight;
  final String imagePath;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipPath(
                          clipper: BottomArcClipper(),
                          child: SizedBox(
                            height: imageHeight,
                            width: double.infinity,
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.06),
                                    Colors.white.withValues(alpha: 0.18),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (showBackButton)
                          Positioned(
                            top: MediaQuery.paddingOf(context).top + 16,
                            left: 22,
                            child: Material(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              elevation: 1,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.chevron_left_rounded),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 14, 28, 24),
                      child: Column(
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF121827),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            highlightedTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF1BA7E1),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.18,
                            ),
                          ),
                          const SizedBox(height: 28),
                          child,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BottomArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 34)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + 30,
        size.width,
        size.height - 34,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.hintText,
    required this.icon,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixPressed,
    this.validator,
    super.key,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return hintText
                  .replaceFirst('Enter your ', '')
                  .capitalizeRequired();
            }
            return null;
          },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF9AA2AF), fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF9AA2AF), size: 20),
        suffixIcon:
            suffixIcon == null
                ? null
                : IconButton(
                  onPressed: onSuffixPressed,
                  icon: Icon(
                    suffixIcon,
                    color: const Color(0xFF9AA2AF),
                    size: 20,
                  ),
                ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: Color(0xFF1BA7E1), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: Color(0xFFE5484D)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1.4),
        ),
      ),
    );
  }
}

class OtpDigitField extends StatelessWidget {
  const OtpDigitField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: '',
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF1BA7E1), width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE5484D)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1.4),
          ),
        ),
      ),
    );
  }
}

class PrimaryAuthButton extends StatelessWidget {
  const PrimaryAuthButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF111827),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          isLoading ? 'Please wait...' : label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE7EAF0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFA1A8B3), fontSize: 12),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE7EAF0))),
      ],
    );
  }
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const SocialButton(label: 'Google');
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showAuthMessage(context, '$label auth coming soon.'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF111827),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(vertical: 13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/google.png',
            height: 20,
            width: 20,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthFooterAction extends StatelessWidget {
  const AuthFooterAction({
    required this.text,
    required this.actionText,
    required this.onTap,
    super.key,
  });

  final String text;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '$text ',
          style: const TextStyle(color: Color(0xFF9097A3), fontSize: 12),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

extension RequiredMessage on String {
  String capitalizeRequired() {
    if (isEmpty) {
      return 'This field is required';
    }
    return '${this[0].toUpperCase()}${substring(1)} is required';
  }
}

void _showNotifications(BuildContext context) {
  final notificationsFuture = NotificationService().getNotifications();
  notificationsFuture
      .then((_) => NotificationService().markAllRead())
      .catchError((_) {});

  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder:
        (sheetContext) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Close notifications',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<AppNotification>>(
                  future: notificationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final notifications = snapshot.data ?? const [];
                    if (snapshot.hasError || notifications.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'No notifications available',
                            style: TextStyle(
                              color: Color(0xFF7D8491),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children:
                          notifications
                              .map(
                                (notification) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7F9FC),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFFE7EAF0),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: _notificationColor(
                                              notification,
                                            ).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            _notificationIcon(notification),
                                            color: _notificationColor(
                                              notification,
                                            ),
                                            size: 21,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notification.title,
                                                style: const TextStyle(
                                                  color: Color(0xFF111827),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                notification.message,
                                                style: const TextStyle(
                                                  color: Color(0xFF515A68),
                                                  fontSize: 12,
                                                  height: 1.35,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _notificationTime(notification),
                                          style: const TextStyle(
                                            color: Color(0xFF9AA2AF),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
  );
}

IconData _notificationIcon(AppNotification notification) {
  if (notification.type == 'temperature_alert') {
    return Icons.thermostat_outlined;
  }
  if (notification.type.contains('entry')) {
    return Icons.local_shipping_outlined;
  }
  return Icons.notifications_outlined;
}

Color _notificationColor(AppNotification notification) {
  if (notification.priority == 'high' ||
      notification.type == 'temperature_alert') {
    return const Color(0xFFE5484D);
  }
  if (notification.priority == 'low') {
    return const Color(0xFF17A56B);
  }
  return const Color(0xFF1BA7E1);
}

String _notificationTime(AppNotification notification) {
  final createdAt = notification.createdAt;
  if (createdAt == null) {
    return '';
  }
  final diff = DateTime.now().difference(createdAt);
  if (diff.inMinutes < 1) {
    return 'now';
  }
  if (diff.inHours < 1) {
    return '${diff.inMinutes} min ago';
  }
  if (diff.inDays < 1) {
    return '${diff.inHours} hr ago';
  }
  return '${diff.inDays} d ago';
}

void _showAuthMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String _cleanAuthError(Object error) {
  final message = error.toString();
  const exceptionPrefix = 'Exception: ';
  if (message.startsWith(exceptionPrefix)) {
    return message.substring(exceptionPrefix.length);
  }
  return message;
}
