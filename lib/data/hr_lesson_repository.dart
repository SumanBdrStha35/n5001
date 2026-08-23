import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';

import '../model/sript_data.dart';
import '../model/sript_lesson.dart';
import 'hr_lesson_progress.dart';

/// Supported Japanese scripts for lessons.
enum ScriptType { hiragana, katakana }

/// Provides lesson definitions (from JSON) merged with user progress (from Isar).
class LessonRepository {
  LessonRepository({required this.isar});

  final Isar isar;

  /// Loads lesson metadata from the appropriate bundled JSON asset
  /// based on the given [scriptType].
  ///
  /// Returns a list where each item corresponds to one section/lesson,
  /// containing all characters grouped together.
  Future<List<Map<String, dynamic>>> _loadLessonDefinitions(
    ScriptType scriptType,
  ) async {
    final String assetPath;
    final String jsonKey;

    switch (scriptType) {
      case ScriptType.hiragana:
        assetPath = 'assets/data/hiragana.json';
        jsonKey = 'hiraganaLessons';
        break;
      case ScriptType.katakana:
        assetPath = 'assets/data/katakana.json';
        jsonKey = 'katakanaLessons';
        break;
    }

    final jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> decoded =
        json.decode(jsonString) as Map<String, dynamic>;
    final List<dynamic> sections = decoded[jsonKey] as List<dynamic>;

    final scriptPrefix = scriptType.name; // e.g. "hiragana" or "katakana"
    final List<Map<String, dynamic>> result = [];

    for (int sectionIdx = 0; sectionIdx < sections.length; sectionIdx++) {
      final section = sections[sectionIdx] as Map<String, dynamic>;
      final sectionTitle = section['title'] as String? ?? '';
      final description = section['description'] as String? ?? '';
      final characters = section['characters'] as Map<String, dynamic>? ?? {};

      // Sort characters to maintain a consistent order
      final sortedKeys = characters.keys.toList();
      final Map<String, String> charMap = {};
      for (final char in sortedKeys) {
        final charData = characters[char] as Map<String, dynamic>;
        final romaji = charData['romaji'] as String? ?? '';
        charMap[char] = romaji;
      }

      result.add({
        'id': '${scriptPrefix}_lesson_${sectionIdx + 1}',
        'section': sectionTitle,
        'description': description,
        'characters': charMap,
        'characterKeys': sortedKeys,
        'sectionIdx': sectionIdx,
      });
    }

    return result;
  }

  /// Fetches persisted progress for all lessons.
  Future<Map<String, String>> _loadProgressMap() async {
    final records = await isar.lessonProgress.where().findAll();
    return {for (final r in records) r.lessonId: r.status};
  }

  /// Returns merged lesson list with progress for the given [scriptType].
  Future<List<LessonData>> getLessons({
    ScriptType scriptType = ScriptType.hiragana,
  }) async {
    final definitions = await _loadLessonDefinitions(scriptType);
    final progressMap = await _loadProgressMap();
    final scriptPrefix = scriptType.name;

    return definitions.asMap().entries.map((entry) {
      final idx = entry.key;
      final def = entry.value;
      final id = def['id'] as String;

      // Get status from progress map or determine default
      String status;
      if (progressMap.containsKey(id)) {
        status = progressMap[id]!;
      } else if (idx == 0) {
        // First lesson always starts as 'Opened'
        status = 'Opened';
      } else {
        // Check if previous lesson is completed to unlock this one
        bool previousCompleted = false;
        if (idx > 0) {
          final prevId = '${scriptPrefix}_lesson_$idx';
          final prevStatus = progressMap[prevId] ?? 'Locked';
          previousCompleted = prevStatus == 'Completed';
        }
        status = previousCompleted ? 'Opened' : 'Locked';
      }

      return LessonData(
        section: def['section'] as String? ?? '',
        description: def['description'] as String? ?? '',
        characters: (def['characters'] as Map<String, String>?) ?? {},
        characterKeys: (def['characterKeys'] as List<String>?) ?? [],
        statusText: status,
        icon: _iconFromStatus(status),
        lessonId: id,
        // Add these fields for easier navigation
        scriptType: scriptType,
        lessonNumber: idx + 1,
      );
    }).toList();
  }

  /// Get a specific lesson by ID
  Future<LessonData?> getLessonById({
    required String lessonId,
    required ScriptType scriptType,
  }) async {
    final lessons = await getLessons(scriptType: scriptType);
    try {
      return lessons.firstWhere((l) => l.lessonId == lessonId);
    } catch (_) {
      return null;
    }
  }

  /// Get the next lesson ID and status
  Future<Map<String, dynamic>?> getNextLessonInfo({
    required String currentLessonId,
    required ScriptType scriptType,
  }) async {
    final lessons = await getLessons(scriptType: scriptType);
    final currentIndex = lessons.indexWhere(
      (l) => l.lessonId == currentLessonId,
    );

    if (currentIndex >= 0 && currentIndex < lessons.length - 1) {
      final nextLesson = lessons[currentIndex + 1];
      return {
        'lessonId': nextLesson.lessonId,
        'status': nextLesson.statusText,
        'lessonNumber': nextLesson.lessonNumber,
        'section': nextLesson.section,
      };
    }
    return null;
  }

