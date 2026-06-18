import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_extension.dart';
import '../../../../../l10n/app_localizations.dart';

class AiRendersPendingView extends StatelessWidget {
  final String statusLabel;

  const AiRendersPendingView({super.key, required this.statusLabel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.colors.primary.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                FluentIcons.sparkle_24_filled,
                size: 80,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Builder(
              builder: (context) => Text(
                AppLocalizations.of(context)!.aiWorkingTitle,
                style: TextStyle(
                  fontSize: AppFonts.headlineMedium,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Builder(
              builder: (context) => Text(
                statusLabel.isNotEmpty ? statusLabel : AppLocalizations.of(context)!.aiWorkingSubtitle,
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: context.colors.primary,
                backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                strokeCap: StrokeCap.round,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
