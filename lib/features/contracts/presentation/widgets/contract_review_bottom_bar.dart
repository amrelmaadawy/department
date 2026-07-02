import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/l10n/app_localizations.dart';

class ContractReviewBottomBar extends StatelessWidget {
  final bool isPrinting;
  final bool pdfReady;
  final VoidCallback onPrint;
  final VoidCallback onBack;
  final AppLocalizations l10n;

  const ContractReviewBottomBar({
    super.key,
    required this.isPrinting,
    required this.pdfReady,
    required this.onPrint,
    required this.onBack,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.white,
        border: Border(top: BorderSide(color: context.colors.border.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.primary,
              side: BorderSide(color: context.colors.primary.withValues(alpha: 0.4)),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
            icon: const Icon(FluentIcons.arrow_left_24_regular, size: 18),
            label: const Text('رجوع', style: TextStyle(fontSize: AppFonts.bodySmall, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: (isPrinting || !pdfReady) ? null : onPrint,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: context.colors.primary.withValues(alpha: 0.35),
                disabledForegroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                elevation: 0,
              ),
              icon: isPrinting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                  : const Icon(FluentIcons.print_24_regular, size: 18),
              label: Text(
                isPrinting ? 'جاري الطباعة...' : !pdfReady ? 'جاري التحضير...' : l10n.printContract,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: AppFonts.bodySmall, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
