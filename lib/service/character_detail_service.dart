import 'dart:convert';

import 'package:flutter/services.dart';

import '../data/hr_lesson_repository.dart';
import '../model/character_detail.dart';

/// Utility for loading full character details from the bundled JSON assets.
class CharacterDetailService {
  /// Loads the full [CharacterDetail] for a given character and script type.
  ///
  /// [character] is the character itself (e.g. "あ", "ア").
  /// [scriptType] specifies whether it's hiragana or katakana.
  static Future<CharacterDetail?> loadCharacterDetail({
    required String character,
    required ScriptType scriptType,
  }) async {
    final jsonData = await _loadJson(scriptType);

    for (final section in jsonData.sections) {
      final characters = section['characters'] as Map<String, dynamic>? ?? {};
      if (characters.containsKey(character)) {
        return CharacterDetail.fromJson(
          character,
          characters[character] as Map<String, dynamic>,
        );
      }
    }

    return null;
  }

  /// Loads all [CharacterDetail] objects for a list of character keys
  /// within a given lesson (section) for the specified script type.
  ///
  /// [characterKeys] is an ordered list of characters (e.g. ["あ", "い", "う"]).
  /// [scriptType] specifies whether it's hiragana or katakana.
  /// Returns a list of [CharacterDetail] in the same order as [characterKeys].
  static Future<List<CharacterDetail>> loadLessonCharacters({
    required List<String> characterKeys,
    required ScriptType scriptType,
  }) async {
    final jsonData = await _loadJson(scriptType);
    final List<CharacterDetail> results = [];

    // Collect all character maps from all sections
    final Map<String, Map<String, dynamic>> allCharData = {};
    for (final section in jsonData.sections) {
      final characters = section['characters'] as Map<String, dynamic>? ?? {};
      for (final entry in characters.entries) {
        allCharData[entry.key] = Map<String, dynamic>.from(entry.value as Map);
      }
    }

    for (final character in characterKeys) {
      if (allCharData.containsKey(character)) {
        results.add(
          CharacterDetail.fromJson(character, allCharData[character]!),
        );
      }
    }

    return results;
  }

  /// Internal helper to load and parse JSON data.
  static Future<({List<dynamic> sections, String jsonKey})> _loadJson(
    ScriptType scriptType,
  ) async {
    final String assetPath;
    final String jsonKey;

    switch (scriptType) {
      case ScriptType.hiragana:
        assetPath = 'assets/data/hiragana.json';
        jsonKey = 'hiraganaLessons';
        break;
      case ScriptType.katakana:
        assetPath = 'assets/data/katakana.json';
        jsonKey = 'katakanaLessons';
        break;
    }

    final jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> decoded =
        json.decode(jsonString) as Map<String, dynamic>;
    final List<dynamic> sections = decoded[jsonKey] as List<dynamic>;

    return (sections: sections, jsonKey: jsonKey);
  }
}
