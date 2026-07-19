import 'package:flutter/material.dart';

import '../../../other/app_colors.dart';
import '../../../other/app_colors_theme.dart';
import '../../../service/user_profile_service.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String?>(
              future: const UserProfileService().getCurrentUser().then(
                (u) => u?.username,
              ),
              builder: (context, snapshot) {
                final username = snapshot.data?.trim();
                final displayName = (username == null || username.isEmpty)
                    ? 'Suman'
                    : username;

                final hour = DateTime.now().hour;
                final greeting = hour < 12
                    ? 'Good morning'
                    : hour < 18
                    ? 'Good afternoon'
                    : 'Good evening';

                final greetingJa = hour < 12
                    ? 'おはようございます'
                    : hour < 18
                    ? 'こんにちは'
                    : 'こんばんは';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greetingJa,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '$greeting, $displayName',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.indigoPrimary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.black87,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: AppColors.black87,
              ),
              onPressed: () {},
            ),
            FutureBuilder<String?>(
              future: const UserProfileService().getCurrentUser().then(
                (u) => u?.username,
              ),
              builder: (context, snapshot) {
                final username = snapshot.data?.trim() ?? '';
                final initial = username.isNotEmpty
                    ? username.characters.first.toUpperCase()
                    : 'S';

                return CircleAvatar(
                  backgroundColor: AppColorsTheme.primary(context),
                  radius: 18,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
