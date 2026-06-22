import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../l10n/app_localizations.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Icon Container
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: context.colors.gold.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.colors.gold.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        FluentIcons.checkmark_starburst_24_filled,
                        size: 80,
                        color: context.colors.gold,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              
              // Title
              Text(
                l10n.paymentSuccessTitle,
                style: TextStyle(
                  fontSize: AppFonts.displaySmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              
              // Subtitle
              Text(
                l10n.paymentSuccessSubtitle,
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  color: context.colors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to home/dashboard
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.goToDashboard,
                    style: TextStyle(
                      fontSize: AppFonts.headlineSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
