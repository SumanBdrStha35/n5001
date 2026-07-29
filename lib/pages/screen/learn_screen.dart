import 'package:flutter/material.dart';

import '../../data/hr_lesson_repository.dart';
import '../../data/isar_service.dart';
import '../../model/sript_lesson.dart';
import '../../other/app_colors_theme.dart';
import 'lesson_widget/gram/grammer.dart';
import 'lesson_widget/kanji/kanji.dart';
import 'lesson_widget/scripts/scripts_section.dart';
import 'lesson_widget/voca/vocabulary.dart';

// --- Main Body Widget ---
class JapaneseLearningBody extends StatefulWidget {
  const JapaneseLearningBody({super.key});

  @override
  State<JapaneseLearningBody> createState() => _JapaneseLearningBodyState();
}

class _JapaneseLearningBodyState extends State<JapaneseLearningBody> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Scripts', 'Kanji', 'Vocabulary', 'Grammar'];

  late final LessonRepository _lessonRepo;

  List<LessonData> _hiraganaLessons = [];
  List<LessonData> _katakanaLessons = [];
  bool _isLoadingHiragana = true;
  bool _isLoadingKatakana = true;

  @override
  void initState() {
    super.initState();
    _initRepo();
  }

  Future<void> _initRepo() async {
    final isar = await IsarService.instance;
    _lessonRepo = LessonRepository(isar: isar);
    await Future.wait([
      _loadLessons(ScriptType.hiragana, isHiragana: true),
      _loadLessons(ScriptType.katakana, isHiragana: false),
    ]);
  }

  Future<void> _loadLessons(
    ScriptType script, {
    required bool isHiragana,
  }) async {
    final lessons = await _lessonRepo.getLessons(scriptType: script);
    if (!mounted) return;
    setState(() {
      if (isHiragana) {
        _hiraganaLessons = lessons;
        _isLoadingHiragana = false;
      } else {
        _katakanaLessons = lessons;
        _isLoadingKatakana = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);

    return Column(
      children: [
        // Top Custom Tab Selector
        Container(
          color: t.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final isSelected = _selectedTab == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? t.primary : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected ? t.primary : t.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Tab Content
        Expanded(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              ScriptsSection(
                hiraganaLessons: _hiraganaLessons,
                katakanaLessons: _katakanaLessons,
                isLoadingHiragana: _isLoadingHiragana,
                isLoadingKatakana: _isLoadingKatakana,
              ),
              const KanjiSection(),
              const VocabularySection(),
              const GrammarSection(),
            ],
          ),
        ),
      ],
    );
  }
}
