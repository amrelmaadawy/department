import 'package:apartment/core/theme/app_colors.dart';
import 'dart:ui';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_sizes.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/routes/app_router.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:apartment/features/settings/presentation/cubit/settings_state.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _bgScale;
  late Animation<double> _glassOpacity;
  late Animation<double> _contentOpacity;
  late Animation<double> _taglineOpacity;

  @override
  void initState() {
    super.initState();

    // Total duration: 4 seconds for a majestic, slow cinematic reveal
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // 1. Background image slowly zooms in (Ken Burns effect)
    _bgScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutSine),
      ),
    );

    // 2. Glass container fades in
    _glassOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );

    // 3. Logo fades in
    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    // 4. Tagline fades in
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.85, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Automatically navigate after animation finishes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            context.go(AppRouter.auth);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Background Image with Ken Burns Effect
              Transform.scale(
                scale: _bgScale.value,
                child: Image.asset(
                  'assets/images/welcome_background.png',
                  fit: BoxFit.cover,
                ),
              ),

              // Subtle global dark overlay so the glass pops out
              Container(color: AppColors.black.withValues(alpha: 0.3)),

              // Content Layout
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xxl,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cinematic Glass Panel
                      Opacity(
                        opacity: _glassOpacity.value,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.xl,
                                horizontal: AppSpacing.lg,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.xl,
                                ),
                                border: Border.all(
                                  color: AppColors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: BlocBuilder<SettingsCubit, SettingsState>(
                                builder: (context, state) {
                                  final title = (state is SettingsLoaded && state.settings.siteName.isNotEmpty)
                                      ? state.settings.siteName
                                      : l10n.welcomeTitle;
                                  final description = (state is SettingsLoaded && state.settings.siteDescription.isNotEmpty)
                                      ? state.settings.siteDescription
                                      : l10n.welcomeSubtitle;

                                  return Column(
                                    children: [
                                      // Logo
                                      Opacity(
                                        opacity: _contentOpacity.value,
                                        child: (state is SettingsLoading || state is SettingsInitial)
                                            ? SizedBox(height: AppSizes.logoMedium)
                                            : (state is SettingsLoaded && state.settings.siteLogo.isNotEmpty)
                                                ? Image.network(
                                                    state.settings.siteLogo,
                                                    height: AppSizes.logoMedium,
                                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                                      'assets/images/لين فخامة معتمد.png',
                                                      height: AppSizes.logoMedium,
                                                    ),
                                                  )
                                                : Image.asset(
                                                    'assets/images/لين فخامة معتمد.png',
                                                    height: AppSizes.logoMedium,
                                                  ),
                                      ),

                                      const SizedBox(height: AppSpacing.sm),

                                      // Tagline
                                      Opacity(
                                        opacity: _taglineOpacity.value,
                                        child: Column(
                                          children: [
                                            Text(
                                              title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: context.colors.gold,
                                                fontSize: AppFonts.bodyLarge,
                                                letterSpacing: 2.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: AppSpacing.sm),
                                            Text(
                                              description,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: AppFonts.bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
