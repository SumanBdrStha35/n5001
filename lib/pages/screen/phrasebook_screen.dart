// Data Models for Dynamic Content
import 'package:flutter/material.dart';

import '../../model/cat_item.dart';
import '../../model/feat_phrase.dart';
import '../../other/app_colors_theme.dart';

class PhrasebookPage extends StatefulWidget {
  const PhrasebookPage({super.key});

  @override
  State<PhrasebookPage> createState() => _PhrasebookPageState();
}

class _PhrasebookPageState extends State<PhrasebookPage> {
  // Dynamic Data Lists
  final List<CategoryItem> categories = [
    const CategoryItem(
      title: 'Greetings',
      phraseCount: '24 phrases',
      icon: Icons.front_hand_outlined,
      iconColor: Colors.indigo,
      backgroundColor: Color(0xFFE8F0FE),
    ),
    const CategoryItem(
      title: 'Expressions',
      phraseCount: '18 phrases',
      icon: Icons.chat_bubble_outline,
      iconColor: Colors.teal,
      backgroundColor: Color(0xFFE0F2F1),
    ),
    const CategoryItem(
      title: 'Numbers &\nCounters',
      phraseCount: '32 phrases',
      icon: Icons.pin_outlined,
      iconColor: Colors.amber,
      backgroundColor: Color(0xFFFFF8E1),
    ),
    const CategoryItem(
      title: 'Colors',
      phraseCount: '15 phrases',
      icon: Icons.palette_outlined,
      iconColor: Colors.purple,
      backgroundColor: Color(0xFFF3E5F5),
    ),
    const CategoryItem(
      title: 'Time\nexpression',
      phraseCount: '20 phrases',
      icon: Icons.access_time,
      iconColor: Colors.green,
      backgroundColor: Color(0xFFE8F5E9),
    ),
    const CategoryItem(
      title: 'Family\nterms',
      phraseCount: '12 phrases',
      icon: Icons.favorite_border,
      iconColor: Colors.brown,
      backgroundColor: Color(0xFFFFEBEE),
    ),
    const CategoryItem(
      title: 'Body',
      phraseCount: '28 phrases',
      icon: Icons.person_outline,
      iconColor: Colors.deepPurple,
      backgroundColor: Color(0xFFF3E5F5),
    ),
    const CategoryItem(
      title: 'Verb\nphrases',
      phraseCount: '45 phrases',
      icon: Icons.directions_run,
      iconColor: Colors.blueGrey,
      backgroundColor: Color(0xFFECEFF1),
    ),
  ];

  final FeaturedPhrase featured = const FeaturedPhrase(
    nativeText: 'こんにちは',
    romanizedText: 'Konnichiwa',
    translation: 'Hello / Good Afternoon',
  );

  @override
  Widget build(BuildContext context) {
    final theme = AppColorsTheme.of(context);

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: theme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.border),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: theme.textMuted),
                    hintText: 'Search phrases, words...',
                    hintStyle: TextStyle(color: theme.textMuted),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Grid of Categories
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.border.withValues(alpha: 0.7),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            item.icon,
                            color: item.iconColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: theme.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.phraseCount,
                                style: TextStyle(
                                  color: theme.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // More Categories Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.border.withValues(alpha: 0.7),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.more_horiz, color: theme.textMuted),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'More Categories',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: theme.textPrimary,
                          ),
                        ),
                        Text(
                          'Travel, Shopping, Food & More',
                          style: TextStyle(
                            color: theme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Featured Phrase Header
              Text(
                'Featured Phrase',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Featured Phrase Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.primaryDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          featured.nativeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          featured.romanizedText,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          featured.translation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
