import 'package:flutter/material.dart';

import '../../other/app_assets.dart';
import '../../other/app_colors_theme.dart';
import '../../other/app_sizes.dart';

// Backward compatible: some widgets still reference AppTheme.of(context).

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              Image.asset(
                AppAssets.onboardingWelcome,
                height: 260,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: AppSizes.xl),

              // Japanese character decoration
              Text(
                'ようこそ',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColorsTheme.primary(context),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),

              const SizedBox(height: AppSizes.md),

              Text(
                'Welcome to N5 Mastery',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColorsTheme.textPrimary(context),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.md),

              Text(
                'Your ultimate companion to passing the JLPT N5. Learn Hiragana, Katakana, Kanji, and more — at your own pace.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColorsTheme.textSecondary(context),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.xl),

              // Feature Pills
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                alignment: WrapAlignment.center,
                children: const [
                  _FeaturePill(emoji: '🎌', label: 'Hiragana & Katakana'),
                  _FeaturePill(emoji: '📖', label: 'N5 Grammar'),
                  _FeaturePill(emoji: '🎯', label: 'JLPT Mock Tests'),
                  _FeaturePill(emoji: '🔥', label: 'Daily Streaks'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String emoji;
  final String label;

  const _FeaturePill({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: AppColorsTheme.primary(context).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(
          color: AppColorsTheme.primary(context).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: AppColorsTheme.primary(context),

              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
