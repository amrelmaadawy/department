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
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/contracts_cubit.dart';
import '../cubit/contracts_state.dart';
import '../../../../core/widgets/app_toast.dart';

class ContractsReviewScreen extends StatefulWidget {
  final double totalFinishingCost;
  final ProjectUnitEntity? unit;
  final List<int> selectedFinishingOrderIds;
  const ContractsReviewScreen({super.key, required this.totalFinishingCost, this.unit, this.selectedFinishingOrderIds = const []});

  @override
  State<ContractsReviewScreen> createState() => _ContractsReviewScreenState();
}

class _ContractsReviewScreenState extends State<ContractsReviewScreen> {
  @override
  void initState() {
    super.initState();
    final unit = widget.unit ?? sl<DesignContextCubit>().state.selectedUnit;
    if (unit != null) {
      context.read<ContractsCubit>().loadSignatureStatuses(unit.id);
    }
  }

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
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Total Amount Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: context.colors.gold.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colors.gold.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.gold.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FluentIcons.receipt_money_24_filled,
                    color: context.colors.gold,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.finalTotalCost,
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
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
                        color: context.colors.primary,
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
          const SizedBox(height: AppSpacing.md),

          // Contracts List
          Text(
            l10n.contractsRequiredForSignature,
            style: TextStyle(
              fontSize: AppFonts.headlineMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          BlocConsumer<ContractsCubit, ContractsState>(
            listener: (context, state) async {
              if (state is ContractsError) {
                AppToast.showError(context, state.message);
              } else if (state is BoneContractCreated) {
                final result = await context.push(
                  AppRouter.contractSigning,
                  extra: {'type': ContractType.unit, 'unit': unit, 'contract': state.contract, 'finishingTotal': widget.totalFinishingCost},
                );
                if (!context.mounted) return;
                if (result == true) {
                  context.read<ContractsCubit>().markContractAsSigned(unit!.id, 'unit');
                }
              } else if (state is FinishingContractCreated) {
                final result = await context.push(
                  AppRouter.contractSigning,
                  extra: {'type': ContractType.finishing, 'unit': unit, 'contract': state.contract, 'finishingTotal': widget.totalFinishingCost},
                );
                if (!context.mounted) return;
                if (result == true) {
                  context.read<ContractsCubit>().markContractAsSigned(unit!.id, 'finishing');
                }
              }
            },
            builder: (context, state) {
              final isBoneLoading = state is BoneContractLoading;
              final isFinishingLoading = state is FinishingContractLoading;
              final isUnitSigned = context.read<ContractsCubit>().isUnitContractSigned;
              final isFinishingSigned = context.read<ContractsCubit>().isFinishingContractSigned;

              return Column(
                children: [
                  _buildContractCard(
                    context: context,
                    title: l10n.propertySaleContract,
                    subtitle: unit != null
                        ? l10n.unitDetailsWithArea(unit.title, unit.area.toString())
                        : l10n.unitDetailsDefault,
                    isSigned: isUnitSigned,
                    isLoading: isBoneLoading,
                    onSign: () {
                      if (unit != null) {
                        context.read<ContractsCubit>().createBoneContract(
                          apartmentId: int.tryParse(unit.id) ?? 0,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildContractCard(
                    context: context,
                    title: l10n.finishingContract,
                    subtitle: l10n.customFinishingComprehensive,
                    isSigned: isFinishingSigned,
                    isLoading: isFinishingLoading,
                    onSign: () {
                      if (unit != null) {
                        context.read<ContractsCubit>().createFinishingContract(
                          orderIds: widget.selectedFinishingOrderIds,
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          BlocBuilder<ContractsCubit, ContractsState>(
            builder: (context, state) {
              final isUnitSigned = context.read<ContractsCubit>().isUnitContractSigned;
              final isFinishingSigned = context.read<ContractsCubit>().isFinishingContractSigned;
              return CustomButton(
                text: l10n.completeBookingAndPayment,
                onPressed: (!isUnitSigned || !isFinishingSigned)
                    ? null
                    : () {
                        AppToast.showSuccess(context, 'هذه الخاصية ستتوفر قريباً');
                      },
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
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
    bool isLoading = false,
  }) {
    final l10nCard = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
          const SizedBox(width: AppSpacing.sm),
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
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (isSigned)
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
