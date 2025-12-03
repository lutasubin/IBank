// ==================== THEME ====================
// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:ibank/core/theme/app_colors.dart';
import 'package:ibank/core/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary1,
    scaffoldBackgroundColor: AppColors.neutral6,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary1,
      secondary: AppColors.primary2,
      error: AppColors.error,
      surface: AppColors.neutral6,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.title1,
      displayMedium: AppTextStyles.title2,
      displaySmall: AppTextStyles.title3,
      bodyLarge: AppTextStyles.body1,
      bodyMedium: AppTextStyles.body2,
      bodySmall: AppTextStyles.body3,
      labelLarge: AppTextStyles.caption1,
      labelMedium: AppTextStyles.caption2,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.neutral6,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.neutral1),
      titleTextStyle: TextStyle(
        color: AppColors.neutral1,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}