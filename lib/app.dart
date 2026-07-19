import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'pages/onboarding_screen.dart';
import 'service/theme_service.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

// Global app widget.
class N5MasteryApp extends StatefulWidget {
  const N5MasteryApp({super.key});

  @override
  State<N5MasteryApp> createState() => _N5MasteryAppState();

  static ThemeController of(BuildContext context) {
    final state = context.findAncestorStateOfType<_N5MasteryAppState>();
    // ignore: unnecessary_non_null_assertion
    return state!._themeController;
  }

  static void setMode(BuildContext context, ThemeMode mode) {
    of(context).setMode(mode);
  }
}

class _N5MasteryAppState extends State<N5MasteryApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    ThemeService.attachController(_themeController);
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await ThemeService.loadThemeMode();
    _themeController.setMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'N5 Master',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeController.mode,
          routes: AppRoutes.routes,
          home: const SafeArea(child: OnboardingScreen()),
        );
      },
    );
  }
}
