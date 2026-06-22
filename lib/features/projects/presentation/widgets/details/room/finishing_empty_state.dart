import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';

class FinishingEmptyState extends StatelessWidget {
  const FinishingEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      key: const ValueKey('empty_state'),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FluentIcons.box_24_regular,
            size: 48,
            color: context.colors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.noMaterialsAvailable,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
