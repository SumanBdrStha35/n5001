/// A single stroke frame used for stroke-order animation.
///
/// Mirrors the JSON structure of `animation.frames[]` in the data files:
/// ```json
/// { "stroke": 1, "path": "M68,93 C134,94 ...", "duration": 1500 }
/// ```
class StrokeFrame {
  /// 1-based stroke number.
  final int stroke;

  /// SVG path `d` string describing the stroke geometry.
  final String path;

  /// Animation duration for this stroke in milliseconds.
  final int duration;

  const StrokeFrame({
    required this.stroke,
    required this.path,
    required this.duration,
  });

  /// Builds a [StrokeFrame] from a JSON map.
  factory StrokeFrame.fromJson(Map<String, dynamic> json) {
    return StrokeFrame(
      stroke: (json['stroke'] as num?)?.toInt() ?? 0,
      path: json['path'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
    );
  }
}
