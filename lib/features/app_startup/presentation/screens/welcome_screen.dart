import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Dark Overlay
          Positioned.fill(child: Container(color: AppColors.darkOverlay)),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xxl,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Logo
                  Image.asset(
                    'assets/images/welcome_logo.png',
                    height: AppSizes.logoMedium,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Title
                  Text(
                    l10n.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: AppFonts.displayLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Subtitle
                  Text(
                    l10n.welcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: AppFonts.bodyLarge,
                    ),
                  ),

                  const Spacer(),

                  // Primary Button
                  CustomButton(
                    text: l10n.startNow,
                    onPressed: () {
                      context.push(AppRouter.auth);
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Secondary Button
                  TextButton(
                    onPressed: () {
                      // TODO: Explore as host
                    },
                    child: Text(
                      l10n.exploreAsHost,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: AppFonts.bodyLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
