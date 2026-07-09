import 'package:flutter/material.dart';

import '../../other/app_colors.dart';
import '../../other/app_colors_theme.dart';
import '../../service/user_profile_service.dart';

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
              _buildHeader(),
              const SizedBox(height: 20),
              _buildStreakCard(),
              const SizedBox(height: 16),
              _buildLessonCard(),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'おはようございます',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            FutureBuilder<String?>(
              future: const UserProfileService().getCurrentUser().then(
                (u) => u?.username,
              ),
              builder: (context, snapshot) {
                final username = snapshot.data?.trim();
                final displayName = (username == null || username.isEmpty)
                    ? 'Aryan'
                    : username;

                return Text(
                  'Good morning, $displayName',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.indigoPrimary,
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.black87,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: AppColors.black87,
              ),
              onPressed: () {},
            ),
            FutureBuilder<String?>(
              future: const UserProfileService().getCurrentUser().then(
                (u) => u?.username,
              ),
              builder: (context, snapshot) {
                final username = snapshot.data?.trim() ?? '';
                final initial = username.isNotEmpty
                    ? username.characters.first.toUpperCase()
                    : 'S';

                return CircleAvatar(
                  backgroundColor: AppColorsTheme.primary(context),
                  radius: 18,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakCard() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final activeDays = [true, true, true, false, false, false, false];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black54Pure.withValues(alpha: 0.05),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '12',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.amberStreak,
                    ),
                  ),
                  const Text(
                    'DAY STREAK',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black54,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(days.length, (index) {
                  final isActive = activeDays[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: isActive
                          ? AppColors.amberStreak
                          : AppColors.black26Pure,
                      child: Text(
                        days[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.white : AppColors.black38,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'XP 340 / 500',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black87,
                ),
              ),
              Text(
                'Lv. 4',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 340 / 500,
              backgroundColor: AppColors.progressBg,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.amberStreak,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard() {
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
                child: const Text(
                  'KANJI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
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
          const Text(
            'Lesson 4 — Nature kanji',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.indigoPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '山、川、木、火、水',
            style: TextStyle(fontSize: 16, color: AppColors.black38),
          ),
          const SizedBox(height: 14),
          const Text(
            '3 / 8 topics',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 3 / 8,
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
