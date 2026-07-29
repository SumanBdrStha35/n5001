import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../data/hr_lesson_repository.dart';
import '../../model/character_detail.dart';
import '../../model/sript_lesson.dart';
import '../../other/app_colors_theme.dart';
import '../../service/character_detail_service.dart';

/// A full‑screen detail page for studying a lesson's characters one by one.
///
/// Provide [lesson] for title & progress‑tracking context,
/// [characters] with the full [CharacterDetail] list,
/// and optionally [initialIndex] to start at a specific character.
class HiraganaLessonPage extends StatefulWidget {
  final LessonData lesson;
  final List<CharacterDetail> characters;
  final int initialIndex;
  final VoidCallback? onLessonComplete;

  const HiraganaLessonPage({
    super.key,
    required this.lesson,
    required this.characters,
    this.initialIndex = 0,
    this.onLessonComplete,
  });

  @override
  State<HiraganaLessonPage> createState() => _HiraganaLessonPageState();
}

class _HiraganaLessonPageState extends State<HiraganaLessonPage> {
  late FlutterTts _flutterTts;
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isTtsInitialized = false;

  int get _totalCharacters => widget.characters.length;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _totalCharacters - 1);
    _pageController = PageController(initialPage: _currentIndex);
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      _flutterTts = FlutterTts();
      await _flutterTts.setLanguage("ja-JP");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);
      _isTtsInitialized = true;
    } catch (_) {
      _isTtsInitialized = false;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _playAudio(String text) async {
    if (!_isTtsInitialized) {
      _showSnack('TTS not available');
      return;
    }
    try {
      await _flutterTts.setLanguage("ja-JP");
      await _flutterTts.speak(text);
    } catch (_) {
      _showSnack('Could not play audio');
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _goToCharacter(int index) {
    if (index < 0 || index >= _totalCharacters) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    // Auto-play current character audio
    final char = widget.characters[index];
    _playAudio(char.character);
  }

  bool get _isFirst => _currentIndex == 0;
  bool get _isLast => _currentIndex == _totalCharacters - 1;

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);

    return Scaffold(
      backgroundColor: t.background,
      appBar: _buildAppBar(t),
      body: Column(
        children: [
          // PageView for swiping between characters
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _totalCharacters,
              itemBuilder: (context, index) {
                return _CharacterPage(
                  detail: widget.characters[index],
                  total: _totalCharacters,
                  index: index,
                  onPlayAudio: () =>
                      _playAudio(widget.characters[index].character),
                  onPlayExample: (word) => _playAudio(word),
                  theme: t,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(t),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColorTheme t) {
    final lessonTitle = widget.lesson.section.isNotEmpty
        ? widget.lesson.section
        : 'Lesson';
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: t.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        lessonTitle,
        style: TextStyle(
          color: t.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: t.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${_currentIndex + 1}/$_totalCharacters',
            style: TextStyle(
              color: t.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: LinearProgressIndicator(
          value: (_currentIndex + 1) / _totalCharacters,
          backgroundColor: t.border.withValues(alpha: 0.5),
          valueColor: AlwaysStoppedAnimation<Color>(t.primary),
          minHeight: 4,
        ),
      ),
    );
  }

  Widget _buildBottomNav(AppColorTheme t) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: t.border.withValues(alpha: 0.5))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Previous Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isFirst
                    ? null
                    : () => _goToCharacter(_currentIndex - 1),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  foregroundColor: t.textSecondary,
                  side: BorderSide(color: t.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Next / Complete Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_isLast) {
                    _onLessonComplete();
                  } else {
                    _goToCharacter(_currentIndex + 1);
                  }
                },
                icon: Icon(
                  _isLast ? Icons.check_circle_outline : Icons.arrow_forward,
                  size: 18,
                ),
                label: Text(_isLast ? 'Complete' : 'Next'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  backgroundColor: _isLast ? t.success : t.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLessonComplete() {
    widget.onLessonComplete?.call();
    _showSnack('🎉 Lesson complete!');
    Navigator.of(context).pop();
  }
}

/// A single page showing one character's full details.
class _CharacterPage extends StatelessWidget {
  final CharacterDetail detail;
  final int total;
  final int index;
  final VoidCallback onPlayAudio;
  final ValueChanged<String> onPlayExample;
  final AppColorTheme theme;

  const _CharacterPage({
    required this.detail,
    required this.total,
    required this.index,
    required this.onPlayAudio,
    required this.onPlayExample,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Main Character Card ----------
          _CharacterCard(
            character: detail.character,
            romaji: detail.romaji,
            pronunciation: detail.pronunciation,
            onPlayAudio: onPlayAudio,
            theme: theme,
          ),
          const SizedBox(height: 24),

          // ---------- Stroke Count & Writing Tips ----------
          _SectionHeader(title: 'HOW TO WRITE'),
          const SizedBox(height: 10),
          _StrokeInfoCard(
            strokeCount: detail.strokeCount,
            writingPattern: detail.writingPattern,
            tips: detail.tips,
            theme: theme,
          ),
          const SizedBox(height: 20),

          // ---------- Mnemonic ----------
          if (detail.mnemonics.isNotEmpty) ...[
            _MnemonicCard(mnemonics: detail.mnemonics, theme: theme),
            const SizedBox(height: 24),
          ],

          // ---------- Example Words ----------
          if (detail.exampleWords.isNotEmpty) ...[
            _SectionHeader(title: 'EXAMPLE WORDS'),
            const SizedBox(height: 10),
            ...detail.exampleWords.map(
              (word) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ExampleWordCard(
                  word: word,
                  onPlay: () => onPlayExample(word.japanese),
                  theme: theme,
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub‑widgets
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColorsTheme.of(context).textMuted,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final String character;
  final String romaji;
  final String pronunciation;
  final VoidCallback onPlayAudio;
  final AppColorTheme theme;

  const _CharacterCard({
    required this.character,
    required this.romaji,
    required this.pronunciation,
    required this.onPlayAudio,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.border.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Character
          Text(
            character,
            style: TextStyle(
              fontSize: 88,
              fontWeight: FontWeight.w400,
              color: theme.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          // Romaji + Audio button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                romaji,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onPlayAudio,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            pronunciation,
            style: TextStyle(
              fontSize: 14,
              color: theme.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _StrokeInfoCard extends StatelessWidget {
  final int strokeCount;
  final List<String> writingPattern;
  final String tips;
  final AppColorTheme theme;

  const _StrokeInfoCard({
    required this.strokeCount,
    required this.writingPattern,
    required this.tips,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stroke count badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$strokeCount strokes',
              style: TextStyle(
                color: theme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Stroke steps
          ...List.generate(writingPattern.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      writingPattern[i],
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          // Tips section
          if (tips.isNotEmpty) ...[
            const Divider(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 18,
                  color: theme.brandAmber,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tips,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MnemonicCard extends StatelessWidget {
  final String mnemonics;
  final AppColorTheme theme;

  const _MnemonicCard({required this.mnemonics, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFEF3C7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFFD97706),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mnemonic',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF92400E),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mnemonics,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF92400E),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleWordCard extends StatelessWidget {
  final ExampleWord word;
  final VoidCallback onPlay;
  final AppColorTheme theme;

  const _ExampleWordCard({
    required this.word,
    required this.onPlay,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Japanese word + romaji
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      word.japanese,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: theme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onPlay,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.volume_up,
                          size: 16,
                          color: theme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  word.romaji,
                  style: TextStyle(fontSize: 14, color: theme.textSecondary),
                ),
              ],
            ),
          ),
          // English meaning
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              word.english,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Navigation helper – used by lesson_list.dart
// ---------------------------------------------------------------------------

/// Navigates to the character detail page with full lesson context.
///
/// Loads all [CharacterDetail] objects for the given lesson's characters
/// and opens [HiraganaLessonPage] with a modern swipeable UI.
Future<void> navigateToCharacterDetail({
  required BuildContext context,
  required String character,
  required ScriptType scriptType,
  LessonData? lesson,
  VoidCallback? onLessonComplete,
}) async {
  if (lesson == null) return;

  final characters = await CharacterDetailService.loadLessonCharacters(
    characterKeys: lesson.characterKeys,
    scriptType: scriptType,
  );

  if (!context.mounted) return;

  if (characters.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Character details not found')),
    );
    return;
  }

  // Find the initial index matching the requested character
  final initialIndex = characters.indexWhere((c) => c.character == character);

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => HiraganaLessonPage(
        lesson: lesson,
        characters: characters,
        initialIndex: initialIndex >= 0 ? initialIndex : 0,
        onLessonComplete: onLessonComplete,
      ),
    ),
  );
}
