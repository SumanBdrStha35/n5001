import 'package:flutter/material.dart';

import '../onboarding_screen.dart';
import '../../other/app_colors_theme.dart';
import '../../other/app_sizes.dart';

class LevelPage extends StatelessWidget {
  final OnboardingData data;
  final Function(OnboardingData) onUpdate;

  const LevelPage({super.key, required this.data, required this.onUpdate});

  static const List<_LevelOption> _levels = [
    _LevelOption(
      emoji: '🌱',
      title: 'Complete Beginner',
      subtitle: 'Never studied Japanese before',
      tag: 'beginner',
    ),
    _LevelOption(
      emoji: '📚',
      title: 'Know Hiragana/Katakana',
      subtitle: 'Can read kana but limited vocabulary',
      tag: 'elementary',
    ),
    _LevelOption(
      emoji: '⚡',
      title: 'Some N5 Knowledge',
      subtitle: 'Studied before, need to review',
      tag: 'intermediate',
    ),
    _LevelOption(
      emoji: '🎯',
      title: 'Ready to Test',
      subtitle: 'Strong N5 base, want practice exams',
      tag: 'advanced',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.lg),

          Text(
            "What's your current\nJapanese level? 📊",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColorsTheme.textPrimary(context),
              height: 1.3,
            ),
          ),

          const SizedBox(height: AppSizes.sm),

          Text(
            "We'll customize your study path based on this.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColorsTheme.textSecondary(context),
            ),
          ),

          const SizedBox(height: AppSizes.xl),

          // Level Cards
          ...List.generate(_levels.length, (index) {
            final level = _levels[index];
            final isSelected = data.selectedLevel == level.tag;

            return _LevelCard(
              level: level,
              isSelected: isSelected,
              levelNumber: index + 1,
              onTap: () {
                onUpdate(data.copy(selectedLevel: level.tag));
              },
            );
          }),
        ],
      ),
    );
  }
}

class _LevelOption {
  final String emoji;
  final String title;
  final String subtitle;
  final String tag;

  const _LevelOption({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.tag,
  });
}

class _LevelCard extends StatelessWidget {
  final _LevelOption level;
  final bool isSelected;
  final int levelNumber;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.isSelected,
    required this.levelNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColorsTheme.primary(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: isSelected
            ? primary.withValues(alpha: 0.1)
            : AppColorsTheme.surface(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isSelected ? primary : AppColorsTheme.border(context),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Row(
            children: [
              // Level Badge
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [primary, primary.withValues(alpha: 0.7)],
                        )
                      : null,
                  color: isSelected
                      ? null
                      : AppColorsTheme.surfaceVariant(context),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Center(
                  child: Text(
                    level.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),

              const SizedBox(width: AppSizes.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level $levelNumber · ${level.title}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? primary
                            : AppColorsTheme.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      level.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColorsTheme.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),

              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.0,
                child: Icon(Icons.check_circle_rounded, color: primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
