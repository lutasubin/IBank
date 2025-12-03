// ==================== SHADOWS ====================
// lib/core/theme/app_shadows.dart

import 'package:flutter/material.dart';

class AppShadows {
  // Drop Shadow Card
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      // ignore: deprecated_member_use
      color: const Color(0xFF3629B7).withOpacity(0.07),
      offset: const Offset(0, 4),
      blurRadius: 30,
    ),
  ];

  // Drop Shadow Card Small
  static List<BoxShadow> cardShadowSmall = [
    BoxShadow(
      // ignore: deprecated_member_use
      color: const Color(0xFF3629B7).withOpacity(0.07),
      offset: const Offset(0, -5),
      blurRadius: 30,
    ),
  ];
}