import 'package:flutter/material.dart';
import 'package:n5001/pages/screen/home_widget/home_lesson.dart';
import 'package:n5001/pages/screen/home_widget/home_streak.dart';

import '../../other/app_colors.dart';
import '../../other/app_colors_theme.dart';
import 'home_widget/home_header.dart';

class _LessonDataLoader {
  const _LessonDataLoader();

  Future<Map<String, dynamic>> load() async {
    // Keeping it dynamic so UI updates are supported.
    await Future<void>.delayed(const Duration(milliseconds: 250));

    return {
      'category': 'Nature Kanji',
      'lessonTitle': 'Lesson 4 — Nature kanji',
      'previewText': '山、川、木、火、水',
      'completedTopics': 3,
      'totalTopics': 8,
    };
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(),
              const SizedBox(height: 20),
              const HomeStreak(),
              const SizedBox(height: 16),
              FutureBuilder<Map<String, dynamic>>(
                future: const _LessonDataLoader().load(),
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (data == null) {
                    return HomeLessonCard(
                      category: 'Loading',
                      lessonTitle: 'Please wait…',
                      previewText: '—',
                      completedTopics: 0,
                      totalTopics: 1,
                      onContinuePressed: () {},
                    );
                  }

                  return HomeLessonCard(
                    category: (data['category'] as String?) ?? 'Lesson',
                    lessonTitle: (data['lessonTitle'] as String?) ?? '',
                    previewText: (data['previewText'] as String?) ?? '',
                    completedTopics:
                        (data['completedTopics'] as num?)?.toInt() ?? 0,
                    totalTopics: (data['totalTopics'] as num?)?.toInt() ?? 1,
                    onContinuePressed: () {},
                  );
                },
              ),

              const SizedBox(height: 16),
              _buildVocabCard(),
              const SizedBox(height: 24),
              _buildProgressSection(),
              const SizedBox(height: 24),
              _buildQuickJump(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVocabCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.vocabCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black54Pure.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
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
                  color: AppColors.vocabTagBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.vocabTagBorder),
                ),
                child: const Text(
                  'VOCABULARY',
                  style: TextStyle(
                    color: AppColors.vocabTagText,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.flip, size: 16, color: AppColors.black54),
                  const SizedBox(width: 4),
                  const Text(
                    'tap to flip',
                    style: TextStyle(color: AppColors.black54, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            '友達',
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: AppColors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'ともだち · tomodachi',
            style: TextStyle(fontSize: 15, color: AppColors.black54),
          ),
          const SizedBox(height: 20),
          const Text(
            'Friend / close companion',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.indigoPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.black26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: AppColors.vocabIcon),
                  label: const Text(
                    'Add to practice',
                    style: TextStyle(
                      color: AppColors.vocabIcon,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.vocabIcon,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MY PROGRESS',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.black54,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildProgressItem('18', 'Lessons\ndone'),
            const SizedBox(width: 12),
            _buildProgressItem('64', 'Kanji\nlearned'),
            const SizedBox(width: 12),
            _buildProgressItem('210', 'Vocab\nlearned'),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressItem(String count, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black54Pure.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickJump() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK JUMP',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.black54,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildQuickJumpItem(Icons.text_fields, 'Scripts'),
            const SizedBox(width: 12),
            _buildQuickJumpItem(Icons.grid_view, 'Kanji'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildQuickJumpItem(Icons.menu_book_outlined, 'Vocabulary'),
            const SizedBox(width: 12),
            _buildQuickJumpItem(Icons.record_voice_over_outlined, 'Phrasebook'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickJumpItem(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black54Pure.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.blueBrand, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
