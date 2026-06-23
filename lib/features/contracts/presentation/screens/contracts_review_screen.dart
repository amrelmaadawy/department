import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../features/home/domain/entities/project_unit_entity.dart';
import '../../../../features/design_studio/presentation/cubit/design_context_cubit.dart';
import '../../domain/entities/contract_type.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../l10n/app_localizations.dart';

class ContractsReviewScreen extends StatefulWidget {
  final double totalFinishingCost;
  final ProjectUnitEntity? unit;
  const ContractsReviewScreen({super.key, required this.totalFinishingCost, this.unit});

  @override
  State<ContractsReviewScreen> createState() => _ContractsReviewScreenState();
}

class _ContractsReviewScreenState extends State<ContractsReviewScreen> {
  bool _isUnitContractSigned = false;
  bool _isFinishingContractSigned = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final unit = widget.unit ?? sl<DesignContextCubit>().state.selectedUnit;
    final totalCost = (unit?.price ?? 0.0) + widget.totalFinishingCost;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          l10n.reviewAndSignContracts,
          style: TextStyle(
            fontSize: AppFonts.headlineMedium,
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            FluentIcons.arrow_left_24_filled,
            color: context.colors.primary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          // Total Amount Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [context.colors.primary, const Color(0xFF1A1A1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              children: [
                Text(
                  l10n.finalTotalCost,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      totalCost
                          .toStringAsFixed(0)
                          .replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          ),
                      style: TextStyle(
                        fontSize: AppFonts.displayLarge,
                        fontWeight: FontWeight.w900,
                        color: context.colors.gold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.sar,
                      style: TextStyle(
                        fontSize: AppFonts.headlineMedium,
                        fontWeight: FontWeight.bold,
                        color: context.colors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Contracts List
          Text(
            l10n.contractsRequiredForSignature,
            style: TextStyle(
              fontSize: AppFonts.headlineMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          _buildContractCard(
            context: context,
            title: l10n.propertySaleContract,
            subtitle: unit != null
                ? l10n.unitDetailsWithArea(unit.title, unit.area.toString())
                : l10n.unitDetailsDefault,
            isSigned: _isUnitContractSigned,
            onSign: () async {
              final result = await context.push(
                AppRouter.contractSigning,
                extra: {'type': ContractType.unit, 'unit': unit},
              );
              if (result == true) {
                setState(() => _isUnitContractSigned = true);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _buildContractCard(
            context: context,
            title: l10n.finishingContract,
            subtitle: l10n.customFinishingComprehensive,
            isSigned: _isFinishingContractSigned,
            onSign: () async {
              final result = await context.push(
                AppRouter.contractSigning,
                extra: {
                  'type': ContractType.finishing,
                  'finishingTotal': widget.totalFinishingCost,
                  'unit': unit,
                },
              );
              if (result == true) {
                setState(() => _isFinishingContractSigned = true);
              }
            },
          ),

          const SizedBox(height: AppSpacing.xxxl),

          CustomButton(
            text: l10n.completeBookingAndPayment,
            onPressed: (!_isUnitContractSigned || !_isFinishingContractSigned)
                ? null
                : () {
                    // Proceed to checkout screen passing the total cost
                    context.pushReplacement(
                      AppRouter.checkout,
                      extra: totalCost,
                    );
                  },
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildContractCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isSigned,
    required VoidCallback onSign,
  }) {
    final l10nCard = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isSigned ? context.colors.success : context.colors.border,
          width: isSigned ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSigned
                  ? context.colors.success.withValues(alpha: 0.1)
                  : context.colors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSigned
                  ? FluentIcons.signature_24_filled
                  : FluentIcons.document_24_regular,
              color: isSigned ? context.colors.success : context.colors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          if (isSigned)
            Icon(
              FluentIcons.checkmark_circle_24_filled,
              color: context.colors.success,
              size: 28,
            )
          else
            TextButton(
              onPressed: onSign,
              style: TextButton.styleFrom(foregroundColor: context.colors.gold),
              child: Text(
                l10nCard.signNow,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFonts.bodyLarge,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
