// --- Data Models ---
import 'package:flutter/material.dart';

class ScriptCardData {
  final String title;
  final String charCount;
  final List<String> characters;
  final String progressText;
  final double progressPercent;
  final String actionText;
  final bool isStarted;

  const ScriptCardData({
    required this.title,
    required this.charCount,
    required this.characters,
    required this.progressText,
    required this.progressPercent,
    required this.actionText,
    required this.isStarted,
  });
}

class LessonData {
  final String title;
  final String subtitle;
  final String statusText;
  final IconData icon;
  final Color themeColor;
  final Color backgroundColor;
  final Color borderIndexColor;

  const LessonData({
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.icon,
    required this.themeColor,
    required this.backgroundColor,
    required this.borderIndexColor,
  });
}

// --- Main Body Widget ---
class JapaneseLearningBody extends StatefulWidget {
  const JapaneseLearningBody({super.key});

  @override
  State<JapaneseLearningBody> createState() => _JapaneseLearningBodyState();
}

class _JapaneseLearningBodyState extends State<JapaneseLearningBody> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Scripts', 'Kanji', 'Vocabulary', 'Grammar'];

  final List<ScriptCardData> _scriptCards = [
    const ScriptCardData(
      title: 'Hiragana',
      charCount: '46 chars',
      characters: ['あ', 'い', 'う', 'え', 'お', 'か', 'き', 'く', 'け', 'こ'],
      progressText: 'Lesson 3 of 9 complete',
      progressPercent: 0.33,
      actionText: 'Continue',
      isStarted: true,
    ),
    const ScriptCardData(
      title: 'Katakana',
      charCount: '46 chars',
      characters: ['ア', 'イ', 'ウ', 'エ', 'オ', 'カ', 'キ', 'ク', 'ケ', 'コ'],
      progressText: 'Lesson 0 of 9 — Not started',
      progressPercent: 0.0,
      actionText: 'Start Learning',
      isStarted: false,
    ),
  ];

  final List<LessonData> _lessons = [
    const LessonData(
      title: 'Lesson 1',
      subtitle: 'Vowels あいうえお',
      statusText: 'Completed',
      icon: Icons.check,
      themeColor: Color(0xFF198754),
      backgroundColor: Color(0xFFF1F9F5),
      borderIndexColor: Color(0xFFD1E7DD),
    ),
    const LessonData(
      title: 'Lesson 2',
      subtitle: 'K-series かきくけこ',
      statusText: 'Completed',
      icon: Icons.check,
      themeColor: Color(0xFF198754),
      backgroundColor: Color(0xFFF1F9F5),
      borderIndexColor: Color(0xFFD1E7DD),
    ),
    const LessonData(
      title: 'Lesson 3',
      subtitle: 'S-series さしすせそ',
      statusText: 'In Progress',
      icon: Icons.play_arrow,
      themeColor: Color(0xFF0D6EFD),
      backgroundColor: Color(0xFFF8FAFF),
      borderIndexColor: Color(0xFFD2E3FC),
    ),
    const LessonData(
      title: 'Lesson 4',
      subtitle: 'T-series たちつてと',
      statusText: 'Locked',
      icon: Icons.lock_outline,
      themeColor: Colors.grey,
      backgroundColor: Color(0xFFF8F9FA),
      borderIndexColor: Color(0xFFE9ECEF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Custom Tab Selector
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final isSelected = _selectedTab == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected
                            ? const Color(0xFF0D6EFD)
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF0D6EFD)
                          : Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Scrollable Body Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Script Progress Cards
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _scriptCards.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildScriptCard(_scriptCards[index]);
                  },
                ),
                const SizedBox(height: 28),

                // Section Title
                const Text(
                  'Lesson-wise practice',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // Lesson List Cards
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _lessons.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildLessonCard(_lessons[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Card view for Hiragana / Katakana
  Widget _buildScriptCard(ScriptCardData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF7EE),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  data.charCount,
                  style: const TextStyle(
                    color: Color(0xFF28A745),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Character Preview Grid
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
                  color: const Color(0xFFF1F4FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  data.characters[i],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004085),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Progress Tracking Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.progressText,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              if (data.progressPercent > 0)
                Text(
                  '${(data.progressPercent * 100).toInt()}%',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: data.progressPercent,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF0D6EFD),
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),

          // Action Options Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0D6EFD),
                    side: BorderSide(color: Colors.grey.shade300),
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
                    backgroundColor: data.isStarted
                        ? const Color(0xFF0D6EFD)
                        : const Color(0xFF3B7DDD),
                    foregroundColor: Colors.white,
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
    );
  } // Custom List Row for Practice Items

  Widget _buildLessonCard(LessonData lesson) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lesson.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: lesson.borderIndexColor),
      ),
      child: Row(
        children: [
          // Status Action Icon Circle
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: lesson.themeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(lesson.icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14), // Text Content Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lesson.subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ), // State Label Text
          Text(
            lesson.statusText,
            style: TextStyle(
              color: lesson.themeColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
