import 'package:flutter/material.dart';

import '../../../../data/hr_lesson_repository.dart';
import '../../../../model/sript_data.dart';
import '../../../../model/sript_lesson.dart';
import 'widgets/header_card.dart';
import 'widgets/lesson_list.dart';

class HiraganaPage extends StatelessWidget {
  final List<LessonData> lessons;
  final bool isLoading;

  const HiraganaPage({
    super.key,
    required this.lessons,
    required this.isLoading,
  });

  ScriptSummary _buildSummary() {
    final totalLessons = lessons.length;
    final completed = lessons.where((e) => e.statusText == 'Completed').length;
    final studying = lessons.where((e) => e.statusText == 'In Progress').length;
    final unlocked = lessons.where((e) => e.statusText == 'Opened').length;
    final progress = totalLessons == 0 ? 0.0 : completed / totalLessons;
    final totalChars = lessons.fold<int>(0, (sum, l) => sum + l.characterCount);
    String actionText;
    if (completed == totalLessons && totalLessons > 0) {
      actionText = 'Review';
    } else if (completed > 0 || studying > 0 || unlocked > 0) {
      actionText = 'Continue Learning';
    } else {
      actionText = 'Start Learning';
    }
    return ScriptSummary(
      title: 'Hiragana',
      totalCharacters: totalChars,
      totalLessons: totalLessons,
      completedLessons: completed,
      progress: progress,
      actionText: actionText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderCard(summary: _buildSummary(), lessons: lessons),
        const SizedBox(height: 20),
        Expanded(
          child: LessonList(
            lessons: lessons,
            isLoading: isLoading,
            scriptType: ScriptType.hiragana,
          ),
        ),
      ],
    );
  }
}
