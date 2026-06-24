import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../domain/entities/contract_type.dart';
import '../../../domain/entities/contract_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class ContractTermsCard extends StatefulWidget {
  final ContractType contractType;
  final ContractEntity? contract;
  final bool isAgreed;
  final ValueChanged<bool?> onChanged;

  const ContractTermsCard({
    super.key,
    required this.contractType,
    this.contract,
    required this.isAgreed,
    required this.onChanged,
  });

  @override
  State<ContractTermsCard> createState() => _ContractTermsCardState();
}

class _ContractTermsCardState extends State<ContractTermsCard> {

  void _showDetailedLegalTerms(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (modalContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95, // 95% of screen for immersive reading
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Column(
            children: [
              // Minimal Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Minimal Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.contractTermsTitle,
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(FluentIcons.dismiss_24_regular),
                      onPressed: () => Navigator.pop(modalContext),
                      style: IconButton.styleFrom(
                        backgroundColor: context.colors.background,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Article Reader Body (Medium Style)
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                  child: widget.contract != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.contract!.contractBody.map((item) {
                            if (item.type == 'title') {
                              return Padding(
                                padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.md),
                                child: Text(
                                  item.content ?? '',
                                  style: TextStyle(
                                    fontSize: AppFonts.headlineSmall,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              );
                            } else if (item.type == 'paragraph') {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                                child: Text(
                                  item.content ?? '',
                                  style: TextStyle(
                                    fontSize: AppFonts.bodyLarge,
                                    color: context.colors.textSecondary,
                                    height: 2.2, // Very high line height for comfortable reading
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              );
                            } else if (item.type == 'list') {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                                child: HtmlWidget(
                                  item.html ?? '',
                                  textStyle: TextStyle(
                                    fontSize: AppFonts.bodyLarge,
                                    color: context.colors.textSecondary,
                                    height: 2.2,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }).toList(),
                        )
                      : Text(
                          widget.contractType == ContractType.unit 
                          ? l10n.unitContractTerms
                          : l10n.finishingContractTerms,
                          style: TextStyle(
                            fontSize: AppFonts.bodyLarge,
                            color: context.colors.textSecondary,
                            height: 2.2,
                            letterSpacing: 0.2,
                          ),
                        ),
                ),
              ),
              // Sticky Footer for Agreement
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: context.colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.border.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: widget.isAgreed ? null : () {
                      widget.onChanged(true);
                      Navigator.pop(modalContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isAgreed ? context.colors.border : context.colors.primary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      widget.isAgreed ? l10n.signedSuccessfully : l10n.confirmAndAgree,
                      style: TextStyle(
                        fontSize: AppFonts.bodyLarge,
                        fontWeight: FontWeight.bold,
                        color: widget.isAgreed ? context.colors.textSecondary : context.colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isUnitContract = widget.contractType == ContractType.unit;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: context.colors.border.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(FluentIcons.document_text_24_filled, color: context.colors.primary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.contractSummary,
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Bento Summary Boxes
          Row(
            children: [
              Expanded(
                child: _buildBentoBox(
                  context: context,
                  icon: FluentIcons.building_24_regular,
                  title: isUnitContract ? l10n.propertySaleContract : l10n.finishingContract,
                  subtitle: l10n.comparisonType,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildBentoBox(
                  context: context,
                  icon: FluentIcons.money_24_regular,
                  title: widget.contract != null 
                      ? '${widget.contract!.totalAmount} ${l10n.sar}' 
                      : l10n.loadingStatus,
                  subtitle: l10n.totalContractValue,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // View Full Terms Button (Subtle & Elegant)
          Center(
            child: TextButton.icon(
              onPressed: () => _showDetailedLegalTerms(context, l10n),
              icon: Icon(FluentIcons.book_open_24_regular, color: context.colors.gold, size: 20),
              label: Text(
                l10n.viewDetailedLegalTerms,
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: FontWeight.bold,
                  color: context.colors.gold,
                  decoration: TextDecoration.underline,
                  decorationColor: context.colors.gold,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.lg),
          
          // Status Indicator
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: widget.isAgreed ? context.colors.success.withValues(alpha: 0.1) : context.colors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: widget.isAgreed ? context.colors.success.withValues(alpha: 0.3) : context.colors.error.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isAgreed ? FluentIcons.checkmark_circle_24_filled : FluentIcons.info_24_regular,
                  color: widget.isAgreed ? context.colors.success : context.colors.error,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    widget.isAgreed 
                        ? l10n.signedSuccessfully 
                        : 'يجب الاطلاع على الشروط القانونية والموافقة عليها للمتابعة',
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color: widget.isAgreed ? context.colors.success : context.colors.error,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoBox({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: context.colors.textSecondary, size: 24),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: AppFonts.bodySmall,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
