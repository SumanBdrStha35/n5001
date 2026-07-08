import 'package:flutter/material.dart';

import '../onboarding_screen.dart';
import '../../other/app_colors_theme.dart';

import '../../other/app_sizes.dart';

class StudyPlanPage extends StatelessWidget {
  final OnboardingData data;
  final Function(OnboardingData) onUpdate;

  const StudyPlanPage({super.key, required this.data, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.lg),

          Text(
            'Your personalized\nstudy plan is ready! 🗓️',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColorsTheme.textPrimary(context),
              height: 1.3,
            ),
          ),

          const SizedBox(height: AppSizes.sm),

          Text(
            'Here\'s what your N5 journey looks like:',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColorsTheme.textSecondary(context),
            ),
          ),

          const SizedBox(height: AppSizes.xl),

          // Study Plan Summary Card
          _StudyPlanSummaryCard(data: data),

          const SizedBox(height: AppSizes.lg),

          // Weekly Plan
          const _WeeklyPlanCard(),

          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Study Plan Summary
// ─────────────────────────────────────────────────────────────────────────────

class _StudyPlanSummaryCard extends StatelessWidget {
  final OnboardingData data;
  const _StudyPlanSummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColorsTheme.primary(context),
            AppColorsTheme.primaryDark(context),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColorsTheme.primary(context).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _PlanStat(
                value: '${data.studyMinutesPerDay ?? 15}',
                unit: 'min/day',
                label: 'Study Time',
                icon: '⏰',
              ),
              const _VerticalDivider(),
              _PlanStat(
                value: _getLevelShort(data.selectedLevel),
                unit: 'level',
                label: 'Starting From',
                icon: '📊',
              ),
              const _VerticalDivider(),
              _PlanStat(
                value: _getEstimatedWeeks(data.studyMinutesPerDay),
                unit: 'weeks',
                label: 'To N5 Ready',
                icon: '🎯',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLevelShort(String? level) {
    switch (level) {
      case 'Complete beginner':
        return '0';
      case 'Know Hiragana':
        return 'H';
      case 'Know Hiragana + Katakana':
        return 'HK';
      case 'Know basic words':
        return 'W';
      case 'Already studied N5 before':
        return 'N5';
      default:
        return '0';
    }
  }

  String _getEstimatedWeeks(String? minutes) {
    final minutesValue = int.tryParse(minutes ?? '15');
    if (minutesValue == null) return '~12';
    if (minutesValue >= 60) return '~6';
    if (minutesValue >= 30) return '~10';
    if (minutesValue >= 15) return '~14';
    if (minutesValue >= 10) return '~18';
    return '~24';
  }
}

class _PlanStat extends StatelessWidget {
  final String value;
  final String unit;
  final String label;
  final String icon;

  const _PlanStat({
    required this.value,
    required this.unit,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              TextSpan(
                text: '\n$unit',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 60,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Weekly Plan
// ─────────────────────────────────────────────────────────────────────────────

class _WeeklyPlanCard extends StatelessWidget {
  const _WeeklyPlanCard();

  final List<_WeekPlanItem> _plan = const [
    _WeekPlanItem(week: 'Week 1–2', topic: 'Hiragana & Katakana', icon: '🔤'),
    _WeekPlanItem(week: 'Week 3–5', topic: 'Basic Kanji (100)', icon: '🈶'),
    _WeekPlanItem(week: 'Week 6–8', topic: 'Core Vocabulary', icon: '📝'),
    _WeekPlanItem(week: 'Week 9–11', topic: 'N5 Grammar', icon: '📖'),
    _WeekPlanItem(week: 'Week 12+', topic: 'Mock Tests & Review', icon: '🎯'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      decoration: BoxDecoration(
        color: AppColorsTheme.surface(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColorsTheme.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📅 Your Learning Path',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColorsTheme.textPrimary(context),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          ..._plan.map((item) => _WeekPlanRow(item: item)),
        ],
      ),
    );
  }
}

class _WeekPlanItem {
  final String week;
  final String topic;
  final String icon;

  const _WeekPlanItem({
    required this.week,
    required this.topic,
    required this.icon,
  });
}

class _WeekPlanRow extends StatelessWidget {
  final _WeekPlanItem item;

  const _WeekPlanRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(item.icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.topic,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColorsTheme.textPrimary(context),
                  ),
                ),
                Text(
                  item.week,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColorsTheme.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
