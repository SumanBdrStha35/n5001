import 'package:flutter/material.dart';

import '../../../data/user_store.dart';
import '../../../other/app_colors_theme.dart';
import '../../../service/user_profile_service.dart';
import '../../../widgets/app_card_container.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppColorsTheme.of(context);

    final cardBorderColor = t.border;
    final avatarBgColor = Colors.transparent;
    final primaryBlue = t.primary;
    final statBoxBgColor = Colors.transparent;

    final textDark = t.textPrimary;
    final textMuted = t.textMuted;

    return FutureBuilder<AppUser?>(
      future: const UserProfileService().getCurrentUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        final displayName = (user?.username?.trim().isNotEmpty ?? false)
            ? user!.username!.trim()
            : (user?.email.trim().isNotEmpty ?? false)
            ? user!.email
            : 'Guest';

        final initials = _initialsFromName(displayName);
        // NOTE: Current app model only stores email/username/password.
        // Keep existing stats UI but make them dynamic placeholders for now.
        // If you add streak/lessons/points to AppUser later, wire them here.
        // New users should start at 0 streak/lessons/points.
        // Once lesson completion logic is implemented, these should be loaded
        // from/persisted to the user model.
        const streakCount = '0';
        const lessonsCount = '0';
        const pointsCount = '0 XP';

        return AppCardContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Section: Avatar, Name, and Edit Profile Button
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar with initials
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: avatarBgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primaryBlue, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: primaryBlue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Name and Level Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textDark,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            // Placeholder; wire to real level later.
                            'Level 4',
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Edit Profile Action
                    TextButton(
                      onPressed: () {
                        // TODO: Implement Edit Profile Navigation
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                      child: Text(
                        'Edit profile',
                        style: TextStyle(
                          color: primaryBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Bottom Section: Stats Row (Streak, Lessons, Points)
              Row(
                children: [
                  Expanded(
                    child: _buildStatBox(
                      valueWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$streakCount ',
                            style: TextStyle(
                              color: textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('🔥', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      label: 'Streak',
                      bgColor: statBoxBgColor,
                      labelColor: textMuted,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatBox(
                      valueWidget: Text(
                        lessonsCount,
                        style: TextStyle(
                          color: textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      label: 'Lessons',
                      bgColor: statBoxBgColor,
                      labelColor: textMuted,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatBox(
                      valueWidget: Text(
                        pointsCount,
                        style: TextStyle(
                          color: textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      label: 'Points',
                      bgColor: statBoxBgColor,
                      labelColor: textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Private helper method to keep structural layout clean and reusable
  Widget _buildStatBox({
    required Widget valueWidget,
    required String label,
    required Color bgColor,
    required Color labelColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          valueWidget,
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  static String _initialsFromName(String name) {
    final cleaned = name.trim();
    if (cleaned.isEmpty) return 'G';

    final parts = cleaned
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.length == 1) {
      final s = parts.first;
      return (s.length >= 2)
          ? s.substring(0, 2).toUpperCase()
          : s.substring(0, 1).toUpperCase();
    }

    final first = parts.first[0];
    final last = parts.last[0];
    return '${first.toUpperCase()}${last.toUpperCase()}';
  }
}
