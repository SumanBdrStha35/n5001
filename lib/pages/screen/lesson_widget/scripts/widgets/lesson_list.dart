import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';

import '../../../../../data/hr_lesson_repository.dart';
import '../../../../../model/sript_lesson.dart';
import '../../../character_detail_screen.dart';
import 'lesson_card.dart';

class LessonList extends StatefulWidget {
  final List<LessonData> lessons;
  final bool isLoading;
  final ScriptType scriptType;
  final VoidCallback? onLessonUpdated;

  const LessonList({
    super.key,
    required this.lessons,
    required this.isLoading,
    required this.scriptType,
    this.onLessonUpdated,
  });

  @override
  State<LessonList> createState() => _LessonListState();
}

class _LessonListState extends State<LessonList> {
  late final LessonRepository _lessonRepo;
  List<LessonData> _lessons = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final isar = Isar.getInstance();
    if (isar == null) {
      throw Exception('Isar is not initialized');
    }
    _lessonRepo = LessonRepository(isar: isar);
    _lessons = widget.lessons; // Initialize with widget lessons
  }

  @override
  void didUpdateWidget(LessonList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessons != widget.lessons) {
      setState(() {
        _lessons = widget.lessons;
      });
    }
  }

  Future<void> _refreshLessons() async {
    Logger().d('Refreshing lesson list...');
    final updatedLessons = await _lessonRepo.getLessons(
      scriptType: widget.scriptType,
    );

    for (final lesson in updatedLessons) {
      Logger().d('${lesson.lessonId} => ${lesson.statusText}');
    }

    if (!mounted) return;

    setState(() {
      _lessons = updatedLessons;
    });

    // Notify parent to refresh its data as well
    if (widget.onLessonUpdated != null) {
      widget.onLessonUpdated!();
    }
  }

  Future<void> _handleLessonComplete(LessonData lesson) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Lesson'),
        content: Text('Mark "${lesson.section}" as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Complete'),
          ),
        ],
      ),
    );

    if (result == true) {
      // Show loading indicator
      setState(() => _isLoading = true);

      // Complete the lesson
      await _lessonRepo.completeLesson(
        lessonId: lesson.lessonId,
        scriptType: widget.scriptType,
      );

      await _refreshLessons();

      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lesson "${lesson.section}" completed! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_lessons.isEmpty) {
      return const Center(child: Text('No lessons available'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: _lessons.length,
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        final isOpened = lesson.statusText == 'Opened';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LessonCard(
            lesson: lesson,
            lessonNumber: index + 1,
            showCompleteButton: isOpened,
            onTap: () async {
              if (lesson.statusText == 'Locked') return;

              final result = await navigateToCharacterDetail(
                context: context,
                character: lesson.title,
                scriptType: widget.scriptType,
                lesson: lesson,
              );
              // This will be true when the lesson is completed from the detail screen
              if (result == true) {
                await _refreshLessons();
              }
            },
            onComplete: () => _handleLessonComplete(lesson),
          ),
        );
      },
    );
  }
}
