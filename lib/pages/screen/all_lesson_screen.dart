import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:logger/logger.dart';

import '../../data/hr_lesson_repository.dart';
import '../../model/sript_lesson.dart';
import '../../other/app_colors_theme.dart';

class AllLessonScreen extends StatefulWidget {
  final List<LessonData> lessons;
  final ScriptType scriptType;

  const AllLessonScreen({
    super.key,
    required this.lessons,
    required this.scriptType,
  });

  @override
  State<AllLessonScreen> createState() => _AllLessonScreenState();
}

class _AllLessonScreenState extends State<AllLessonScreen> {
  late List<List<KanaCell>> _kanaGrid = [];
  late FlutterTts _flutterTts;
  bool _isTtsInitialized = false;
  String? _currentSpeakingCharacter;

  @override
  void initState() {
    super.initState();
    _buildKanaGridFromLessons();
    _initTts();
  }

  void _buildKanaGridFromLessons() {
    // Determine grid dimensions
    // We want a grid with 5 columns (traditional kana chart)
    const int columns = 5;
    // Build the grid
    final List<List<KanaCell>> grid = [];

    for (final lesson in widget.lessons) {
      final List<KanaCell> rowCells = [];
      for (final char in lesson.characterKeys) {
        if (char.isEmpty || char.trim().isEmpty) {
          // This is an empty cell (spacing)
          rowCells.add(KanaCell.empty());
        } else {
          final romaji = lesson.characters[char] ?? '';
          rowCells.add(KanaCell(character: char, romaji: romaji));
        }
      }
      // If the row has less than 5 cells, pad with empty cells
      while (rowCells.length < columns) {
        rowCells.add(KanaCell.empty());
      }

      grid.add(rowCells);
    }
    setState(() {
      _kanaGrid = grid;
    });
  }

  Future<void> _initTts() async {
    try {
      _flutterTts = FlutterTts();
      await _flutterTts.setLanguage('ja-JP');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.awaitSpeakCompletion(true);

      _flutterTts.setCompletionHandler(() {
        if (mounted) {
          setState(() {
            _currentSpeakingCharacter = null;
          });
        }
      });

      if (mounted) {
        setState(() => _isTtsInitialized = true);
      }
    } catch (e) {
      Logger().d('TTS init error: $e');
    }
  }

  Future<void> _speakCharacter(String character) async {
    if (!_isTtsInitialized) {
      await _initTts();
    }

    try {
      setState(() {
        _currentSpeakingCharacter = character;
      });

      await _flutterTts.setLanguage('ja-JP');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.awaitSpeakCompletion(true);

      final result = await _flutterTts.speak(character);
      if (result != 1) {
        Logger().d('Speech failed for: $character');
        setState(() {
          _currentSpeakingCharacter = null;
        });
      }
    } catch (e) {
      Logger().d('Error in TTS speak: $e');
      setState(() {
        _currentSpeakingCharacter = null;
      });
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);
    return Scaffold(
      backgroundColor: t.background,
      appBar: AppBar(
        backgroundColor: t.surface,
        elevation: 0,
        title: Text(
          'All ${widget.scriptType.name.toUpperCase()} Characters',
          style: TextStyle(color: t.textPrimary, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: t.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_currentSpeakingCharacter != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: t.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.volume_up, size: 16, color: t.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Speaking...',
                    style: TextStyle(
                      fontSize: 12,
                      color: t.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: _kanaGrid.isEmpty
          ? Center(
              child: Text(
                'No characters available',
                style: TextStyle(color: t.textSecondary),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    '${widget.scriptType.name.toUpperCase()} Chart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: t.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap any character to hear its pronunciation',
                    style: TextStyle(fontSize: 14, color: t.textSecondary),
                  ),
                  const SizedBox(height: 20),

                  // Character Grid
                  ...List.generate(_kanaGrid.length, (rowIndex) {
                    final row = _kanaGrid[rowIndex];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: List.generate(row.length, (colIndex) {
                          final cell = row[colIndex];
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: cell.isEmpty
                                  ? Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    )
                                  : _KanaCellWidget(
                                      cell: cell,
                                      isSpeaking:
                                          _currentSpeakingCharacter ==
                                          cell.character,
                                      theme: t,
                                      onTap: () =>
                                          _speakCharacter(cell.character),
                                    ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}

/// Kana cell data model
class KanaCell {
  final String character;
  final String romaji;
  // final bool isLocked;
  final bool isEmpty;

  KanaCell({
    required this.character,
    required this.romaji,
    // required this.isLocked,
    this.isEmpty = false,
  });

  KanaCell.empty()
    : character = '',
      romaji = '',
      // isLocked = false,
      isEmpty = true;
}

/// Individual kana cell widget
class _KanaCellWidget extends StatelessWidget {
  final KanaCell cell;
  final bool isSpeaking;
  final AppColorTheme theme;
  final VoidCallback onTap;

  const _KanaCellWidget({
    required this.cell,
    required this.isSpeaking,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 56,
        decoration: BoxDecoration(
          color: isSpeaking
              ? theme.primary.withValues(alpha: 0.15)
              : theme.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSpeaking
                ? theme.primary
                : theme.border.withValues(alpha: 0.3),
            width: isSpeaking ? 2 : 1,
          ),
          boxShadow: isSpeaking
              ? [
                  BoxShadow(
                    color: theme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Character
            Text(
              cell.character,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: theme.textPrimary,
                height: 1.1,
              ),
            ),
            // Romaji
            Text(
              cell.romaji,
              style: TextStyle(
                fontSize: 9,
                color: isSpeaking ? theme.primary : theme.textMuted,
                fontWeight: isSpeaking ? FontWeight.bold : FontWeight.normal,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
