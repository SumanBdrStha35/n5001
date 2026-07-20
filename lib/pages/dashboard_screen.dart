import 'package:flutter/material.dart';

import 'screen/home_screen.dart';
import 'screen/learn_screen.dart';
import 'screen/phrasebook_screen.dart';
import 'screen/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    // const _PlaceholderScreen(title: 'Learn'),
    JapaneseLearningBody(),
    const _PlaceholderScreen(title: 'Practice'),
    // const _PlaceholderScreen(title: 'Phrasebook'),
    PhrasebookPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.menu_book_outlined, 'label': 'Learn'},
      {'icon': Icons.sports_martial_arts_outlined, 'label': 'Practice'},
      {'icon': Icons.translate_outlined, 'label': 'Phrasebook'},
      {'icon': Icons.more_horiz, 'label': 'More'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF3B5BDB).withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        items[index]['icon'] as IconData,
                        color: isSelected
                            ? const Color(0xFF3B5BDB)
                            : Colors.black38,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? const Color(0xFF3B5BDB)
                            : Colors.black38,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}

/// Like `IndexedStack` from `flutter` examples, but safe to use.
class IndexedStack extends StatelessWidget {
  final int index;
  final List<Widget> children;

  const IndexedStack({super.key, required this.index, required this.children});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(children.length, (i) {
        return Offstage(
          offstage: i != index,
          child: TickerMode(
            enabled: i == index,
            child: SizedBox.expand(child: children[i]),
          ),
        );
      }),
    );
  }
}
