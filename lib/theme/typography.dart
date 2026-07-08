import 'package:flutter/material.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme textTheme({
    required Color primary,
    required Color secondary,
    required Color inverse,
    required Color muted,
  }) {
    return TextTheme(
      // Display
      displayLarge: TextStyle(
        color: primary,
        fontSize: 57,
        fontWeight: FontWeight.w700,
        height: 1.0,
      ),
      displayMedium: TextStyle(
        color: primary,
        fontSize: 45,
        fontWeight: FontWeight.w700,
        height: 1.0,
      ),
      displaySmall: TextStyle(
        color: primary,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.05,
      ),

      // Headline
      headlineLarge: TextStyle(
        color: primary,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.1,
      ),
      headlineMedium: TextStyle(
        color: primary,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      headlineSmall: TextStyle(
        color: primary,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),

      // Title
      titleLarge: TextStyle(
        color: primary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      titleMedium: TextStyle(
        color: primary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleSmall: TextStyle(
        color: secondary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),

      // Body
      bodyLarge: TextStyle(
        color: primary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      bodyMedium: TextStyle(
        color: muted,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        color: muted,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.35,
      ),

      // Label
      labelLarge: TextStyle(
        color: inverse,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      labelMedium: TextStyle(
        color: secondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      labelSmall: TextStyle(
        color: secondary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }
}
