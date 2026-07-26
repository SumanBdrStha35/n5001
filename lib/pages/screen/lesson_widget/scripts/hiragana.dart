import 'package:flutter/material.dart';

import '../../../../model/sript_data.dart';
import '../../../../model/sript_lesson.dart';
import 'script.dart';

/// HiraganaPage – a convenience wrapper around [ScriptPageContent]
/// pre‑configured with Hiragana script card data.
///
/// The script card data is computed dynamically from the actual lesson list
/// so that progress and counts are always accurate.
class HiraganaPage extends StatelessWidget {
  final List<LessonData> lessons;
  final bool isLoading;

  const HiraganaPage({
    super.key,
    required this.lessons,
    required this.isLoading,
  });

  static const List<String> _sampleChars = [
    'あ',
    'い',
    'う',
    'え',
    'お',
    'か',
    'き',
    'く',
    'け',
    'こ',
  ];

  /// Builds a [ScriptCardData] from the actual lesson data.
  ScriptCardData _buildCardData() {
    final total = lessons.length;
    final completed = lessons.where((l) => l.statusText == 'Completed').length;
    final inProgress = lessons
        .where((l) => l.statusText == 'In Progress')
        .length;
    final opened = lessons.where((l) => l.statusText == 'Opened').length;

    double progressPercent = total > 0 ? completed / total : 0.0;

    String progressText;
    bool isStarted;
    String actionText;

    if (completed == total) {
      progressText = 'All $total characters complete';
      isStarted = true;
      actionText = 'Review';
    } else if (completed > 0 || inProgress > 0 || opened > 0) {
      final studying = completed + inProgress;
      progressText = '$studying of $total complete';
      isStarted = true;
      actionText = 'Continue';
    } else {
      progressText = '0 of $total — Not started';
      isStarted = false;
      actionText = 'Start Learning';
    }

    return ScriptCardData(
      title: 'Hiragana',
      charCount: '$total chars',
      characters: _sampleChars,
      progressText: progressText,
      progressPercent: progressPercent,
      actionText: actionText,
      isStarted: isStarted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScriptPageContent(
      scriptCard: _buildCardData(),
      lessons: lessons,
      isLoading: isLoading,
    );
  }
}
