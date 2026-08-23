import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../data/hr_lesson_repository.dart';

/// Represents a single lesson (a section/group of characters).
@embedded
class LessonData {
  String section;
  String description;
  Map<String, String> characters;
  List<String> characterKeys;
  String statusText;
  IconData icon;
  String lessonId;

  // New fields for easier navigation
  ScriptType? scriptType;
  int? lessonNumber;

  LessonData({
    this.section = '',
    this.description = '',
    this.characters = const {},
    this.characterKeys = const [],
    this.statusText = 'Locked',
    this.icon = Icons.lock_outline,
    this.lessonId = '',
    this.scriptType,
    this.lessonNumber,
  });

  /// Convenience getter for the first character title
  String get title => characterKeys.isNotEmpty ? characterKeys.first : '';

  /// Convenience getter for romaji of first character
  String get subtitle =>
      characterKeys.isNotEmpty ? characters[characterKeys.first] ?? '' : '';

  /// Number of characters in this lesson
  int get characterCount => characters.length;
}
