import 'package:flutter/material.dart';

/// Parses a subset of SVG path `d` data into a Flutter [Path].
///
/// Supported commands:
/// - `M` / `m`  move to
/// - `L` / `l`  line to
/// - `C` / `c`  cubic bezier curve
/// - `Z` / `z`  close path
///
/// Absolute commands use their literal coordinates while relative commands
/// (`m`, `l`, `c`) are offset by the previous current point.
Path parseSimpleSvgPath(String d) {
  final path = Path();
  if (d.trim().isEmpty) return path;

  // Tokenize: numbers and command letters.
  final pattern = RegExp(r'([MmCcLlZz])|([-\d.]+)');
  final matches = pattern.allMatches(d).toList();

  if (matches.isEmpty) return path;

  double currentX = 0;
  double currentY = 0;
  double startX = 0;
  double startY = 0;
  String? lastCommand;
  final List<double> args = [];

  void consumeCommand(String cmd, List<double> a) {
    switch (cmd) {
      case 'M':
        if (a.length >= 2) {
          currentX = a[0];
          currentY = a[1];
          startX = currentX;
          startY = currentY;
          path.moveTo(currentX, currentY);
        }
        break;
      case 'm':
        if (a.length >= 2) {
          currentX += a[0];
          currentY += a[1];
          startX = currentX;
          startY = currentY;
          path.moveTo(currentX, currentY);
        }
        break;
      case 'L':
        if (a.length >= 2) {
          currentX = a[0];
          currentY = a[1];
          path.lineTo(currentX, currentY);
        }
        break;
      case 'l':
        if (a.length >= 2) {
          currentX += a[0];
          currentY += a[1];
          path.lineTo(currentX, currentY);
        }
        break;
      case 'C':
        if (a.length >= 6) {
          path.cubicTo(a[0], a[1], a[2], a[3], a[4], a[5]);
          currentX = a[4];
          currentY = a[5];
        }
        break;
      case 'c':
        if (a.length >= 6) {
          path.cubicTo(
            currentX + a[0],
            currentY + a[1],
            currentX + a[2],
            currentY + a[3],
            currentX + a[4],
            currentY + a[5],
          );
          currentX += a[4];
          currentY += a[5];
        }
        break;
      case 'Z':
      case 'z':
        path.close();
        currentX = startX;
        currentY = startY;
        break;
    }
  }

  void applyArgs() {
    if (lastCommand == null) return;
    consumeCommand(lastCommand, args);
    args.clear();
  }

  for (final match in matches) {
    final letter = match.group(1);
    if (letter != null) {
      // A new command begins — flush any pending args of the previous one.
      applyArgs();
      lastCommand = letter;
      continue;
    }
    final numStr = match.group(2);
    if (numStr != null) {
      args.add(double.parse(numStr));
    }
  }
  // Flush trailing args (e.g. implicit repeated coords after a previous C).
  applyArgs();

  return path;
}

/// Returns the bounding [Rect] of a parsed path, with a safe fallback.
Rect svgPathBounds(Path path) {
  final rect = path.getBounds();
  if (rect.isEmpty || !rect.isFinite) {
    return const Rect.fromLTWH(0, 0, 1, 1);
  }
  return rect;
}
