import 'package:flutter/material.dart';

import '../../../../data/hr_lesson_repository.dart';
import '../../../../data/isar_service.dart';
import '../../../../model/sript_data.dart';
import '../../../../model/sript_lesson.dart';
import 'widgets/header_card.dart';
import 'widgets/lesson_list.dart';

class KatakanaPage extends StatefulWidget {
  final List<LessonData> lessons;
  final bool isLoading;
  final Function? onProgressUpdate;

  const KatakanaPage({
    super.key,
    required this.lessons,
    required this.isLoading,
    this.onProgressUpdate,
  });

  @override
  State<KatakanaPage> createState() => _KatakanaPageState();
}

class _KatakanaPageState extends State<KatakanaPage> {
  late LessonRepository _lessonRepo;
  List<LessonData> _lessons = [];
  ScriptSummary _summary = const ScriptSummary(
    title: 'Katakana',
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

    setState(() => _isLoading = true);

    final summary = await _lessonRepo.getScriptSummary(
      scriptType: ScriptType.katakana,
    );
    final lessons = await _lessonRepo.getLessons(
      scriptType: ScriptType.katakana,
    );

    if (!mounted) return;

    setState(() {
      _lessons = lessons;
      _summary = summary;
      _isLoading = false;
    });

    if (widget.onProgressUpdate != null) {
      widget.onProgressUpdate!();
    }
  }

  @override
  void didUpdateWidget(KatakanaPage oldWidget) {
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
            scriptType: ScriptType.katakana,
            onLessonUpdated: _refreshData,
          ),
        ),
      ],
    );
  }

  void _handleContinueOrStart() {
    final nextLesson = _summary.nextLesson;
    if (nextLesson != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Opening: ${nextLesson.section}')));
    } else if (_summary.isCompleted) {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View all ${_lessons.length} lessons')),
    );
  }
}
