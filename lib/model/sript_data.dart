// class ScriptCardData {
//   final String title;
//   final String charCount;
//   final List<String> characters;
//   final String progressText;
//   final double progressPercent;
//   final String actionText;
//   final bool isStarted;

//   const ScriptCardData({
//     required this.title,
//     required this.charCount,
//     required this.characters,
//     required this.progressText,
//     required this.progressPercent,
//     required this.actionText,
//     required this.isStarted,
//   });
// }

/// Summary information for a script (Hiragana / Katakana)
/// displayed in the header card.
class ScriptSummary {
  /// Script name
  final String title;

  /// Total number of characters
  final int totalCharacters;

  /// Total lessons available
  final int totalLessons;

  /// Completed lessons
  final int completedLessons;

  /// Progress value (0.0 - 1.0)
  final double progress;

  /// Button text
  final String actionText;

  const ScriptSummary({
    required this.title,
    required this.totalCharacters,
    required this.totalLessons,
    required this.completedLessons,
    required this.progress,
    required this.actionText,
  });

  bool get isCompleted => completedLessons == totalLessons && totalLessons > 0;

  int get progressPercent => (progress * 100).round();
}
