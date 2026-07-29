import 'package:flutter/material.dart';

import '../other/app_colors_theme.dart';

class AppCardContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double borderWidth;
  final double elevation;

  const AppCardContainer({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(9),
    this.margin = const EdgeInsets.symmetric(vertical: 0),
    this.borderRadius = 16,
    this.borderWidth = 1,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);

    final card = Material(
      elevation: elevation,
      color: backgroundColor ?? Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.grey.shade300,
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
    return card;
    // return Container(
    //   // padding: padding,
    //   decoration: BoxDecoration(
    //     color: t.card,
    //     borderRadius: borderRadius,
    //     border: Border.all(color: t.border, width: borderWidth),
    //   ),
    //   child: child,
    // );
  }
}
