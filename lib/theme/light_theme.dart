import 'package:flutter/material.dart';

import '../other/app_colors.dart';
import '../other/app_text_styles.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Baloo 2',

      scaffoldBackgroundColor: AppColors.background,

      colorScheme: const ColorScheme.light(
        primary: AppColors.oceanBlue,
        secondary: AppColors.terracotta,
        surface: AppColors.ivory,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.lightText,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: AppColors.ivory,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.oceanBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.lightText,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.lightText,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.lightText),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.lightText.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
