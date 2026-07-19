import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme_controller.dart';

class ThemeService {
  static const String _themeModeKey = 'theme_mode';

  static ThemeController? _controller;

  /// Called once from App to register the shared ThemeController.
  static void attachController(ThemeController controller) {
    _controller = controller;
  }

  static Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_themeModeKey);
    switch (raw) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  /// Live update: changes the currently attached ThemeController (so UI updates instantly)
  /// and persists the new value.
  static Future<void> setThemeModeLive(ThemeMode mode) async {
    final controller = _controller;
    if (controller == null) {
      // Controller not attached yet; just persist.
      await saveThemeMode(mode);
      return;
    }
    controller.setMode(mode);
    await saveThemeMode(mode);
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
    };
    await prefs.setString(_themeModeKey, raw);
  }

  static Future<void> setThemeMode(
    ThemeMode mode,
    ThemeController controller,
  ) async {
    controller.setMode(mode);
    await saveThemeMode(mode);
  }

  static Future<void> toggleDark(
    bool enabled,
    ThemeController controller,
  ) async {
    final newMode = enabled ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode, controller);
  }
}
