class AppDurations {
  const AppDurations._();

  static const Duration instant = Duration(milliseconds: 0);

  static const Duration short = Duration(milliseconds: 200); //150
  static const Duration medium = Duration(milliseconds: 400); //250
  static const Duration long = Duration(milliseconds: 600); //400

  // Common UI transitions
  static const Duration fadeIn = medium;
  static const Duration slideIn = long;

  static const Duration pageTransition = Duration(milliseconds: 450);
  static const Duration splashDelay = Duration(seconds: 2);
}
