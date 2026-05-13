part of '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = CognitoAuthService();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            AuthTextField(
              hintText: 'Enter your email',
              icon: Icons.mail_outline_rounded,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            AuthTextField(
              hintText: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              controller: _passwordController,
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
                  onPressed:
                      () => Navigator.pushNamed(
                        context,
                        AppRoutes.forgotPassword,
                      ),
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
              isLoading: _isLoading,
              onPressed: _isLoading ? null : () => _submit(context),
            ),
            const SizedBox(height: 22),
            const AuthDivider(label: 'Or login with'),
            const SizedBox(height: 18),
            const SocialButtons(),
            const SizedBox(height: 24),
            AuthFooterAction(
              text: 'Don\'t have an account?',
              actionText: 'Create an account',
              onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!context.mounted) {
        return;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      _showAuthMessage(context, _cleanAuthError(error));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
      imagePath: 'assets/industry.jpg',
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
      imagePath: 'assets/industry2.jpg',
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
                  Navigator.pushNamed(context, AppRoutes.otpVerification);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Verify Your',
      highlightedTitle: 'Reset Code',
      imageHeight: 330,
      imagePath: 'assets/industry2.jpg',
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              'Enter the 4-digit code sent to your registered email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7D8491),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => OtpDigitField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  onChanged: (value) => _moveOtpFocus(index, value),
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed:
                  () => _showAuthMessage(context, 'A new OTP has been sent.'),
              child: const Text(
                'Resend code',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryAuthButton(
              label: 'Verify',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.pushNamed(context, AppRoutes.resetPassword);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _moveOtpFocus(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create New',
      highlightedTitle: 'Password',
      imageHeight: 330,
      imagePath: 'assets/industry2.jpg',
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthTextField(
              hintText: 'Enter new password',
              icon: Icons.lock_outline_rounded,
              controller: _passwordController,
              obscureText: _obscurePassword,
              suffixIcon:
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              onSuffixPressed:
                  () => setState(() => _obscurePassword = !_obscurePassword),
              validator: _validatePassword,
            ),
            const SizedBox(height: 14),
            AuthTextField(
              hintText: 'Confirm new password',
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Confirm password is required';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            PrimaryAuthButton(
              label: 'Reset Password',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  messenger
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Password reset successfully. Please login.',
                        ),
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'New password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}
