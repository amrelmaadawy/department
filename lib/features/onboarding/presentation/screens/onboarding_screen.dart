import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRouter.auth);
    }
  }

  void _onSkipPressed() {
    context.go(AppRouter.auth);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final onboardingData = [
      {
        'title': l10n.onboardingTitle1,
        'subtitle': l10n.onboardingSubtitle1,
        'image': 'assets/images/onboarding/onboarding1.png',
      },
      {
        'title': l10n.onboardingTitle2,
        'subtitle': l10n.onboardingSubtitle2,
        'image': 'assets/images/onboarding/onboarding2.png',
      },
      {
        'title': l10n.onboardingTitle3,
        'subtitle': l10n.onboardingSubtitle3,
        'image': 'assets/images/onboarding/onboarding3.png',
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background Images PageView
          PageView.builder(
            reverse: true,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    onboardingData[index]['image']!,
                    fit: BoxFit.cover,
                  ),
                  // Dark overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Skip Button
          SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: TextButton(
                  onPressed: _onSkipPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    l10n.skip,
                    style: const TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content Glass Card
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.3), // Slides up
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              onboardingData[_currentIndex]['title']!,
                              key: ValueKey<String>(onboardingData[_currentIndex]['title']!),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: context.colors.gold,
                                fontSize: AppFonts.headlineSmall,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          // Subtitle
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.2), // Slightly less slide than title for staggered feel
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              onboardingData[_currentIndex]['subtitle']!,
                              key: ValueKey<String>(onboardingData[_currentIndex]['subtitle']!),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppFonts.bodyMedium,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Bottom Row: Indicators and Next Button
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Dot Indicators
                                Row(
                                  children: List.generate(
                                    onboardingData.length,
                                    (index) => AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      margin: EdgeInsetsDirectional.only(end: 8),
                                      height: 8,
                                      width: _currentIndex == index ? 24 : 8,
                                      decoration: BoxDecoration(
                                        color: _currentIndex == index
                                            ? context.colors.gold
                                            : Colors.white.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),

                              // Next / Start Button
                              GestureDetector(
                                onTap: _onNextPressed,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: _currentIndex == onboardingData.length - 1 ? 120 : 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: context.colors.primary,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: _currentIndex == onboardingData.length - 1
                                        ? Text(
                                            l10n.startNow,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppFonts.bodyMedium,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Icon(
                                            Icons.arrow_forward_ios,
                                                color: Colors.white,
                                            size: 20,
                                          ),
                                  ),
                                ),
                              ),
                        ])
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
