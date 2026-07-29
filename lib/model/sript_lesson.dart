import 'package:flutter/material.dart';

/// Represents a single lesson (a section/group of characters).
class LessonData {
  /// Section title e.g. "Vowels (あいうえお)"
  final String section;

  /// Description of the lesson
  final String description;

  /// Characters in this lesson as a map: character -> romaji
  final Map<String, String> characters;

  /// Ordered list of character keys
  final List<String> characterKeys;

  /// Status text: "Opened", "Locked", "In Progress", "Completed"
  final String statusText;

  /// Icon for status
  final IconData icon;

  /// Unique identifier for progress tracking
  final String lessonId;

  const LessonData({
    required this.section,
    required this.description,
    required this.characters,
    required this.characterKeys,
    required this.statusText,
    required this.icon,
    required this.lessonId,
  });

  /// Convenience getter for the first character title
  String get title => characterKeys.isNotEmpty ? characterKeys.first : '';

  /// Convenience getter for romaji of first character
  String get subtitle =>
      characterKeys.isNotEmpty ? characters[characterKeys.first] ?? '' : '';

  /// Number of characters in this lesson
  int get characterCount => characters.length;
}
