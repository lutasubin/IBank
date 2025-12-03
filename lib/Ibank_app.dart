import 'package:flutter/material.dart';
import 'package:ibank/core/theme/app_theme.dart';
import 'package:ibank/features/auth/signin/persentation/pages/signin_page.dart';
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
        '/home': (context) => const HomePage(),
      },
    );
  }
}