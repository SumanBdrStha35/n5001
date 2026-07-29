import 'package:flutter/material.dart';

import '../../../../../model/sript_lesson.dart';
import '../../../../../other/app_colors_theme.dart';
import '../../../../../widgets/app_card_container.dart';

class LessonCard extends StatelessWidget {
  final LessonData lesson;
  final VoidCallback? onTap;
  final int lessonNumber;

  const LessonCard({
    super.key,
    required this.lesson,
    this.onTap,
    required this.lessonNumber,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);
    final status = lesson.statusText;

    return AppCardContainer(
      onTap: status == 'Locked' ? null : onTap,
      backgroundColor: _backgroundColor(status, t),
      borderColor: _borderColor(status, t),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top row: Status icon + Lesson number + Status label
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _iconBackground(status, t),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_statusIcon(status), color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lesson $lessonNumber',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: t.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lesson.section,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: t.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _statusLabel(status),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _statusTextColor(status, t),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Characters row
          // Row(
          //   children: lesson.characterKeys.map((char) {
          //     return Expanded(
          //       child: Container(
          //         margin: const EdgeInsets.symmetric(horizontal: 2),
          //         padding: const EdgeInsets.symmetric(vertical: 8),
          //         alignment: Alignment.center,
          //         decoration: BoxDecoration(
          //           color: t.primary.withValues(alpha: 0.08),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         child: Text(
          //           char,
          //           style: TextStyle(
          //             fontSize: 22,
          //             fontWeight: FontWeight.bold,
          //             color: t.primary,
          //           ),
          //         ),
          //       ),
          //     );
          //   }).toList(),
          // ),
          // const SizedBox(height: 4),

          /// Romaji row
          // Row(
          //   children: lesson.characterKeys.map((char) {
          //     return Expanded(
          //       child: Container(
          //         margin: const EdgeInsets.symmetric(horizontal: 2),
          //         padding: const EdgeInsets.only(bottom: 4),
          //         alignment: Alignment.center,
          //         child: Text(
          //           lesson.characters[char] ?? '',
          //           style: TextStyle(fontSize: 11, color: t.textMuted),
          //         ),
          //       ),
          //     );
          //   }).toList(),
          // ),
        ],
      ),
    );
  }

  IconData _statusIcon(String statusText) {
    switch (statusText) {
      case 'Completed':
        return Icons.check_circle_outline;
      case 'In Progress':
        return Icons.play_arrow_rounded;
      case 'Opened':
        return Icons.play_arrow_rounded;
      default:
        return Icons.lock_outline;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'Completed':
        return 'DONE';
      case 'In Progress':
        return 'RESUME';
      case 'Opened':
        return 'START';
      default:
        return 'LOCKED';
    }
  }

  Color _statusColor(String status, AppColorTheme t) {
    switch (status) {
      case 'Completed':
        return t.success;
      case 'In Progress':
        return t.primary;
      case 'Opened':
        return Colors.orange;
      case 'Locked':
      default:
        return t.textMuted;
    }
  }

  Color _backgroundColor(String status, AppColorTheme t) {
    switch (status) {
      case 'Completed':
        return t.success.withValues(alpha: 0.06);
      case 'In Progress':
        return t.primary.withValues(alpha: 0.05);
      case 'Opened':
        return t.card;
      // return Colors.orange.withValues(alpha: 0.05);
      case 'Locked':
      default:
        return t.surface;
    }
  }

  Color _borderColor(String status, AppColorTheme t) {
    switch (status) {
      case 'Completed':
        return const Color(0xFFB9E2BF);
      case 'In Progress':
        return t.primary;
      case 'Opened':
        return t.border;
      default:
        return t.border;
    }
  }

  Color _iconBackground(String status, AppColorTheme t) {
    switch (status) {
      case 'Completed':
        return Colors.green.shade700;
      case 'In Progress':
        return t.primary;
      case 'Opened':
        return Colors.blueGrey.shade200;
      default:
        return Colors.grey;
    }
  }

  Color _statusTextColor(String status, AppColorTheme t) {
    switch (status) {
      case 'Completed':
        return Colors.green.shade700;
      case 'In Progress':
        return t.primary;
      case 'Opened':
        return Colors.grey.shade300;
      default:
        return Colors.grey;
    }
  }
}
