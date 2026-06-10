import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:signature/signature.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';


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
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: context.colors.border.withValues(alpha: 0.1),
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
                  Icon(FluentIcons.pen_24_regular, color: context.colors.primary),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    l10n.signature, // Make sure this exists in ARB
                    style: TextStyle(
                      fontSize: AppFonts.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => controller.clear(),
                icon: Icon(FluentIcons.delete_24_regular, size: 16, color: context.colors.error),
                label: Text(
                  l10n.clearSignature,
                  style: TextStyle(color: context.colors.error),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Divider(color: context.colors.background),
          SizedBox(height: AppSpacing.md),
          
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: context.colors.border),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Signature(
                controller: controller,
                height: 150,
                backgroundColor: context.colors.background,
              ),
            ),
          ),
          
          SizedBox(height: AppSpacing.sm),
          Center(
            child: Text(
              l10n.signAbove,
              style: TextStyle(
                fontSize: AppFonts.bodySmall,
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
