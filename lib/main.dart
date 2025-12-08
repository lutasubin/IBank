// ==================== MAIN ====================
// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ibank/Ibank_app.dart';
import 'package:ibank/firebase_options.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await di.init();

  runApp(const IBankApp());
}

