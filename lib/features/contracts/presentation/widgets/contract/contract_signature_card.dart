import 'package:apartment/features/contracts/domain/entities/contract_entity.dart';
import 'package:apartment/features/contracts/domain/entities/contract_type.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:signature/signature.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';

import 'contract_terms_bottom_sheet.dart';

class ContractSignatureCard extends StatelessWidget {
  final SignatureController controller;
  final bool isAgreed;
  final ContractType contractType;
  final ContractEntity? contract;
  final ValueChanged<bool?> onAgreementChanged;

  const ContractSignatureCard({
    super.key,
    required this.controller,
    required this.isAgreed,
    required this.contractType,
    this.contract,
    required this.onAgreementChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
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
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l10n.signature, 
                    style: TextStyle(
                      fontSize: AppFonts.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (isAgreed) {
                        onAgreementChanged(false);
                      } else {
                        ContractTermsBottomSheet.show(
                          context,
                          contractType: contractType,
                          contract: contract,
                          isAgreed: isAgreed,
                          onAgreed: (val) {
                            onAgreementChanged(val);
                          },
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Checkbox(
                            value: isAgreed,
                            onChanged: (val) {
                              if (val == true) {
                                ContractTermsBottomSheet.show(
                                  context,
                                  contractType: contractType,
                                  contract: contract,
                                  isAgreed: isAgreed,
                                  onAgreed: (val) => onAgreementChanged(val),
                                );
                              } else {
                                onAgreementChanged(false);
                              }
                            },
                            activeColor: context.colors.success,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Text(
                          'الشروط والأحكام',
                          style: TextStyle(
                            fontSize: AppFonts.bodyMedium,
                            fontWeight: isAgreed ? FontWeight.bold : FontWeight.normal,
                            color: isAgreed ? context.colors.success : context.colors.textSecondary,
                            decoration: TextDecoration.underline,
                            decorationColor: isAgreed ? context.colors.success : context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    onPressed: () => controller.clear(),
                    icon: Icon(FluentIcons.delete_24_regular, size: 20, color: context.colors.error),
                    tooltip: l10n.clearSignature,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Divider(color: context.colors.background),
          const SizedBox(height: AppSpacing.sm),
          
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
          
          const SizedBox(height: AppSpacing.sm),
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
