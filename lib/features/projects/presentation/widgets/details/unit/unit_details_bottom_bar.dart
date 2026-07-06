import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routes/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/entities/project_unit_entity.dart';
import '../../../../../../features/contracts/presentation/cubit/contracts_cubit.dart';
import '../../../../../../features/contracts/presentation/cubit/contracts_state.dart';
import '../../../cubit/unit_details_cubit.dart';

class UnitDetailsBottomBar extends StatelessWidget {
  final ProjectUnitEntity unit;

  const UnitDetailsBottomBar({super.key, required this.unit});

  void _showUnavailableDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: ctx.colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'تم بيع هذه الوحدة، للأسف لم يعد بالإمكان إكمال هذه الرحلة',
              style: TextStyle(fontSize: AppFonts.bodyLarge, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            CustomButton(
              text: 'تصفح وحدات بديلة',
              onPressed: () {
                Navigator.pop(ctx);
                context.go(AppRouter.layout);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.push(AppRouter.support);
              },
              child: const Text('تواصل مع الدعم الفني', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (unit.status.isUnavailable && !unit.isCurrentUserUnit) {
      return const SizedBox.shrink();
    }

    if (unit.isCurrentUserUnit) {
      return BlocBuilder<ContractsCubit, ContractsState>(
        builder: (context, contractsState) {
          final contractsCubit = context.read<ContractsCubit>();
          final boneSigned = contractsCubit.isUnitContractSigned;
          final finishingSigned = contractsCubit.isFinishingContractSigned;

          final isLoading = !contractsCubit.isSignatureStatusesReady || 
                            contractsCubit.isLoadingFinishingOrders || 
                            contractsState is ContractSigningLoading ||
                            contractsState is ContractsInitial;

          // Read eligibility from UnitDetailsCubit (computed by the UseCase)
          final unitState = context.watch<UnitDetailsCubit>().state;
          final canEditFinishing = unitState.canEditFinishing;

          List<int> existingOrderIds = contractsCubit.cachedFinishingOrderIds;

          // ---- منطق القرار ----
          String btnText;
          VoidCallback? onPressed;

          if (isLoading) {
            btnText = 'جاري التحقق من حالة عقودك...';
            onPressed = null;
          } else if (boneSigned && finishingSigned) {
            // ✅ كل العقود موقّعة — عرض فقط
            btnText = canEditFinishing
                ? l10n.editFinishingSelections
                : 'عرض ملخص التشطيبات';
            onPressed = () {
              if (canEditFinishing) {
                context.push(
                  AppRouter.unitCustomization,
                  extra: {
                    'unit': unit,
                    'isReadOnly': false,
                  },
                );
              } else {
                context.push(
                  AppRouter.finishingSummary,
                  extra: {
                    'unit': unit,
                    'totalFinishingCost': 0.0,
                  },
                );
              }
            };
          } else if (existingOrderIds.isNotEmpty) {
            // ✅ في طلبات تشطيب → امضي أو استكمل العقود
            btnText = 'استكمال توقيع العقود';
            onPressed = () => context.push(
                  AppRouter.contractsReview,
                  extra: {
                    'unit': unit,
                    'totalFinishingCost': 0.0,
                    'selectedFinishingOrderIds': existingOrderIds,
                  },
                );
          } else {
            // ✅ مفيش طلبات → اختر التشطيب
            btnText = canEditFinishing
                ? l10n.editFinishingSelections
                : 'اختر تشطيب شقتك';
            onPressed = () => context.push(
                  AppRouter.finishingGuide,
                  extra: {'unit': unit},
                );
          }

          return _buildContainer(
            context,
            btnText,
            onPressed,
            isLoading,
            showEditBanner: canEditFinishing && boneSigned && !finishingSigned,
            showLockedBanner: boneSigned && finishingSigned,
          );
        },
      );
    }

    return _buildContainer(
      context,
      l10n.startFinishingJourney,
      () {
        final state = context.read<UnitDetailsCubit>().state;
        if (state is UnitDetailsError &&
            (state.message.contains('صلاحية') ||
                state.message.contains('بيعت') ||
                state.message.contains('مرفوض'))) {
          _showUnavailableDialog(context);
          return;
        }
        context.push(AppRouter.finishingGuide, extra: {'unit': unit});
      },
      false,
    );
  }

  Widget _buildContainer(
    BuildContext context,
    String text,
    VoidCallback? onPressed,
    bool isLoading, {
    bool showEditBanner = false,
    bool showLockedBanner = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: context.colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit-available banner: amber warning
            if (showEditBanner)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                color: context.colors.gold.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Icon(Icons.edit_note_rounded, size: 16, color: context.colors.gold),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        l10n.finishingEditAvailableBanner,
                        style: TextStyle(
                          fontSize: AppFonts.bodySmall,
                          fontWeight: FontWeight.w600,
                          color: context.colors.gold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Locked banner: green success
            if (showLockedBanner)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                color: context.colors.success.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 16, color: context.colors.success),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        l10n.finishingEditLockedSigned,
                        style: TextStyle(
                          fontSize: AppFonts.bodySmall,
                          fontWeight: FontWeight.w600,
                          color: context.colors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: text,
                  onPressed: isLoading ? () {} : onPressed,
                  isLoading: isLoading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
