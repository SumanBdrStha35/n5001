import 'dart:convert';

import 'package:flutter/services.dart';

import '../data/hr_lesson_repository.dart';
import '../model/character_detail.dart';

class CharacterDetailService {
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

  static Future<List<CharacterDetail>> loadLessonCharacters({
    required List<String> characterKeys,
    required ScriptType scriptType,
  }) async {
    final jsonData = await _loadJson(scriptType);
    final List<CharacterDetail> results = [];

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
      case ScriptType.hdakuon:
        assetPath = 'assets/data/hiragana_dakuon.json';
        jsonKey = 'hiraganaDakuon';
        break;
      case ScriptType.hhandakuon:
        assetPath = 'assets/data/hiragana_combos.json';
        jsonKey = 'hiraganaCombos';
        break;
      case ScriptType.kdakuon:
        assetPath = 'assets/data/katakana_dakuon.json';
        jsonKey = 'katakanaDakuon';
        break;
      case ScriptType.khandakuon:
        assetPath = 'assets/data/katakana_handakuon.json';
        jsonKey = 'katakanaHandakuon';
        break;
    }

    final jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> decoded =
        json.decode(jsonString) as Map<String, dynamic>;
    final List<dynamic> sections = decoded[jsonKey] as List<dynamic>;

    return (sections: sections, jsonKey: jsonKey);
  }
}
