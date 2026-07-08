import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'theme/app_theme.dart';

import 'pages/onboarding_screen.dart';

// Global app widget.
class N5MasteryApp extends StatelessWidget {
  const N5MasteryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N5 Master',
      theme: AppTheme.lightTheme, //AppTheme.light,
      darkTheme: AppTheme.darkTheme, //AppTheme.dark,
      themeMode: ThemeMode.system,
      routes: AppRoutes.routes,
      home: const SafeArea(child: OnboardingScreen()),
    );
  }
}
