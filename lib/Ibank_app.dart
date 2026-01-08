import 'package:flutter/material.dart';
import 'package:ibank/core/theme/app_theme.dart';
import 'package:ibank/features/auth/admin/presentation/pages/admin_home_page.dart';
import 'package:ibank/features/auth/admin/presentation/pages/admin_signin_page.dart';
import 'package:ibank/features/auth/password/persentation/pages/forgot_password_page.dart';
import 'package:ibank/features/auth/signin/persentation/pages/signin_page.dart';
import 'package:ibank/features/auth/signup/persentation/pages/signup_page.dart';
import 'package:ibank/features/home/presentation/pages/home_pages.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class IBankApp extends StatelessWidget {
  const IBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      title: 'Bank - Banking & E-Money Management App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/home': (context) => const HomePage(),
        '/admin-signin': (context) => AdminSignInPage(), //!demo phan quyen
        '/admin-home': (context) => const AdminHomePage(), //!demo phan quyen
      },
    );
  }
}