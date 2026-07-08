import 'package:flutter/material.dart';
import 'package:n5001/pages/login_screen.dart';

import 'pages/dashboard_screen.dart';
import 'pages/screen/home_screen.dart';
import 'pages/onboarding_screen.dart';

/// Central place for app routes.
class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> routes = {
    home: (_) => HomeScreen(),
    login: (_) => LoginScreen(),
    dashboard: (_) => const DashboardScreen(),
    onboarding: (_) => const OnboardingScreen(),
  };
}
