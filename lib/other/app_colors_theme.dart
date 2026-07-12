import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Immutable per-mode palette.
///
/// Keep these values aligned with [AppColors] so existing palette usage stays consistent.
@immutable
class AppColorTheme {
  final Brightness brightness;

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color card;
  final Color border;

  final Color primary;
  final Color primaryDark;
  final Color secondary;
  final Color accent;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // Home screen / branding
  final Color brandIndigo;
  final Color brandAmber;
  final Color brandBlue;

  // Status semantic
  final Color success;
  final Color warning;
  final Color error;

  const AppColorTheme({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.card,
    required this.border,
    required this.primary,
    required this.primaryDark,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.brandIndigo,
    required this.brandAmber,
    required this.brandBlue,
    required this.success,
    required this.warning,
    required this.error,
  });
}

/// Centralized color provider that adapts to Light & Dark modes.
///
/// Usage examples:
/// - `AppColorsTheme.of(context).background`
/// - `AppColorsTheme.light.primary`
/// - `AppColorsTheme.dark.textPrimary`
class AppColorsTheme {
  const AppColorsTheme._();

  static const AppColorTheme light = AppColorTheme(
    brightness: Brightness.light,
    background: AppColors.background,
    surface: AppColors.ivory,
    surfaceVariant: AppColors.surfaceVariant,
    card: AppColors.whiteSmoke,
    border: AppColors.border,

    primary: AppColors.oceanBlue,
    primaryDark: AppColors.primaryDark,
    secondary: AppColors.peach,
    accent: AppColors.lavender,

    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textMuted,

    brandIndigo: AppColors.indigoPrimary,
    brandAmber: AppColors.amberStreak,
    brandBlue: AppColors.blueBrand,

    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
  );

  static const AppColorTheme dark = AppColorTheme(
    brightness: Brightness.dark,
    background: AppColors.darkBg,
    surface: AppColors.darkSurface,
    surfaceVariant: AppColors.darkCard,
    card: AppColors.darkCard,
    border: AppColors.darkCard,

    primary: AppColors.darkPrimary,
    primaryDark: AppColors.primaryDark,
    secondary: AppColors.darkSecondary,
    accent: AppColors.darkAccent,

    textPrimary: AppColors.darkText,
    textSecondary: AppColors.darkSecondary,
    textMuted: AppColors.darkSecondary,

    // Keep brand identity consistent across themes.
    brandIndigo: AppColors.indigoPrimary,
    brandAmber: AppColors.amberStreak,
    brandBlue: AppColors.blueBrand,

    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
  );

  /// Resolves current palette based on [ThemeData.brightness].
  static AppColorTheme of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  // ------------------------------
  // Backward-compatible API
  // ------------------------------
  // This keeps existing call sites (e.g. `AppColorsTheme.background(context)`)
  // working while you migrate to `AppColorsTheme.of(context)`.

  static Color primary(BuildContext context) => of(context).primary;
  static Color primaryDark(BuildContext context) => of(context).primaryDark;
  static Color primarySoft(BuildContext context) =>
      of(context).primary.withValues(alpha: 0.10);

  static Color background(BuildContext context) => of(context).background;
  static Color surface(BuildContext context) => of(context).surface;
  static Color surfaceVariant(BuildContext context) =>
      of(context).surfaceVariant;
  static Color card(BuildContext context) => of(context).card;

  static Color textPrimary(BuildContext context) => of(context).textPrimary;
  static Color textSecondary(BuildContext context) => of(context).textSecondary;

  static Color textMuted(BuildContext context) => of(context).textMuted;

  static Color border(BuildContext context) => of(context).border;

  static Color divider(BuildContext context) =>
      border(context).withValues(alpha: 0.5);

  static Color success(BuildContext context) => of(context).success;

  static Color warning(BuildContext context) => of(context).warning;

  static Color error(BuildContext context) => of(context).error;

  static Color accent(BuildContext context) => of(context).accent;

  static Color highlight(BuildContext context) {
    final t = Theme.of(context);
    // For dark: slightly accent-tinted highlight; for light: sky-blue tinted.
    return t.brightness == Brightness.dark
        ? of(context).primary.withValues(alpha: 0.2)
        : AppColors.skyBlue.withValues(alpha: 0.3);
  }
}
