import 'package:flutter/material.dart';

import '../../../other/app_colors.dart';

class HomeLessonCard extends StatelessWidget {
  const HomeLessonCard({
    super.key,
    required this.category,
    required this.lessonTitle,
    required this.previewText,
    required this.completedTopics,
    required this.totalTopics,
    required this.onContinuePressed,
  });

  final String category;
  final String lessonTitle;
  final String previewText;
  final int completedTopics;
  final int totalTopics;
  final VoidCallback onContinuePressed;

  @override
  Widget build(BuildContext context) {
    final double progressValue = totalTopics > 0
        ? completedTopics / totalTopics
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blueBrand.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black54Pure.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueBrand,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onContinuePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.indigoPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            lessonTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.indigoPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            previewText,
            style: const TextStyle(fontSize: 16, color: AppColors.black38),
          ),
          const SizedBox(height: 14),
          Text(
            '$completedTopics / $totalTopics topics',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: AppColors.lessonProgressBg,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.blueBrand,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
