import 'package:flutter/material.dart';

import '../../../../model/sript_data.dart';
import '../../../../model/sript_lesson.dart';
import '../../../../other/app_colors_theme.dart';
import '../../../../widgets/app_card_container.dart';
import 'hiragana.dart';
import 'katakana.dart';

// ──────────────────────────────────────────────
// ScriptsSection  – parent widget with pill
//                  indicator + PageView
// ──────────────────────────────────────────────

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
  double _pagePosition = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(_onPagePositionChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPagePositionChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPagePositionChanged() {
    if (!_pageController.hasClients) return;
    final pos = _pageController.page ?? 0.0;
    setState(() {
      _pagePosition = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);

    return Column(
      children: [
        // Smooth pill‑style page indicator
        _buildPageIndicator(t),
        const SizedBox(height: 4),

        // Swipeable PageView
        Expanded(
          child: PageView(
            controller: _pageController,
            children: [
              HiraganaPage(
                lessons: widget.hiraganaLessons,
                isLoading: widget.isLoadingHiragana,
              ),
              KatakanaPage(
                lessons: widget.katakanaLessons,
                isLoading: widget.isLoadingKatakana,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(AppColorTheme t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: t.surfaceVariant,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / 2;
            final clampedPos = _pagePosition.clamp(0.0, 1.0);
            final pillOffset = clampedPos * (constraints.maxWidth - tabWidth);

            return Stack(
              children: [
                // Sliding highlight pill
                Positioned(
                  left: pillOffset,
                  top: 0,
                  bottom: 0,
                  width: tabWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: t.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                // Text labels row
                Row(
                  children: List.generate(2, (index) {
                    final isSelected = (_pagePosition - index).abs() < 0.5;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: Text(
                            index == 0 ? 'Hiragana' : 'Katakana',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : t.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// ScriptPageContent  – shared scaffold for
//                      Hiragana / Katakana pages
// ──────────────────────────────────────────────

class ScriptPageContent extends StatelessWidget {
  final ScriptCardData scriptCard;
  final List<LessonData> lessons;
  final bool isLoading;

  const ScriptPageContent({
    super.key,
    required this.scriptCard,
    required this.lessons,
    required this.isLoading,
  });

  /// Groups lessons by their [LessonData.section] field, preserving order.
  List<MapEntry<String, List<LessonData>>> _groupedLessons() {
    final Map<String, List<LessonData>> map = {};
    final List<String> orderedKeys = [];

    for (final lesson in lessons) {
      if (!map.containsKey(lesson.section)) {
        map[lesson.section] = [];
        orderedKeys.add(lesson.section);
      }
      map[lesson.section]!.add(lesson);
    }

    return orderedKeys.map((k) => MapEntry(k, map[k]!)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScriptCard(context, scriptCard),
          const SizedBox(height: 28),
          Text(
            'Lesson-wise practice',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: t.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : _buildGroupedLessons(context, t),
        ],
      ),
    );
  }

  Widget _buildGroupedLessons(BuildContext context, AppColorTheme t) {
    final groups = _groupedLessons();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups.expand((group) {
        final sectionLessons = group.value;
        // Count completed lessons within the section
        final completedCount = sectionLessons
            .where((l) => l.statusText == 'Completed')
            .length;

        return [
          // Section header
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  group.key,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: t.primaryDark,
                  ),
                ),
                Text(
                  '$completedCount/${sectionLessons.length}',
                  style: TextStyle(fontSize: 13, color: t.textMuted),
                ),
              ],
            ),
          ),
          // Character lesson cards for this section
          ...List.generate(sectionLessons.length * 2 - 1, (i) {
            if (i.isOdd) return const SizedBox(height: 8);
            final lessonIdx = i ~/ 2;
            return _buildLessonCard(context, sectionLessons[lessonIdx]);
          }),
        ];
      }).toList(),
    );
  }

  Widget _buildScriptCard(BuildContext context, ScriptCardData data) {
    final t = AppColorsTheme.of(context);

    return AppCardContainer(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: t.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: t.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    data.charCount,
                    style: TextStyle(
                      color: t.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.1,
              ),
              itemCount: data.characters.length,
              itemBuilder: (context, i) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: t.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    data.characters[i],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: t.primaryDark,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.progressText,
                  style: TextStyle(color: t.textMuted, fontSize: 12),
                ),
                if (data.progressPercent > 0)
                  Text(
                    '${(data.progressPercent * 100).toInt()}%',
                    style: TextStyle(color: t.textMuted, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: data.progressPercent,
                backgroundColor: t.border,
                valueColor: AlwaysStoppedAnimation<Color>(t.primary),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: t.primary,
                      side: BorderSide(color: t.border),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View all',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: t.primary,
                      foregroundColor: t.brightness == Brightness.dark
                          ? t.textPrimary
                          : Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      data.actionText,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, LessonData lesson) {
    final t = AppColorsTheme.of(context);
    final statusColor = _statusColor(lesson.statusText, t);
    final bgColor = _statusBgColor(lesson.statusText, t);
    final borderColor = _statusBorderColor(lesson.statusText, t);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            child: Icon(lesson.icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: t.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lesson.subtitle,
                  style: TextStyle(color: t.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            lesson.statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status, AppColorTheme t) {
    switch (status) {
      case 'Completed':
        return t.success;
      case 'In Progress':
        return t.primary;
      case 'Locked':
      default:
        return t.textMuted;
    }
  }

  Color _statusBgColor(String status, AppColorTheme t) {
    switch (status) {
      case 'Completed':
        return t.success.withValues(alpha: 0.1);
      case 'In Progress':
        return t.primary.withValues(alpha: 0.08);
      case 'Locked':
      default:
        return t.surfaceVariant.withValues(alpha: 0.4);
    }
  }

  Color _statusBorderColor(String status, AppColorTheme t) {
    switch (status) {
      case 'Completed':
        return t.success.withValues(alpha: 0.3);
      case 'In Progress':
        return t.primary.withValues(alpha: 0.25);
      case 'Locked':
      default:
        return t.border;
    }
  }
}
