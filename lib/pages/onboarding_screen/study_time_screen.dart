import 'package:flutter/material.dart';
import '../onboarding_screen.dart';
import '../../other/app_colors_theme.dart';

import '../../other/app_sizes.dart';

class StudyTimePage extends StatelessWidget {
  final OnboardingData data;
  final Function(OnboardingData) onUpdate;

  const StudyTimePage({super.key, required this.data, required this.onUpdate});

  static const List<_TimeOption> _timeOptions = [
    _TimeOption(
      minutes: 5,
      label: '5 min/day',
      emoji: '⚡',
      desc: 'Quick daily touch',
    ),
    _TimeOption(
      minutes: 10,
      label: '10 min/day',
      emoji: '🌿',
      desc: 'Light and steady',
    ),
    _TimeOption(
      minutes: 15,
      label: '15 min/day',
      emoji: '📖',
      desc: 'Recommended for beginners',
    ),
    _TimeOption(
      minutes: 30,
      label: '30 min/day',
      emoji: '🚀',
      desc: 'Serious learner',
    ),
    _TimeOption(
      minutes: 60,
      label: '1 hour/day',
      emoji: '🏆',
      desc: 'Intensive study mode',
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
            'How much time can\nyou study daily? ⏰',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColorsTheme.textPrimary(context),
              height: 1.3,
            ),
          ),

          const SizedBox(height: AppSizes.sm),

          Text(
            'Consistency beats intensity. Even 5 minutes helps!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColorsTheme.textSecondary(context),
            ),
          ),

          const SizedBox(height: AppSizes.xl),

          // Time Option Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSizes.md,
            mainAxisSpacing: AppSizes.md,
            childAspectRatio: 1.3,
            children: _timeOptions.map((option) {
              final isSelected =
                  data.studyMinutesPerDay == option.minutes.toString();
              return _TimeCard(
                option: option,
                isSelected: isSelected,
                onTap: () {
                  onUpdate(
                    data.copy(studyMinutesPerDay: option.minutes.toString()),
                  );
                },
              );
            }).toList(),
          ),

          const SizedBox(height: AppSizes.xl),

          // Motivational note
          if (data.studyMinutesPerDay != null)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: 1.0,
              child: Container(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                decoration: BoxDecoration(
                  color: AppColorsTheme.success(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: AppColorsTheme.success(
                      context,
                    ).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('🎯', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        'In 30 days, you\'ll have studied for '
                        '${((int.tryParse(data.studyMinutesPerDay ?? '0') ?? 0) * 30 / 60).toStringAsFixed(1)} hours!',
                        style: TextStyle(
                          color: AppColorsTheme.success(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimeOption {
  final int minutes;
  final String label;
  final String emoji;
  final String desc;

  const _TimeOption({
    required this.minutes,
    required this.label,
    required this.emoji,
    required this.desc,
  });
}

class _TimeCard extends StatelessWidget {
  final _TimeOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColorsTheme.primary(context).withValues(alpha: 0.12)
            : AppColorsTheme.surface(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isSelected
              ? AppColorsTheme.primary(context)
              : AppColorsTheme.border(context),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColorsTheme.primary(context).withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(option.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: AppSizes.sm),
            Text(
              option.label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColorsTheme.primary(context)
                    : AppColorsTheme.textPrimary(context),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              option.desc,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColorsTheme.textSecondary(context),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
