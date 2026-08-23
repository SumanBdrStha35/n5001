import 'package:flutter/material.dart';

import '../../../../model/sript_lesson.dart';
import '../../../../other/app_colors_theme.dart';
import 'hiragana.dart';
import 'katakana.dart';

class ScriptsSection extends StatefulWidget {
  final List<LessonData> hiraganaLessons;
  final List<LessonData> katakanaLessons;

  final bool isLoadingHiragana;
  final bool isLoadingKatakana;

  const ScriptsSection({
    super.key,
    required this.hiraganaLessons,
    required this.katakanaLessons,
    required this.isLoadingHiragana,
    required this.isLoadingKatakana,
  });

  @override
  State<ScriptsSection> createState() => _ScriptsSectionState();
}

class _ScriptsSectionState extends State<ScriptsSection> {
  late final PageController _pageController;
  int _currentIndex = 0;

  // Track updated lessons to refresh UI
  List<LessonData> _hiraganaLessons = [];
  List<LessonData> _katakanaLessons = [];
  bool _isLoadingHiragana = true;
  bool _isLoadingKatakana = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _hiraganaLessons = widget.hiraganaLessons;
    _katakanaLessons = widget.katakanaLessons;
    _isLoadingHiragana = widget.isLoadingHiragana;
    _isLoadingKatakana = widget.isLoadingKatakana;
  }

  @override
  void didUpdateWidget(ScriptsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hiraganaLessons != widget.hiraganaLessons ||
        oldWidget.isLoadingHiragana != widget.isLoadingHiragana) {
      setState(() {
        _hiraganaLessons = widget.hiraganaLessons;
        _isLoadingHiragana = widget.isLoadingHiragana;
      });
    }
    if (oldWidget.katakanaLessons != widget.katakanaLessons ||
        oldWidget.isLoadingKatakana != widget.isLoadingKatakana) {
      setState(() {
        _katakanaLessons = widget.katakanaLessons;
        _isLoadingKatakana = widget.isLoadingKatakana;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage(int index) {
    if (index == _currentIndex) return;

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleProgressUpdate() {
    // This will trigger a rebuild of the page
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ScriptTabBar(
            currentIndex: _currentIndex,
            onChanged: _changePage,
            theme: t,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                HiraganaPage(
                  lessons: _hiraganaLessons,
                  isLoading: _isLoadingHiragana,
                  onProgressUpdate: _handleProgressUpdate,
                ),
                KatakanaPage(
                  lessons: _katakanaLessons,
                  isLoading: _isLoadingKatakana,
                  onProgressUpdate: _handleProgressUpdate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScriptTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final AppColorTheme theme;

  const _ScriptTabBar({
    required this.currentIndex,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: 'Hiragana',
              selected: currentIndex == 0,
              onTap: () => onChanged(0),
              theme: theme,
            ),
          ),
          Expanded(
            child: _TabButton(
              title: 'Katakana',
              selected: currentIndex == 1,
              onTap: () => onChanged(1),
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final AppColorTheme theme;

  const _TabButton({
    required this.title,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? theme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? (theme.brightness == Brightness.dark
                      ? theme.textPrimary
                      : Colors.white)
                : theme.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