  /// Get first uncompleted lesson
  Future<LessonData?> getFirstUncompletedLesson({
    required ScriptType scriptType,
  }) async {
    final lessons = await getLessons(scriptType: scriptType);
    // Find first lesson that is not completed
    final uncompleted = lessons
        .where((l) => l.statusText != 'Completed')
        .toList();
    return uncompleted.isNotEmpty ? uncompleted.first : null;
  }

  /// Updates (or inserts) the progress for a given lesson.
  Future<void> updateProgress({
    required String lessonId,
    required String status,
  }) async {
    await isar.writeTxn(() async {
      final existing = await isar.lessonProgress
          .filter()
          .lessonIdEqualTo(lessonId)
          .findFirst();

      if (existing != null) {
        existing.status = status;
        await isar.lessonProgress.put(existing);
      } else {
        final record = LessonProgress()
          ..lessonId = lessonId
          ..status = status;
        await isar.lessonProgress.put(record);
      }
    });
  }

  /// Mark a lesson as completed and unlock the next one
  Future<void> completeLesson({
    required String lessonId,
    required ScriptType scriptType,
  }) async {
    Logger().d(
      "Completing lesson: $lessonId",
    ); //Completing lesson: hiragana_lesson_4
    // Mark current lesson as completed
    await updateProgress(lessonId: lessonId, status: 'Completed');
    Logger().d(
      'Marked $lessonId as Completed',
    ); //Completing lesson: hiragana_lesson_4
    // Get all lessons to find the next one
    final allLessons = await getLessons(scriptType: scriptType);
    final currentIndex = allLessons.indexWhere(
      (lesson) => lesson.lessonId == lessonId,
    );
    Logger().d('Current lesson index: $currentIndex');
    if (currentIndex == -1) {
      Logger().e('Could not find lesson: $lessonId');
      return;
    }
    // Unlock next lesson
    if (currentIndex >= 0 && currentIndex < allLessons.length - 1) {
      Logger().d("Completing lesson: $currentIndex"); //Completing lesson: 3
      final nextLesson = allLessons[currentIndex + 1];
      Logger().d(
        'Next lesson: ${nextLesson.lessonId}',
      ); //Completing lesson: Instance of 'LessonData'
      Logger().d('Next lesson status: ${nextLesson.statusText}');
      if (nextLesson.statusText == 'Locked') {
        await updateProgress(lessonId: nextLesson.lessonId, status: 'Opened');
        Logger().d('Unlocked lesson: ${nextLesson.lessonId}');
      }
    }
    // Reload lessons after unlocking so summary uses latest data.
    final updatedLessons = await getLessons(scriptType: scriptType);

    // Calculate summary from latest data
    final totalLessons = updatedLessons.length;
    final completedLessons = updatedLessons
        .where((lesson) => lesson.statusText == 'Completed')
        .length;

    final inProgressLessons = updatedLessons
        .where((lesson) => lesson.statusText == 'In Progress')
        .length;

    final openedLessons = updatedLessons
        .where((lesson) => lesson.statusText == 'Opened')
        .length;

    final progress = totalLessons == 0 ? 0.0 : completedLessons / totalLessons;
  }

  /// Get summary statistics for a script
  Future<ScriptSummary> getScriptSummary({
    required ScriptType scriptType,
  }) async {
    final lessons = await getLessons(scriptType: scriptType);
    final totalLessons = lessons.length;
    final completed = lessons.where((e) => e.statusText == 'Completed').length;
    final inProgress = lessons
        .where((e) => e.statusText == 'In Progress')
        .length;
    final opened = lessons.where((e) => e.statusText == 'Opened').length;

    final progress = totalLessons == 0 ? 0.0 : completed / totalLessons;
    final totalChars = lessons.fold<int>(
      0,
      (sum, lesson) => sum + lesson.characterCount,
    );

    String actionText;
    if (completed == totalLessons && totalLessons > 0) {
      actionText = 'Review';
    } else if (inProgress > 0 || opened > 0) {
      actionText = 'Continue Learning';
    } else {
      actionText = 'Start Learning';
    }

    return ScriptSummary(
      title: scriptType.name.toUpperCase(),
      totalCharacters: totalChars,
      totalLessons: totalLessons,
      completedLessons: completed,
      progress: progress,
      actionText: actionText,
      nextLesson: await getFirstUncompletedLesson(scriptType: scriptType),
    );
  }

  /// Maps lesson status to the appropriate Flutter [IconData].
  static IconData _iconFromStatus(String status) {
    switch (status) {
      case 'Completed':
        return Icons.check;
      case 'In Progress':
        return Icons.play_arrow;
      case 'Locked':
        return Icons.lock_outline;
      case 'Opened':
        return Icons.lock_open_outlined;
      default:
        return Icons.lock_outline;
    }
  }
}
