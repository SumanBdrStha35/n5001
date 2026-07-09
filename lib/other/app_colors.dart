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

  // =========================
  // App-specific palette (HomeScreen)
  // =========================

  // Used in home_screen.dart
  static const Color indigoPrimary = Color(0xFF1A237E);
  static const Color amberStreak = Color(0xFFF59E0B);
  static const Color blueBrand = Color(0xFF3B5BDB);
  static const Color progressBg = Color(0xFFFEF3C7);
  static const Color lessonProgressBg = Color(0xFFE0E7FF);
  static const Color vocabCard = Color(0xFFF0F4FF);
  static const Color vocabTagBg = Color(0xFFD1FAE5);
  static const Color vocabTagBorder = Color(0xFF6EE7B7);
  static const Color vocabTagText = Color(0xFF065F46);
  static const Color vocabIcon = Color(0xFF065F46);
  static const Color vocabElevatedText = Color(0xFF1A237E);
  static const Color lightDividerText = Color(0xFF6B6B6B);
  static const Color textMuted = Color(0xFF6B6B6B);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color cardWhiteSmoke = whiteSmoke;
  static const Color black87 = Color(0xFF1C1C1C);
  static const Color black54 = Color(0x8A1C1C1C);
  static const Color black38 = Color(0x611C1C1C);
  static const Color black26 = Color(0x421C1C1C);
  static const Color black54Pure = Color(0x8A000000);
  static const Color black38Pure = Color(0x61000000);
  static const Color black26Pure = Color(0x42000000);

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
