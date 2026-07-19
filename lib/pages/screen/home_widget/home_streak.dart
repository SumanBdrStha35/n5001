import 'package:flutter/material.dart';

import '../../../other/app_colors.dart';

class HomeStreak extends StatelessWidget {
  const HomeStreak({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final now = DateTime.now();
    final currentDayIndex = now.weekday - 1;

    // Placeholder dynamic values
    const currentStreak = 12;
    const currentXp = 340;
    const maxXp = 500;
    const currentLevel = 4;

    final activeDays = List.generate(7, (index) => index < currentDayIndex);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black54Pure.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$currentStreak',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.amberStreak,
                    ),
                  ),
                  const Text(
                    'DAY STREAK',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black54,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              // Prevent right-side layout overflows
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(days.length, (index) {
                        final isToday = index == currentDayIndex;
                        final isActive = activeDays[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Container(
                            decoration: isToday
                                ? BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.amberStreak,
                                      width: 2,
                                    ),
                                  )
                                : null,
                            padding: isToday
                                ? const EdgeInsets.all(2)
                                : EdgeInsets.zero,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: isActive
                                  ? AppColors.amberStreak
                                  : AppColors.black26Pure,
                              child: Text(
                                days[index],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isActive
                                      ? AppColors.cardWhite
                                      : AppColors.black38,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'XP $currentXp / $maxXp',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black87,
                ),
              ),
              Text(
                'Lv. $currentLevel',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: currentXp / maxXp,
              backgroundColor: AppColors.progressBg,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.amberStreak,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
