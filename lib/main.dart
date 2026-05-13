import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';

import 'models/app_user.dart';
import 'models/dashboard_stats.dart';
import 'models/driver.dart';
import 'models/material_option.dart';
import 'models/app_notification.dart';
import 'services/api_client.dart';
import 'services/api_config.dart';
import 'services/cognito_auth_service.dart';
import 'services/current_user_store.dart';
import 'services/driver_service.dart';
import 'services/notification_service.dart';
import 'services/report_service.dart';
import 'services/upload_service.dart';
import 'services/user_service.dart';
import 'services/material_service.dart';

part 'models/truck_entry.dart';
part 'models/approval_result.dart';
part 'models/gate_entry_submit_result.dart';
part 'models/driver_records_result.dart';
part 'screens/auth_pages.dart';
part 'screens/home_dashboard_page.dart';
part 'screens/new_truck_entry_page.dart';
part 'screens/records_page.dart';
part 'screens/record_detail_page.dart';
part 'screens/profile_page.dart';
part 'services/dashboard_service.dart';
part 'services/entry_service.dart';
part 'services/record_service.dart';
part 'utils/dashboard_utils.dart';
part 'widgets/auth_widgets.dart';
part 'widgets/dashboard_widgets.dart';
part 'widgets/detail_widgets.dart';
part 'widgets/entry_widgets.dart';
part 'widgets/profile_widgets.dart';
part 'widgets/records_widgets.dart';

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
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}

class AppRoutes {
  const AppRoutes._();

  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const otpVerification = '/otp-verification';
  static const resetPassword = '/reset-password';
  static const home = '/home';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginPage(),
    signup: (_) => const SignUpPage(),
    forgotPassword: (_) => const ForgotPasswordPage(),
    otpVerification: (_) => const OtpVerificationPage(),
    resetPassword: (_) => const ResetPasswordPage(),
    home: (_) => const HomeDashboardPage(),
  };
}
