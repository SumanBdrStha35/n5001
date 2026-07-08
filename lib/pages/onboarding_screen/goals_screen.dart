import 'package:flutter/material.dart';
import '../onboarding_screen.dart';
import '../../other/app_sizes.dart';
import '../../other/app_colors_theme.dart';

class GoalPage extends StatelessWidget {
  final OnboardingData data;
  final Function(OnboardingData) onUpdate;

  const GoalPage({super.key, required this.data, required this.onUpdate});

  static const List<GoalOption> goals = [
    GoalOption(
      emoji: '🎌',
      title: 'Pass JLPT N5',
      subtitle: 'Prepare and ace the official exam',
    ),
    GoalOption(
      emoji: '✈️',
      title: 'Travel to Japan',
      subtitle: 'Communicate confidently while traveling',
    ),
    GoalOption(
      emoji: '🎮',
      title: 'Enjoy Anime & Manga',
      subtitle: 'Understand Japanese pop culture',
    ),
    GoalOption(
      emoji: '💼',
      title: 'Work or Study in Japan',
      subtitle: 'Build professional language skills',
    ),
    GoalOption(
      emoji: '❤️',
      title: 'Personal Interest',
      subtitle: 'Just love the Japanese language',
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
            'Why are you learning\nJapanese? 🤔',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColorsTheme.textPrimary(context),
              height: 1.3,
            ),
          ),

          const SizedBox(height: AppSizes.sm),

          Text(
            'This helps us personalize your learning path.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColorsTheme.textSecondary(context),
            ),
          ),

          const SizedBox(height: AppSizes.xl),

          ...goals.map(
            (goal) => GoalCard(
              goal: goal,
              isSelected: data.selectedGoal == goal.title,
              onTap: () {
                onUpdate(data.copy(selectedGoal: goal.title));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GoalOption {
  final String emoji;
  final String title;
  final String subtitle;

  const GoalOption({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });
}

class GoalCard extends StatelessWidget {
  final GoalOption goal;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalCard({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColorsTheme.primarySoft(context)
            : AppColorsTheme.surface(context),

        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isSelected
              ? AppColorsTheme.primary(context)
              : AppColorsTheme.border(context),

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
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColorsTheme.primary(context).withValues(alpha: 0.15)
                      : AppColorsTheme.surfaceVariant(context),

                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Center(
                  child: Text(goal.emoji, style: const TextStyle(fontSize: 24)),
                ),
              ),

              const SizedBox(width: AppSizes.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColorsTheme.primary(context)
                            : AppColorsTheme.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColorsTheme.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),

              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColorsTheme.primary(context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
