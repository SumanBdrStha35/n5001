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

  const CharacterDetail({
    required this.character,
    required this.romaji,
    required this.strokeCount,
    required this.pronunciation,
    required this.writingPattern,
    required this.tips,
    required this.mnemonics,
    required this.exampleWords,
  });

  factory CharacterDetail.fromJson(
    String character,
    Map<String, dynamic> json,
  ) {
    return CharacterDetail(
      character: character,
      romaji: json['romaji'] as String? ?? '',
      strokeCount: (json['strokeCount'] as num?)?.toInt() ?? 0,
      pronunciation: json['pronunciation'] as String? ?? '',
      writingPattern:
          (json['writingPattern'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tips: json['tips'] as String? ?? '',
      mnemonics: json['mnemonics'] as String? ?? '',
      exampleWords:
          (json['exampleWords'] as List<dynamic>?)
              ?.map((e) => ExampleWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
