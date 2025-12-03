// ==================== MAIN ====================
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:ibank/Ibank_app.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await di.init();
  
  runApp(const IBankApp());
}

