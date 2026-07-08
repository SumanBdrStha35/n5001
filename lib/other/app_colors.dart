import 'package:flutter/material.dart';

/// Centralized color palette for the app
class AppColors {
  // =========================
  // Light Theme Colors
  // =========================
  static const Color background = Color(0xFFE8E0D7);
  static const Color ivory = Color(0xFFF4EEE6);
  static const Color cream = Color(0xFFF2E0BD);
  static const Color sage = Color(0xFFC9C89D);

  static const Color skyBlue = Color(0xFFB6D4EC);
  static const Color oceanBlue = Color(0xFF5A9ACD);
  static const Color peach = Color(0xFFF0B8AF);

  static const Color whiteSmoke = Color(0xFFF6F6F6);
  static const Color lavender = Color(0xFFD57BD8);
  static const Color terracotta = Color(0xFFE49768);

  // =========================
  // Dark Theme Colors
  // =========================
  static const Color darkBg = Color(0xFF1D1B1A);
  static const Color darkSurface = Color(0xFF2B2928);
  static const Color darkCard = Color(0xFF383433);

  static const Color darkPrimary = Color(0xFF7AA7D9);
  static const Color darkSecondary = Color(0xFFD98D78);
  static const Color darkAccent = Color(0xFFD88ED8);

  static const Color darkText = Color(0xFFF4EEE6);
  static const Color lightText = Color(0xFF1C1C1C);

  // =========================
  // Common Semantic Colors
  // =========================

  /// Main brand color
  static const Color primary = oceanBlue;

  /// Used for text on light background
  static const Color textPrimary = lightText;

  /// Used for secondary/subtitle text
  static const Color textSecondary = Color(0xFF6B6B6B);

  /// Card / container background
  static const Color surface = ivory;

  /// Border color for cards/buttons
  static const Color border = Color(0xFFD9D1C8);

  /// Alternate surface shade
  static const Color surfaceVariant = cream;

  /// Success states
  static const Color success = Color(0xFF4CAF50);

  /// Warning states
  static const Color warning = Color(0xFFFFB300);

  /// Error states
  static const Color error = Color(0xFFE53935);

  /// Darker primary shade
  static const Color primaryDark = Color(0xFF3D7FB3);

  /// Transparent helper
  static const Color transparent = Colors.transparent;
}
