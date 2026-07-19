import 'package:flutter/material.dart';

import '../../app.dart';
import '../../service/theme_service.dart';
import '../../widgets/app_card_container.dart';
import 'profile_widget/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _dailyReminders = true;
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await ThemeService.loadThemeMode();
    setState(() => _isDarkMode = mode == ThemeMode.dark);
  }

  Future<void> _onToggleDark(bool val) async {
    setState(() => _isDarkMode = val);
    final newMode = val ? ThemeMode.dark : ThemeMode.light;
    // Update the app theme controller immediately (live UI update).
    N5MasteryApp.setMode(context, newMode);
    // Persist to theme service. App.dart reads it via ThemeService.loadThemeMode()
    // on next app rebuild.
    await ThemeService.saveThemeMode(newMode);

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileCard(),
            const SizedBox(height: 24),

            const SectionHeader(title: 'LEARNING'),
            AppCardContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MenuTile(
                    icon: Icons.bar_chart_rounded,
                    iconColor: Colors.red,
                    title: 'My progress & stats',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 50),
                  MenuTile(
                    icon: Icons.bookmark_border_rounded,
                    iconColor: Colors.red,
                    title: 'Saved / Bookmarks',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const SectionHeader(title: 'APP SETTINGS'),
            AppCardContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchTile(
                    icon: Icons.notifications_none_rounded,
                    iconColor: Colors.red,
                    title: 'Daily Reminders',
                    value: _dailyReminders,
                    onChanged: (val) => setState(() => _dailyReminders = val),
                  ),
                  const Divider(height: 1, indent: 50),
                  SwitchTile(
                    icon: Icons.dark_mode_outlined,
                    iconColor: Colors.red,
                    title: 'Dark Mode',
                    value: _isDarkMode,
                    onChanged: _onToggleDark,
                  ),
                  const Divider(height: 1, indent: 50),
                  MenuTile(
                    icon: Icons.palette_outlined,
                    iconColor: Colors.red,
                    title: 'Appearance',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const SectionHeader(title: 'SUPPORT & INFO'),
            AppCardContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MenuTile(
                    icon: Icons.help_outline_rounded,
                    iconColor: Colors.red,
                    title: 'Help Center',
                    trailing: const Icon(
                      Icons.open_in_new_rounded,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 50),
                  MenuTile(
                    icon: Icons.chat_bubble_outline_rounded,
                    iconColor: Colors.red,
                    title: 'Send Feedback',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 50),
                  MenuTile(
                    icon: Icons.info_outline_rounded,
                    iconColor: Colors.red,
                    title: 'About NihonGo',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEBEE),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color(0xFFC62828),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Center(
              child: Text(
                'Version 1.2.0',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper UI Custom Widgets ---
class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const Text(
              'A',
              style: TextStyle(
                color: Color(0xFFC62828),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aryan',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Level 4 Learner',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Edit profile',
              style: TextStyle(
                color: Color(0xFF8B0000),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatItem('12', 'Streak', isFirst: true)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem('18', 'Lessons')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem('340', 'XP')),
      ],
    );
  }

  Widget _buildStatItem(String count, String label, {bool isFirst = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isFirst ? const Color(0xFFC62828) : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  final List<Widget> children;
  const CardContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }
}

class MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const MenuTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure ListTile ink/ripple has a dedicated Material ancestor.
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        trailing:
            trailing ??
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

class SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure ListTile ink/ripple has a dedicated Material ancestor.
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFFC62828),
        ),
      ),
    );
  }
}
