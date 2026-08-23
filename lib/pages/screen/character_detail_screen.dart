import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';

import '../../data/hr_lesson_repository.dart';
import '../../model/character_detail.dart';
import '../../model/sript_lesson.dart';
import '../../other/app_colors_theme.dart';
import '../../service/character_detail_service.dart';
import '../../utils/simple_svg_path_parser.dart';

/// A full‑screen detail page for studying a lesson's characters one by one.
///
/// Provide [lesson] for title & progress‑tracking context,
/// [characters] with the full [CharacterDetail] list,
/// and optionally [initialIndex] to start at a specific character.
class HiraganaLessonPage extends StatefulWidget {
  final LessonData? lesson;
  final List<CharacterDetail> characters;
  final int initialIndex;
  const HiraganaLessonPage({
    super.key,
    required this.lesson,
    required this.characters,
    this.initialIndex = 0,
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
    _flutterTts = FlutterTts();
    _initTts();
    _currentIndex = widget.initialIndex.clamp(0, _totalCharacters - 1).toInt();
    _pageController = PageController(initialPage: _currentIndex);
  }

  Future<void> _initTts() async {
    try {
      // Use Japanese so hiragana/katakana text is read correctly.
      await _flutterTts.setLanguage('ja-JP');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.awaitSpeakCompletion(true);
      if (mounted) setState(() => _isTtsInitialized = true);
    } catch (e) {
      Logger().d('TTS init error: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _playAudio(String text) async {
    if (text.trim().isEmpty) return;
    try {
      await _flutterTts.setLanguage('ja-JP');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.awaitSpeakCompletion(true);
      Logger().d('Character to speak: $text');
      final result = await _flutterTts.speak(text);
      if (result == 1) {
        Logger().d('Speech started successfully for: $text');
      } else {
        Logger().d('Speech failed to start for: $text');
      }
    } catch (e) {
      Logger().d('Error in TTS speak: $e');
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
    // final char = widget.characters[index];
    // _playAudio(char.character);
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
    final lessonTitle = widget.lesson?.section.isNotEmpty == true
        ? widget.lesson!.section
        : 'Lesson';
    return AppBar(
      backgroundColor: t.surface,
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
        color: t.surface,
        border: Border(top: BorderSide(color: t.border.withValues(alpha: 0.5))),
        boxShadow: [
          BoxShadow(
            color: t.shadow.withValues(alpha: 0.04),
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
                onPressed: () async {
                  if (_isLast) {
                    await _onLessonComplete();
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
                  foregroundColor: t.onPrimary,
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

  Future<void> _onLessonComplete() async {
    Logger().d('Completing lesson... ${widget.lesson?.lessonId}');
    try {
      // Determine script type from lesson ID
      final scriptType = widget.lesson?.lessonId.startsWith('hiragana') == true
          ? ScriptType.hiragana
          : ScriptType.katakana;
      Logger().d('Script type: $scriptType');

      // Complete the lesson and unlock next
      final repository = LessonRepository(
        isar: Isar.getInstance()!, // Get your Isar instance
      );

      await repository.completeLesson(
        lessonId: widget.lesson!.lessonId,
        scriptType: scriptType,
      );
      Logger().d('Lesson completed: ${widget.lesson!.lessonId}');
      _showSnack('🎉 Lesson complete! Next lesson unlocked!');
      // Return true to Lesson List
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      Logger().e('Error completing lesson: $e');
      if (mounted) {
        _showSnack('❌ Error completing lesson');
      }
    }
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
          const SizedBox(height: 14),
          _WritingActionButtons(
            onPlay: () => _openStrokeOrderSheet(context, detail, theme),
            onPractice: () => _openPracticeSheet(context, detail, theme),
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
// Bottom sheet launchers
// ---------------------------------------------------------------------------

void _openStrokeOrderSheet(
  BuildContext context,
  CharacterDetail detail,
  AppColorTheme theme,
) {
  // Check if animation data exists
  if (detail.animationPaths.isEmpty) {
    // Show a snackbar or dialog explaining the animation isn't available
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Stroke order animation not available for this character',
        ),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _StrokeAnimationSheet(detail: detail, theme: theme),
  );
}

void _openPracticeSheet(
  BuildContext context,
  CharacterDetail detail,
  AppColorTheme theme,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PracticeSheet(detail: detail, theme: theme),
  );
}

// ---------------------------------------------------------------------------
// Sub‑widgets
// ---------------------------------------------------------------------------

/// "Play" (stroke-order animation) and "Practice" (draw-it-yourself) actions.
class _WritingActionButtons extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onPractice;
  final AppColorTheme theme;

  const _WritingActionButtons({
    required this.onPlay,
    required this.onPractice,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPlay,
            icon: const Icon(Icons.play_circle_outline, size: 18),
            label: const Text('Play'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.primary,
              side: BorderSide(color: theme.primary.withValues(alpha: 0.5)),
              minimumSize: const Size(0, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onPractice,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Practice'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primary,
              foregroundColor: theme.onPrimary,
              elevation: 0,
              minimumSize: const Size(0, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
        color: theme.card,
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
                  child: Icon(
                    Icons.volume_up_rounded,
                    color: theme.onPrimary,
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
        color: theme.card,
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
        color: theme.brandAmber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.brandAmber.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.brandAmber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.auto_awesome, color: theme.brandAmber, size: 18),
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
                    color: theme.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mnemonics,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textPrimary,
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
        color: theme.card,
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
// "Play" bottom sheet – animated stroke-order playback
// ---------------------------------------------------------------------------

class _StrokeAnimationSheet extends StatefulWidget {
  final CharacterDetail detail;
  final AppColorTheme theme;

  const _StrokeAnimationSheet({required this.detail, required this.theme});

  @override
  State<_StrokeAnimationSheet> createState() => _StrokeAnimationSheetState();
}

class _StrokeAnimationSheetState extends State<_StrokeAnimationSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Path> _strokePaths;
  late final int _totalStrokes;

  // Add this for better state management
  bool _isPlaying = false;

  bool get _hasAnimation => _strokePaths.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    // Parse the animation paths
    _strokePaths = parseSvgPaths(widget.detail.animationPaths);
    _totalStrokes = _strokePaths.length;

    // Create animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500), // Adjust the duration
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isPlaying = false);
      }
    });

    if (_hasAnimation) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _play());
    }
  }

  void _play() {
    if (!_hasAnimation || _controller.isAnimating) return;
    setState(() => _isPlaying = true);
    _controller.forward(from: 0.0);
  }

  void _replay() {
    if (!_hasAnimation) return;
    _controller.stop();
    _controller.reset();
    _play();
  }

  int _getCurrentStrokeIndex(double progress) {
    if (_totalStrokes == 0) return 0;
    return (progress * _totalStrokes).floor().clamp(0, _totalStrokes - 1);
  }

  @override
  void dispose() {
    // _controller.removeStatusListener((status) {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: t.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 8, 4),
                child: Row(
                  children: [
                    Icon(
                      _isPlaying
                          ? Icons.play_circle_fill
                          : Icons.play_circle_outline,
                      color: t.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Stroke Order — ${widget.detail.character}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: t.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Add progress indicator
                    if (_isPlaying)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: _controller.value,
                          color: t.primary,
                          backgroundColor: t.border.withValues(alpha: 0.3),
                        ),
                      ),
                    IconButton(
                      icon: Icon(Icons.close, color: t.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: t.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: t.border.withValues(alpha: 0.4),
                          ),
                        ),
                        child: _hasAnimation
                            ? AnimatedBuilder(
                                animation: _controller,
                                builder: (context, _) {
                                  return CustomPaint(
                                    size: const Size(200, 200),
                                    painter: KanjiStrokePainter(
                                      strokes: _strokePaths,
                                      currentProgress: _controller.value,
                                      strokeColor: t.primary,
                                      gridColor: t.border,
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  widget.detail.character,
                                  style: TextStyle(
                                    fontSize: 96,
                                    color: t.textPrimary,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (_hasAnimation) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _replay,
                            icon: const Icon(Icons.replay, size: 18),
                            label: const Text('Replay'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: t.primary,
                              side: BorderSide(color: t.primary),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              _controller.stop();
                              _controller.reset();
                              setState(() => _isPlaying = false);
                            },
                            icon: const Icon(Icons.stop, size: 18),
                            label: const Text('Stop'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: t.textSecondary,
                              side: BorderSide(color: t.border),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Add progress slider
                      Slider(
                        value: _controller.value,
                        onChanged: (value) {
                          _controller.value = value;
                          setState(() => _isPlaying = false);
                        },
                        activeColor: t.primary,
                        inactiveColor: t.border.withValues(alpha: 0.3),
                        min: 0,
                        max: 1,
                      ),
                      // Show stroke count
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Stroke ${_getCurrentStrokeIndex(_controller.value) + 1} of $_totalStrokes',
                          style: TextStyle(fontSize: 13, color: t.textMuted),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ] else
                      Text(
                        'Stroke-order animation isn\'t available for this character yet — here\'s the written guide instead.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: t.textMuted),
                      ),
                    const SizedBox(height: 20),
                    if (widget.detail.writingPattern.isNotEmpty)
                      _StrokeInfoCard(
                        strokeCount: widget.detail.strokeCount,
                        writingPattern: widget.detail.writingPattern,
                        tips: widget.detail.tips,
                        theme: t,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Painter that draws kanji strokes with animation progress
class KanjiStrokePainter extends CustomPainter {
  final List<Path> strokes;
  final double currentProgress;
  final Color strokeColor;
  final Color gridColor;

  KanjiStrokePainter({
    required this.strokes,
    required this.currentProgress,
    required this.strokeColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid
    _drawGrid(canvas, size);

    if (strokes.isEmpty) return;

    // ------------------------------------------------------------
    // 1. Calculate the complete SVG/path bounds
    // ------------------------------------------------------------
    Rect bounds = Rect.zero;
    bool hasBounds = false;
    for (final path in strokes) {
      final pathBounds = path.getBounds();
      if (!hasBounds) {
        bounds = pathBounds;
        hasBounds = true;
      } else {
        bounds = bounds.expandToInclude(pathBounds);
      }
    }
    if (!hasBounds || bounds.width <= 0 || bounds.height <= 0) {
      return;
    }

    // ------------------------------------------------------------
    // 2. Calculate scale so the SVG fits inside the canvas
    // ------------------------------------------------------------
    // Padding around the character.
    const double padding = 24.0;
    final double availableWidth = size.width - (padding * 2);
    final double availableHeight = size.height - (padding * 2);
    final double scaleX = availableWidth / bounds.width;
    final double scaleY = availableHeight / bounds.height;

    // Keep aspect ratio.
    final double scale = math.min(scaleX, scaleY);

    // ------------------------------------------------------------
    // 3. Calculate the scaled size
    // ------------------------------------------------------------
    final double scaledWidth = bounds.width * scale;
    final double scaledHeight = bounds.height * scale;

    // ------------------------------------------------------------
    // 4. Center the SVG inside the canvas
    // ------------------------------------------------------------
    final double offsetX = (size.width - scaledWidth) / 2.0;
    final double offsetY = (size.height - scaledHeight) / 2.0;
    canvas.save();
    // Move to the centered position.
    canvas.translate(offsetX, offsetY);
    // Scale SVG coordinates.
    canvas.scale(scale, scale);
    // Move the SVG's actual bounds to 0,0.
    canvas.translate(-bounds.left, -bounds.top);

    // Draw completed strokes
    final Paint paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          3.0 // Stroke width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // ------------------------------------------------------------
    // 6. Calculate stroke animation progress
    // ------------------------------------------------------------
    final int totalStrokes = strokes.length;
    if (totalStrokes == 0) {
      canvas.restore();
      return;
    }
    final double animationProgress = currentProgress.clamp(0.0, 1.0);
    final double strokeProgress = animationProgress * totalStrokes;
    final int completedStrokes = strokeProgress.floor().clamp(0, totalStrokes);
    final double partialProgress = strokeProgress - completedStrokes;

    // ------------------------------------------------------------
    // 7. Draw completed strokes
    // ------------------------------------------------------------
    for (int i = 0; i < completedStrokes; i++) {
      canvas.drawPath(strokes[i], paint);
    }
    // ------------------------------------------------------------
    // 8. Draw current/partial stroke
    // ------------------------------------------------------------
    if (completedStrokes < totalStrokes && partialProgress > 0.0) {
      final Path partialPath = _extractPartialPath(
        strokes[completedStrokes],
        partialProgress,
      );
      canvas.drawPath(partialPath, paint);
    }
    canvas.restore();
  }

  /// Extract a portion of a path based on progress (0.0 to 1.0)
  Path _extractPartialPath(Path path, double progress) {
    if (progress >= 1.0) return path;
    if (progress <= 0.0) return Path();

    final Path result = Path();
    final List<PathMetric> metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) {
      return Path();
    }
    // path.computeMetrics().forEach((metric) {
    //   metrics.add(metric);
    // });

    double totalLength = 0;
    for (final metric in metrics) {
      totalLength += metric.length;
    }

    if (totalLength == 0.0) return path;

    double targetLength = totalLength * progress;
    double accumulatedLength = 0.0;

    for (final metric in metrics) {
      final double nextLength = accumulatedLength + metric.length;
      if (nextLength >= targetLength) {
        final double remaining = targetLength - accumulatedLength;
        if (remaining > 0) {
          result.addPath(metric.extractPath(0.0, remaining), Offset.zero);
        }
        break;
      }
      result.addPath(metric.extractPath(0.0, metric.length), Offset.zero);
      accumulatedLength = nextLength;
    }
    return result;
  }

  void _drawGrid(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);

    final Paint dashPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Horizontal and vertical center lines
    _dashedLine(
      canvas,
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      dashPaint,
    );
    _dashedLine(
      canvas,
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      dashPaint,
    );
    // Diagonal lines
    _dashedLine(
      canvas,
      Offset.zero,
      Offset(size.width, size.height),
      dashPaint,
    );
    _dashedLine(
      canvas,
      Offset(size.width, 0),
      Offset(0, size.height),
      dashPaint,
    );
  }

  void _dashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 6.0;
    const dashSpace = 5.0;
    final Offset difference = end - start;
    final double totalLength = difference.distance;
    if (totalLength == 0.0) return;
    final Offset direction = difference / totalLength;
    double drawn = 0.0;
    while (drawn < totalLength) {
      final Offset segStart = start + direction * drawn;
      final double segLen = math.min(dashWidth, totalLength - drawn);
      canvas.drawLine(segStart, segStart + direction * segLen, paint);
      drawn += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant KanjiStrokePainter oldDelegate) {
    return oldDelegate.currentProgress != currentProgress ||
        oldDelegate.strokes.length != strokes.length ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.strokes.length != strokes.length;
  }
}

// ---------------------------------------------------------------------------
// "Practice" bottom sheet – freehand tracing / drawing
// ---------------------------------------------------------------------------

class _PracticeSheet extends StatefulWidget {
  final CharacterDetail detail;
  final AppColorTheme theme;

  const _PracticeSheet({required this.detail, required this.theme});

  @override
  State<_PracticeSheet> createState() => _PracticeSheetState();
}

class _PracticeSheetState extends State<_PracticeSheet> {
  final List<List<Offset>> _strokes = [];
  List<Offset>? _currentStroke;
  bool _showGuide = true;

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentStroke = [details.localPosition];
      _strokes.add(_currentStroke!);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_currentStroke == null) return;
    setState(() => _currentStroke!.add(details.localPosition));
  }

  void _onPanEnd(DragEndDetails details) {
    _currentStroke = null;
  }

  void _undo() {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.removeLast());
  }

  void _clear() {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.clear());
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    // NOTE: We intentionally do NOT use a DraggableScrollableSheet here.
    // Its drag-to-resize gesture would fight with the drawing pan gestures
    // and move the sheet while the user tries to draw. A fixed-height layout
    // keeps the sheet still so drawing works reliably.
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Container(
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: t.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 4),
              child: Row(
                children: [
                  Icon(Icons.edit, color: t.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Practice — ${widget.detail.character}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: t.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _showGuide ? Icons.visibility : Icons.visibility_off,
                      color: t.textSecondary,
                    ),
                    tooltip: 'Toggle guide',
                    onPressed: () => setState(() => _showGuide = !_showGuide),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: t.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: t.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: t.border.withValues(alpha: 0.4),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: GestureDetector(
                          onPanStart: _onPanStart,
                          onPanUpdate: _onPanUpdate,
                          onPanEnd: _onPanEnd,
                          child: CustomPaint(
                            painter: _PracticePainter(
                              strokes: _strokes,
                              guideChar: _showGuide
                                  ? widget.detail.character
                                  : '',
                              gridColor: t.border,
                              guideColor: t.textMuted,
                              inkColor: t.primary,
                            ),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _strokes.isEmpty ? null : _undo,
                          icon: const Icon(Icons.undo, size: 18),
                          label: const Text('Undo'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: t.textSecondary,
                            side: BorderSide(color: t.border),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _strokes.isEmpty ? null : _clear,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Clear'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red.shade400,
                            side: BorderSide(color: Colors.red.shade200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Trace the faint character, or hide the guide to draw freehand.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: t.textMuted),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws the practice grid, an optional faint guide character, and the
/// user's freehand ink strokes.
class _PracticePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final String guideChar;
  final Color gridColor;
  final Color guideColor;
  final Color inkColor;

  _PracticePainter({
    required this.strokes,
    required this.guideChar,
    required this.gridColor,
    required this.guideColor,
    required this.inkColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);

    final dashPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    _dashedLine(
      canvas,
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      dashPaint,
    );
    _dashedLine(
      canvas,
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      dashPaint,
    );
    _dashedLine(
      canvas,
      Offset.zero,
      Offset(size.width, size.height),
      dashPaint,
    );
    _dashedLine(
      canvas,
      Offset(size.width, 0),
      Offset(0, size.height),
      dashPaint,
    );

    if (guideChar.isNotEmpty) {
      final tp = TextPainter(
        text: TextSpan(
          text: guideChar,
          style: TextStyle(
            fontSize: size.width * 0.62,
            color: guideColor.withValues(alpha: 0.25),
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
      );
    }

    final inkPaint = Paint()
      ..color = inkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        canvas.drawCircle(
          stroke.first,
          inkPaint.strokeWidth / 2,
          inkPaint..style = PaintingStyle.fill,
        );
        inkPaint.style = PaintingStyle.stroke;
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final p in stroke.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, inkPaint);
    }
  }

  void _dashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 6.0;
    const dashSpace = 5.0;
    final totalLength = (end - start).distance;
    if (totalLength == 0) return;
    final direction = (end - start) / totalLength;
    double drawn = 0;
    while (drawn < totalLength) {
      final segStart = start + direction * drawn;
      final segLen = (drawn + dashWidth) > totalLength
          ? totalLength - drawn
          : dashWidth;
      canvas.drawLine(segStart, segStart + direction * segLen, paint);
      drawn += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _PracticePainter oldDelegate) => true;
}

// ---------------------------------------------------------------------------
// Navigation helper – used by lesson_list.dart
// ---------------------------------------------------------------------------
Future<bool?> navigateToCharacterDetail({
  required BuildContext context,
  required String character,
  required ScriptType scriptType,
  LessonData? lesson,
  // VoidCallback? onLessonComplete,
}) async {
  if (lesson == null) false;

  final characters = await CharacterDetailService.loadLessonCharacters(
    characterKeys: lesson?.characterKeys ?? [],
    scriptType: scriptType,
  );

  if (!context.mounted) false;

  if (characters.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Character details not found')),
    );
    return false;
  }

  // Find the initial index matching the requested character
  final initialIndex = characters.indexWhere((c) => c.character == character);

  final result = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => HiraganaLessonPage(
        lesson: lesson,
        characters: characters,
        initialIndex: initialIndex >= 0 ? initialIndex : 0,
      ),
    ),
  );
  return result;
}
