import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

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
      // Check if previous lesson is completed
      bool previousCompleted = false;
      if (idx > 0) {
        final prevId = '${scriptPrefix}_lesson_$idx';
        final prevStatus = progressMap[prevId] ?? 'Locked';
        previousCompleted = prevStatus == 'Completed';
      }

      // Determine status
      String status;
      if (idx == 0) {
        // First lesson always starts as 'Opened' if not completed
        status = progressMap[id] ?? 'Opened';
      } else if (previousCompleted) {
        // If previous lesson is completed, this one is 'Opened'
        status = progressMap[id] ?? 'Opened';
      } else {
        // Otherwise locked
        status = progressMap[id] ?? 'Locked';
      }

      // // Default: first lesson is "Opened", others are "Locked"
      // final defaultStatus = (idx == 0) ? 'Opened' : 'Locked';
      // final status = progressMap[id] ?? defaultStatus;

      return LessonData(
        section: def['section'] as String? ?? '',
        description: def['description'] as String? ?? '',
        characters: (def['characters'] as Map<String, String>?) ?? {},
        characterKeys: (def['characterKeys'] as List<String>?) ?? [],
        statusText: status,
        icon: _iconFromStatus(status),
        lessonId: id,
      );
    }).toList();
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
    // Mark current lesson as completed
    await updateProgress(lessonId: lessonId, status: 'Completed');

    // Get all lessons to find the next one
    final allLessons = await getLessons(scriptType: scriptType);
    final currentIndex = allLessons.indexWhere((l) => l.lessonId == lessonId);

    // Unlock next lesson if it exists
    if (currentIndex >= 0 && currentIndex < allLessons.length - 1) {
      final nextLesson = allLessons[currentIndex + 1];
      await updateProgress(lessonId: nextLesson.lessonId, status: 'Opened');
    }
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
