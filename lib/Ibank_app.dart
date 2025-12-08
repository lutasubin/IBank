import 'package:flutter/material.dart';
import 'package:ibank/core/theme/app_theme.dart';
import 'package:ibank/features/auth/signin/persentation/pages/signin_page.dart';
import 'package:ibank/features/auth/signup/persentation/pages/signup_page.dart';
import 'package:ibank/features/auth/password/persentation/pages/forgot_password_page.dart';
import 'package:ibank/features/auth/password/persentation/pages/change_password_page.dart';
import 'package:ibank/features/home/presentation/pages/home_pages.dart';


class IBankApp extends StatelessWidget {
  const IBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank - Banking & E-Money Management App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/change-password': (context) => const ChangePasswordPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}