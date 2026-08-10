/// Model holding all the detailed information about a single character
/// as loaded from the JSON data files.
class CharacterDetail {
  final String character;
  final String romaji;
  final int strokeCount;
  final String pronunciation;
  final List<String> writingPattern;
  final String tips;
  final String mnemonics;
  final List<ExampleWord> exampleWords;
  final List<String> animationPaths;

  // /// Stroke-order animation frames parsed from the JSON `animation.frames`.
  // final List<StrokeFrame> animationFrames;

  const CharacterDetail({
    required this.character,
    required this.romaji,
    required this.strokeCount,
    required this.pronunciation,
    required this.writingPattern,
    required this.tips,
    required this.mnemonics,
    required this.exampleWords,
    // this.animationFrames = const [],
    this.animationPaths = const [],
  });

  // factory CharacterDetail.fromJson(
  //   String character,
  //   Map<String, dynamic> json,
  // ) {
  //   // Parse the nested `animation.frames` array if present.
  //   final animation = json['animation'];
  //   final List<StrokeFrame> frames = [];
  //   if (animation is Map<String, dynamic>) {
  //     final animFrames = animation['frames'];
  //     if (animFrames is List) {
  //       for (final frame in animFrames) {
  //         if (frame is Map<String, dynamic>) {
  //           frames.add(StrokeFrame.fromJson(frame));
  //         }
  //       }
  //     }
  //   }

  //   return CharacterDetail(
  //     character: character,
  //     romaji: json['romaji'] as String? ?? '',
  //     strokeCount: (json['strokeCount'] as num?)?.toInt() ?? 0,
  //     pronunciation: json['pronunciation'] as String? ?? '',
  //     writingPattern:
  //         (json['writingPattern'] as List<dynamic>?)
  //             ?.map((e) => e.toString())
  //             .toList() ??
  //         [],
  //     tips: json['tips'] as String? ?? '',
  //     mnemonics: json['mnemonics'] as String? ?? '',
  //     exampleWords:
  //         (json['exampleWords'] as List<dynamic>?)
  //             ?.map((e) => ExampleWord.fromJson(e as Map<String, dynamic>))
  //             .toList() ??
  //         [],
  //     animationFrames: frames,
  //   );
  // }

  // Legacy support - for backward compatibility
  @Deprecated('Use animationPaths instead')
  List<AnimationFrame> get animationFrames {
    return animationPaths.map((path) {
      return AnimationFrame(
        path: path,
        duration: 300, // Default duration per stroke
        strokeNumber: animationPaths.indexOf(path) + 1,
      );
    }).toList();
  }

  // Legacy support
  @Deprecated('Use animationPaths instead')
  AnimationData? get animationData {
    if (animationPaths.isEmpty) return null;

    final paths = animationPaths.asMap().entries.map((entry) {
      final index = entry.key;
      final path = entry.value;
      return AnimationPath(
        id: 'path${index + 1}',
        stroke: index + 1,
        path: path,
        delay: index / animationPaths.length,
        duration: 1 / animationPaths.length,
        harai: false,
      );
    }).toList();

    return AnimationData(duration: 1.0, paths: paths);
  }

  factory CharacterDetail.fromJson(
    String character,
    Map<String, dynamic> json,
  ) {
    // Parse animation paths - NEW FORMAT
    List<String> animationPaths = [];
    if (json['animation'] != null && json['animation'] is List) {
      animationPaths = (json['animation'] as List).whereType<String>().toList();
    }

    // Parse example words
    final List<ExampleWord> exampleWords = [];
    if (json['exampleWords'] != null && json['exampleWords'] is List) {
      try {
        for (final word in json['exampleWords'] as List) {
          if (word is Map<String, dynamic>) {
            exampleWords.add(ExampleWord.fromJson(word));
          }
        }
      } catch (e) {
        // If example words are malformed, just skip them
      }
    }

    return CharacterDetail(
      character: character,
      romaji: json['romaji'] ?? '',
      strokeCount: json['strokeCount'] ?? 0,
      pronunciation: json['pronunciation'] ?? '',
      writingPattern: (json['writingPattern'] as List?)?.cast<String>() ?? [],
      tips: json['tips'] ?? '',
      mnemonics: json['mnemonics'] ?? '',
      exampleWords: exampleWords,
      animationPaths: animationPaths,
    );
  }
}

/// A single example word showing the character in context.
class ExampleWord {
  final String japanese;
  final String romaji;
  final String english;

  const ExampleWord({
    required this.japanese,
    required this.romaji,
    required this.english,
  });

  factory ExampleWord.fromJson(Map<String, dynamic> json) {
    return ExampleWord(
      japanese: json['japanese'] as String? ?? '',
      romaji: json['romaji'] as String? ?? '',
      english: json['english'] as String? ?? '',
    );
  }
}

// Legacy classes for backward compatibility
class AnimationData {
  final double duration;
  final List<AnimationPath> paths;

  AnimationData({required this.duration, required this.paths});
}

class AnimationPath {
  final String id;
  final int stroke;
  final String path;
  final double delay;
  final double duration;
  final bool? harai;

  AnimationPath({
    required this.id,
    required this.stroke,
    required this.path,
    required this.delay,
    required this.duration,
    this.harai,
  });
}

// Legacy support for backward compatibility
class AnimationFrame {
  final String path;
  final double duration;
  final int? strokeNumber;

  AnimationFrame({
    required this.path,
    required this.duration,
    this.strokeNumber,
  });
}
