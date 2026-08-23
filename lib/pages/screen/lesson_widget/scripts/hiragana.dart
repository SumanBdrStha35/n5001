import 'package:flutter/material.dart';
import 'package:n5001/pages/screen/all_lesson_screen.dart';

import '../../../../data/hr_lesson_repository.dart';
import '../../../../data/isar_service.dart';
import '../../../../model/sript_data.dart';
import '../../../../model/sript_lesson.dart';
import '../../character_detail_screen.dart';
import 'widgets/header_card.dart';
import 'widgets/lesson_list.dart';

class HiraganaPage extends StatefulWidget {
  final List<LessonData> lessons;
  final bool isLoading;
  final Function? onProgressUpdate;

  const HiraganaPage({
    super.key,
    required this.lessons,
    required this.isLoading,
    this.onProgressUpdate,
  });

  @override
  State<HiraganaPage> createState() => _HiraganaPageState();
}

class _HiraganaPageState extends State<HiraganaPage> {
  late LessonRepository _lessonRepo;
  List<LessonData> _lessons = [];
  ScriptSummary _summary = const ScriptSummary(
    title: 'Hiragana',
    totalCharacters: 0,
    totalLessons: 0,
    completedLessons: 0,
    progress: 0,
    actionText: 'Start Learning',
  );
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _lessons = widget.lessons;
    _initRepo();
  }

  Future<void> _initRepo() async {
    _lessonRepo = LessonRepository(isar: await IsarService.instance);
    await _refreshData();
  }

  Future<void> _refreshData() async {
    if (!mounted) return;

    // Don't show loading indicator to avoid flicker
    // setState(() => _isLoading = true);

    try {
      final summary = await _lessonRepo.getScriptSummary(
        scriptType: ScriptType.hiragana,
      );
      final lessons = await _lessonRepo.getLessons(
        scriptType: ScriptType.hiragana,
      );

      if (!mounted) return;

      setState(() {
        _lessons = lessons;
        _summary = summary;
        _isLoading = false; // Only set this if you set it to true above
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Handle error
    }

    if (widget.onProgressUpdate != null) {
      widget.onProgressUpdate!();
    }
  }

  @override
  void didUpdateWidget(HiraganaPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessons != widget.lessons) {
      _lessons = widget.lessons;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        HeaderCard(
          summary: _summary,
          lessons: _lessons,
          onPressed: () => _handleContinueOrStart(),
          onViewAll: () => _handleViewAll(),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: LessonList(
            lessons: _lessons,
            isLoading: false,
            scriptType: ScriptType.hiragana,
            onLessonUpdated: _refreshData,
          ),
        ),
      ],
    );
  }

  void _handleContinueOrStart() {
    // Find the next uncompleted lesson
    final nextLesson = _summary.nextLesson;
    if (nextLesson != null) {
      // Navigate to the lesson detail
      navigateToCharacterDetail(
        context: context,
        character: nextLesson.title,
        scriptType: ScriptType.hiragana,
        lesson: nextLesson,
      ).then((result) {
        if (result == true) {
          _refreshData();
        }
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Opening: ${nextLesson.section}')));
    } else if (_summary.isCompleted) {
      // All lessons completed - show review option
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All lessons completed! Time to review! 🎉'),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No lessons available')));
    }
  }

  void _handleViewAll() {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('View all ${_lessons.length} lessons')),
    // );
    // navigate to all_lesson_screen.dar
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AllLessonScreen(lessons: _lessons, scriptType: ScriptType.hiragana),
      ),
    ).then((_) {
      // Refresh data when coming back from AllLessonsPage
      _refreshData();
    });
  }
}
