import 'package:flutter/material.dart';

import '../../../../other/app_colors_theme.dart';

/// Placeholder section for Kanji learning content.
class KanjiSection extends StatelessWidget {
  const KanjiSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.abc_rounded, size: 64, color: t.textMuted),
            const SizedBox(height: 16),
            Text(
              'Kanji',
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
