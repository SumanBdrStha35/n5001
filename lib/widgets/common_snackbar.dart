import 'package:flutter/material.dart';

class CommonSnackBar {
  const CommonSnackBar._();

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(context, message, type: _SnackBarType.success, duration: duration);
  }

  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(context, message, type: _SnackBarType.error, duration: duration);
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(context, message, type: _SnackBarType.info, duration: duration);
  }

  static void show(
    BuildContext context,
    String message, {
    required _SnackBarType type,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      CommonSnackBarContent(message: message, type: type, duration: duration),
    );
  }
}

class CommonSnackBarContent extends SnackBar {
  CommonSnackBarContent({
    super.key,
    required String message,
    required _SnackBarType type,
    Duration? duration,
  }) : super(
         duration: duration ?? const Duration(seconds: 3),
         content: _SnackBarBody(message: message, type: type),
         backgroundColor: _backgroundColorFor(type),
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
         margin: const EdgeInsets.all(12),
       );
}

class _SnackBarBody extends StatelessWidget {
  const _SnackBarBody({required this.message, required this.type});

  final String message;
  final _SnackBarType type;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final iconData = switch (type) {
      _SnackBarType.success => Icons.check_circle_rounded,
      _SnackBarType.error => Icons.error_rounded,
      _SnackBarType.info => Icons.info_rounded,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, color: colorScheme.onSurface, size: 20),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

enum _SnackBarType { success, error, info }

Color _backgroundColorFor(_SnackBarType type) {
  return switch (type) {
    _SnackBarType.success => Colors.green,
    _SnackBarType.error => Colors.red,
    _SnackBarType.info => Colors.blue,
  };
}
