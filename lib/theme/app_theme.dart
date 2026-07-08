import 'package:flutter/material.dart';
import '../other/app_colors.dart';

class AppTheme {
  // static ThemeData light = LightTheme.theme;
  // static ThemeData dark = DarkTheme.theme;
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
  );
}
