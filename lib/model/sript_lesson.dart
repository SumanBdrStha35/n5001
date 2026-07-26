import 'package:flutter/material.dart';

class LessonData {
  final String title; // The character itself e.g. "あ"
  final String subtitle; // Romaji e.g. "a"
  final String statusText; // "Opened", "Locked", "In Progress", "Completed"
  final IconData icon;
  final String section; // Section name for grouping e.g. "Vowels (あいうえお)"
  final String lessonId; // Unique identifier for progress tracking

  const LessonData({
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.icon,
    required this.section,
    required this.lessonId,
  });
}
