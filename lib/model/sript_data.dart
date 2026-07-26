class ScriptCardData {
  final String title;
  final String charCount;
  final List<String> characters;
  final String progressText;
  final double progressPercent;
  final String actionText;
  final bool isStarted;

  const ScriptCardData({
    required this.title,
    required this.charCount,
    required this.characters,
    required this.progressText,
    required this.progressPercent,
    required this.actionText,
    required this.isStarted,
  });
}