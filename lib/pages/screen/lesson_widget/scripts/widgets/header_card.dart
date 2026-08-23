import 'package:flutter/material.dart';

import '../../../../../data/hr_lesson_repository.dart';
import '../../../../../model/sript_data.dart';
import '../../../../../model/sript_lesson.dart';
import '../../../../../other/app_colors_theme.dart';
import '../../../../../widgets/app_card_container.dart';

class HeaderCard extends StatelessWidget {
  final ScriptSummary summary;
  final VoidCallback? onPressed;
  final VoidCallback? onViewAll;
  final List<LessonData> lessons;
  final ScriptType? scriptType;

  const HeaderCard({
    super.key,
    required this.summary,
    this.onPressed,
    this.onViewAll,
    required this.lessons,
    this.scriptType,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);
    return AppCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                summary.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: t.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: t.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${summary.totalCharacters} Characters',
                  style: TextStyle(
                    color: t.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// Characters from Lesson 1 & 2 in a single row
          if (lessons.length >= 2) ...[
            Row(
              children: [
                Expanded(
                  child: _LessonPreviewCard(
                    lessonIndex: 1,
                    lesson: lessons[0],
                    theme: t,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _LessonPreviewCard(
                    lessonIndex: 2,
                    lesson: lessons[1],
                    theme: t,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          /// Lesson progress and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                summary.completedLessons == 0
                    ? 'Lesson 0 of ${summary.totalLessons} — Not started'
                    : 'Lesson ${summary.completedLessons} of ${summary.totalLessons}'
                          '${summary.completedLessons == summary.totalLessons ? ' complete' : ''}',
                style: TextStyle(
                  color: t.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${summary.completedLessons} of ${summary.totalLessons} lessons',
                style: TextStyle(
                  color: summary.completedLessons == 0
                      ? t.textMuted
                      : t.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: summary.progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: t.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                summary.completedLessons == 0
                    ? t.textMuted.withValues(alpha: 0.3)
                    : t.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),

          /// Buttons Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewAll,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: summary.completedLessons == 0
                        ? t.textMuted
                        : t.primary,
                    side: BorderSide(
                      color: summary.completedLessons == 0
                          ? t.border
                          : t.primary,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View all',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: summary.completedLessons == 0
                        ? t.textMuted
                        : t.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    summary.completedLessons == 0
                        ? 'Start'
                        : summary.completedLessons == 10
                        ? 'Review'
                        : 'Continue',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small card showing a lesson preview with its characters.
class _LessonPreviewCard extends StatelessWidget {
  final int lessonIndex;
  final LessonData lesson;
  final AppColorTheme theme;

  const _LessonPreviewCard({
    required this.lessonIndex,
    required this.lesson,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lesson $lessonIndex',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            lesson.section,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: theme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: lesson.characterKeys.map((char) {
              return Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  char,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.primary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  const _InfoTile({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: t.textMuted, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: t.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
