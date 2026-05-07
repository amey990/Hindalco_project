import 'package:flutter/material.dart';

void main() {
  runApp(const HindalcoApp());
}

class HindalcoApp extends StatelessWidget {
  const HindalcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hindalco',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Login to Access Your',
      highlightedTitle: 'Hindalco Account',
      imageHeight: 326,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const AuthTextField(
              hintText: 'Enter your email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            AuthTextField(
              hintText: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              suffixIcon:
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              onSuffixPressed:
                  () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged:
                      (value) => setState(() => _rememberMe = value ?? false),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Color(0xFFB8C0CC)),
                ),
                const Text(
                  'Remember me',
                  style: TextStyle(color: Color(0xFF7D8491), fontSize: 13),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _push(context, const ForgotPasswordPage()),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            PrimaryAuthButton(
              label: 'Login',
              onPressed: () => _submit(context, 'Login'),
            ),
            const SizedBox(height: 22),
            const AuthDivider(label: 'Or login with'),
            const SizedBox(height: 18),
            const SocialButtons(),
            const SizedBox(height: 24),
            AuthFooterAction(
              text: 'Don\'t have an account?',
              actionText: 'Create an account',
              onTap: () => _push(context, const SignUpPage()),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context, String action) {
    if (_formKey.currentState?.validate() ?? false) {
      _showAuthMessage(context, '$action flow is ready for API integration.');
    }
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Sign Up to Access',
      highlightedTitle: 'Hindalco',
      imageHeight: 246,
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const AuthTextField(
              hintText: 'Enter your name',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 12),
            const AuthTextField(
              hintText: 'Enter your email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              hintText: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              suffixIcon:
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              onSuffixPressed:
                  () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            const SizedBox(height: 12),
            AuthTextField(
              hintText: 'Confirm password',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscureConfirmPassword,
              suffixIcon:
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              onSuffixPressed:
                  () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged:
                      (value) => setState(() => _rememberMe = value ?? false),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Color(0xFFB8C0CC)),
                ),
                const Text(
                  'Remember me',
                  style: TextStyle(color: Color(0xFF7D8491), fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 18),
            PrimaryAuthButton(
              label: 'Sign Up',
              onPressed: () => _submit(context),
            ),
            const SizedBox(height: 22),
            const AuthDivider(label: 'Or signup with'),
            const SizedBox(height: 18),
            const SocialButtons(),
            const SizedBox(height: 24),
            AuthFooterAction(
              text: 'Already have an account?',
              actionText: 'Login',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      _showAuthMessage(context, 'Signup flow is ready for API integration.');
    }
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return AuthScaffold(
      title: 'Forgot Password? Reset',
      highlightedTitle: 'Your Access Here',
      imageHeight: 370,
      showBackButton: true,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const AuthTextField(
              hintText: 'Enter your email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            PrimaryAuthButton(
              label: 'Submit',
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  _showAuthMessage(
                    context,
                    'Password reset flow is ready for API integration.',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.highlightedTitle,
    required this.child,
    required this.imageHeight,
    this.showBackButton = false,
    super.key,
  });

  final String title;
  final String highlightedTitle;
  final Widget child;
  final double imageHeight;
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
                              'assets/login_page_img.jpg',
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
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixPressed,
    super.key,
  });

  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return hintText.replaceFirst('Enter your ', '').capitalizeRequired();
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

class PrimaryAuthButton extends StatelessWidget {
  const PrimaryAuthButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

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
          label,
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
    return Row(
      children: const [
        Expanded(child: SocialButton(label: 'Google', mark: 'G')),
        SizedBox(width: 14),
        Expanded(child: SocialButton(label: 'Facebook', mark: 'f')),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({required this.label, required this.mark, super.key});

  final String label;
  final String mark;

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
          Text(
            mark,
            style: TextStyle(
              color:
                  label == 'Google'
                      ? const Color(0xFFDB4437)
                      : const Color(0xFF4267B2),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
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

void _push(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

void _showAuthMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
