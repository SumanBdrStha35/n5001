import 'package:flutter/material.dart';

import '../../../../../data/hr_lesson_repository.dart';
import '../../../../../model/sript_lesson.dart';
import '../../../../../other/app_colors_theme.dart';
import '../../../character_detail_screen.dart';
import 'lesson_card.dart';

class LessonList extends StatelessWidget {
  final List<LessonData> lessons;
  final bool isLoading;
  final ScriptType scriptType;

  const LessonList({
    super.key,
    required this.lessons,
    required this.isLoading,
    required this.scriptType,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (lessons.isEmpty) {
      return Center(
        child: Text(
          'No lessons available',
          style: TextStyle(color: t.textSecondary, fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lesson-wise Practice',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: t.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: lessons.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return LessonCard(
                lessonNumber: index + 1,
                lesson: lesson,
                onTap: () {
                  if (lesson.statusText == 'Locked') return;
                  // Navigate to the character detail page with the full lesson context
                  navigateToCharacterDetail(
                    context: context,
                    character: lesson.title, //  "あ", "ア"
                    scriptType: scriptType, // Hiragana, Katakana
                    lesson: lesson,
                    onLessonComplete: () {
                      // Future: update lesson progress to "Completed" here
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
