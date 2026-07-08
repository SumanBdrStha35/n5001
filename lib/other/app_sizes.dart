import 'package:flutter/widgets.dart';

/// Centralized sizing constants used across the UI.
class AppSizes {
  AppSizes._();

  // Spacing
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16; //12
  static const double lg = 24; //16
  static const double xl = 32; //24
  static const double xxl = 32;

  // Padding
  static const double paddingXs = 4.0;
  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;
  static const EdgeInsetsGeometry pagePadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  static const EdgeInsetsGeometry cardPadding = EdgeInsets.all(md);

  // Icon sizes
  static const double iconSm = 16; //18
  static const double iconMd = 24; //22
  static const double iconLg = 32; //28

  // Component heights
  static const double buttonHeight = 48;

  // Border Radius
  static const double radiusSm = 4.0; //10
  static const double radiusMd = 12.0; //16
  static const double radiusLg = 16.0; //24
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;
}
