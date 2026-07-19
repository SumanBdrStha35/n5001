import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeController() : _mode = ThemeMode.dark;

  ThemeMode _mode;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }
}
