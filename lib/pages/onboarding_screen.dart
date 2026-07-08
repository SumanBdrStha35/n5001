import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../app_routes.dart';
import '../other/app_colors.dart';
import '../other/app_sizes.dart';
import '../service/local_storage_service.dart';

import 'onboarding_screen/goals_screen.dart';
import 'onboarding_screen/level_screen.dart';
import 'onboarding_screen/plan_screen.dart';
import 'onboarding_screen/study_time_screen.dart';
import 'onboarding_screen/welcome_screen.dart';

/// Holds onboarding user preferences
class OnboardingData {
  String? selectedLevel;
  String? selectedGoal;
  String? studyMinutesPerDay;
  bool notificationsEnabled = false;

  OnboardingData copy({
    String? selectedLevel,
    String? selectedGoal,
    String? studyMinutesPerDay,
    bool? notificationsEnabled,
  }) {
    return OnboardingData()
      ..selectedLevel = selectedLevel ?? this.selectedLevel
      ..selectedGoal = selectedGoal ?? this.selectedGoal
      ..studyMinutesPerDay = studyMinutesPerDay ?? this.studyMinutesPerDay
      ..notificationsEnabled =
          notificationsEnabled ?? this.notificationsEnabled;
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  late OnboardingData _onboardingData;

  // Loading flag (kept for potential future use)
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    // If onboarding already completed once, skip directly.
    LocalStorageService.isOnboardingCompleted().then((completed) {
      if (!mounted) return;
      if (completed) {
        print('Onboarding already completed. Navigating to login.');
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      } else {
        setState(() {
          _loading = false;
        });
      }
    });

    _pageController = PageController();
    _onboardingData = OnboardingData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateOnboardingData(OnboardingData data) {
    setState(() {
      _onboardingData = data;
    });
  }

  void _goToNextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    // Ask notification permission and show success/failure.
    try {
      final status = await Permission.notification.request();

      if (!mounted) return;

      if (status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifications enabled successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifications permission not granted.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Mark onboarding as completed and navigate to login.
      await LocalStorageService.setOnboardingCompleted(true);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to request notification permission: $e'),
          backgroundColor: const Color.fromARGB(255, 84, 15, 245),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.only(
                  top: AppSizes.paddingLg,
                  left: AppSizes.paddingLg,
                  right: AppSizes.paddingLg,
                ),
                child: Row(
                  children: List.generate(5, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: _currentPage >= index
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              // PageView
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    const WelcomePage(),
                    LevelPage(
                      data: _onboardingData,
                      onUpdate: _updateOnboardingData,
                    ),
                    GoalPage(
                      data: _onboardingData,
                      onUpdate: _updateOnboardingData,
                    ),
                    StudyTimePage(
                      data: _onboardingData,
                      onUpdate: _updateOnboardingData,
                    ),
                    StudyPlanPage(
                      data: _onboardingData,
                      onUpdate: _updateOnboardingData,
                    ),
                  ],
                ),
              ),
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      OutlinedButton.icon(
                        onPressed: _goToPreviousPage,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                      )
                    else
                      const SizedBox.shrink(),
                    ElevatedButton.icon(
                      onPressed: _goToNextPage,
                      icon: Icon(
                        _currentPage == 4 ? Icons.check : Icons.arrow_forward,
                      ),
                      label: Text(_currentPage == 4 ? 'Complete' : 'Next'),
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
