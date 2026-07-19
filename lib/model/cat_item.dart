import 'package:flutter/material.dart';

class CategoryItem {
  final String title;
  final String phraseCount;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const CategoryItem({
    required this.title,
    required this.phraseCount,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}
