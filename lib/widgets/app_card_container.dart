import 'package:flutter/material.dart';

import '../other/app_colors_theme.dart';

/// Generic card container to wrap any screen section.
///
/// Uses [AppColorsTheme] for background/border colors so it stays consistent
/// across the app.
class AppCardContainer extends StatelessWidget {
  const AppCardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.borderWidth = 1.5,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);

    return Container(
      // padding: padding,
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: borderRadius,
        border: Border.all(color: t.border, width: borderWidth),
      ),
      child: child,
    );
  }
}
