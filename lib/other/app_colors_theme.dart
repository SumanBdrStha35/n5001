import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppColorsTheme {
  const AppColorsTheme._();

  // =========================
  // Primary Colors
  // =========================
  static Color primary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkPrimary
        : AppColors.primary;
  }

  static Color primaryDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.primaryDark
        : AppColors.primaryDark;
  }

  static Color primarySoft(BuildContext context) {
    return primary(context).withValues(alpha: 0.10);
  }

  // =========================
  // Background & Surface
  // =========================
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkBg
        : AppColors.background;
  }

  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkSurface
        : AppColors.surface;
  }

  static Color surfaceVariant(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkCard
        : AppColors.surfaceVariant;
  }

  static Color card(BuildContext context) {
    return surfaceVariant(context);
  }

  // =========================
  // Text Colors
  // =========================
  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkText
        : AppColors.textPrimary;
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkSecondary
        : AppColors.textSecondary;
  }

  // =========================
  // Border & Divider
  // =========================
  static Color border(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkCard.withValues(alpha: 0.8)
        : AppColors.border;
  }

  static Color divider(BuildContext context) {
    return border(context).withValues(alpha: 0.5);
  }

  // =========================
  // State Colors
  // =========================
  static Color success(BuildContext context) {
    return AppColors.success;
  }

  static Color warning(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkSecondary
        : AppColors.warning;
  }

  static Color error(BuildContext context) {
    return AppColors.error;
  }

  // =========================
  // Extra Accent Colors
  // =========================
  static Color accent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkAccent
        : AppColors.lavender;
  }

  static Color highlight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkPrimary.withValues(alpha: 0.2)
        : AppColors.skyBlue.withValues(alpha: 0.3);
  }
}
