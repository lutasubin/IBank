// ==================== MAIN ====================
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:ibank/features/auth/signin/persentation/pages/signin_page.dart';
import 'package:ibank/features/home/presentation/pages/home_pages.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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