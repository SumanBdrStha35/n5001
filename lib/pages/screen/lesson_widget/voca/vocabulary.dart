import 'package:flutter/material.dart';

import '../../../../other/app_colors_theme.dart';

/// Placeholder section for Vocabulary learning content.
class VocabularySection extends StatelessWidget {
  const VocabularySection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded, size: 64, color: t.textMuted),
            const SizedBox(height: 16),
            Text(
              'Vocabulary',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: t.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: TextStyle(fontSize: 16, color: t.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
