import 'package:flutter/material.dart';

import '../../../../../model/sript_lesson.dart';
import '../../../../../other/app_colors_theme.dart';
import '../../../../../widgets/app_card_container.dart';

class LessonCard extends StatelessWidget {
  final LessonData lesson;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final int lessonNumber;
  final bool showCompleteButton;

  const LessonCard({
    super.key,
    required this.lesson,
    this.onTap,
    this.onComplete,
    required this.lessonNumber,
    this.showCompleteButton = false,
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
                      // 'Lesson $lessonNumber',
                      '$lesson.lessonId',
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
              // if (showCompleteButton && status == 'Opened')
              if (!showCompleteButton || status != 'Opened')
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

  Color _backgroundColor(String status, AppColorTheme t) {
    switch (status) {
      case 'Completed':
        return t.success.withValues(alpha: 0.06);
      case 'In Progress':
        return t.primary.withValues(alpha: 0.05);
      case 'Opened':
        return t.card;
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
        return t.primary.withValues(alpha: 0.3);
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
        return t.primary;
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
        return t.primary;
      default:
        return Colors.grey;
    }
  }
}
