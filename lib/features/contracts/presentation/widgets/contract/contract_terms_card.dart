import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../../../domain/entities/contract_type.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ContractTermsCard extends StatelessWidget {
  final ContractType contractType;
  final bool isAgreed;
  final ValueChanged<bool?> onChanged;

  const ContractTermsCard({
    super.key,
    required this.contractType,
    required this.isAgreed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            children: [
              Icon(FluentIcons.document_text_24_regular, color: context.colors.primary),
              SizedBox(width: AppSpacing.sm),
              Text(
                l10n.contractTermsTitle,
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Divider(color: context.colors.background),
          SizedBox(height: AppSpacing.md),
          
          Container(
            height: 150,
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: SingleChildScrollView(
              child: Text(
                contractType == ContractType.unit 
                ? l10n.unitContractTerms
                : l10n.finishingContractTerms,
                style: TextStyle(
                  fontSize: AppFonts.bodySmall,
                  color: context.colors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ),
          
          SizedBox(height: AppSpacing.md),
          
          Row(
            children: [
              Checkbox(
                value: isAgreed,
                onChanged: onChanged,
                activeColor: context.colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(!isAgreed),
                  child: Text(
                    l10n.iAgreeToTerms,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color: isAgreed ? context.colors.primary : context.colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
