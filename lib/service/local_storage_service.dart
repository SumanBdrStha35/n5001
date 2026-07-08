import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // Onboarding
  static const String _onboardingCompletedKey = 'onboarding_completed';
  // logged in
  static const String _loggedInKey = 'logged_in';

  /// ==================== Onboarding ====================
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, value);
  }

  /// ==================== Logged In ====================
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
  }

  /// Optional: can be used to remember last onboarding step.
  static Future<void> savePage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onboarding_page', page);
  }

  static Future<int> loadPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('onboarding_page') ?? 0;
  }
}
