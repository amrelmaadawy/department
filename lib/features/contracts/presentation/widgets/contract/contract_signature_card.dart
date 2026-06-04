import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:signature/signature.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';

class ContractSignatureCard extends StatelessWidget {
  final SignatureController controller;

  const ContractSignatureCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // We will reuse some localization from terms or create a generic title if none exists.
    // Assuming we have 'signature' from previous ARB updates: "Signature" / "التوقيع"
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withValues(alpha: 0.1),
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
              Row(
                children: [
                  const Icon(FluentIcons.pen_24_regular, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l10n.signature, // Make sure this exists in ARB
                    style: const TextStyle(
                      fontSize: AppFonts.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => controller.clear(),
                icon: const Icon(FluentIcons.delete_24_regular, size: 16, color: AppColors.error),
                label: const Text(
                  'مسح التوقيع', // Ideally localized
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.background),
          const SizedBox(height: AppSpacing.md),
          
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Signature(
                controller: controller,
                height: 150,
                backgroundColor: AppColors.background,
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.sm),
          const Center(
            child: Text(
              'يرجى التوقيع داخل المربع أعلاه', // Ideally localized
              style: TextStyle(
                fontSize: AppFonts.bodySmall,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
