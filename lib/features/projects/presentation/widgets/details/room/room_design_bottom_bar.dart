import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_state.dart';
import 'package:apartment/features/projects/presentation/cubit/room_details_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/room_details_state.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../home/domain/entities/finishing_subtype_entity.dart';
import '../../../../../../core/widgets/app_toast.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import 'package:apartment/l10n/app_localizations.dart';

class RoomDesignBottomBar extends StatelessWidget {
  const RoomDesignBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<AiRoomDesignCubit, AiRoomDesignState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AiDesignStatus.success) {
          AppToast.showSuccess(context, l10n.requestSentSuccessfully);
          // Navigate to AI renders screen with the orderId
          if (state.resultOrder != null) {
            context.push('/ai-renders/${state.resultOrder!.id}');
          }
        } else if (state.status == AiDesignStatus.failure) {
          AppToast.showError(context, state.errorMessage ?? l10n.unexpectedError);
        }
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: context.colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.approximateCost,
                      style: TextStyle(
                        fontSize: AppFonts.labelMedium,
                        color: context.colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${state.expectedTotalCost.toStringAsFixed(0)} ر.س',
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: state.status == AiDesignStatus.loading
                        ? null
                        : () {
                            final roomDetailsState = context.read<RoomDetailsCubit>().state;
                            if (roomDetailsState is RoomDetailsLoaded) {
                              final options = roomDetailsState.roomDetails.finishingOptions;
                              final allSubtypes = options.expand((c) => c.subtypes).toList();
                              
                              final missingSubtypes = allSubtypes.where((subtype) {
                                if (subtype.materials.isEmpty) return false;
                                return !subtype.materials.any((m) => state.selectedMaterialIds.contains(m.id));
                              }).toList();

                              if (missingSubtypes.isNotEmpty) {
                                _showMissingCategoriesWarning(context, missingSubtypes);
                                return;
                              }
                            }
                            context.read<AiRoomDesignCubit>().submitOrder();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      elevation: 0,
                    ),
                    icon: state.status == AiDesignStatus.loading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: context.colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(FluentIcons.sparkle_24_filled, size: 20),
                    label: Text(
                      state.status == AiDesignStatus.loading ? l10n.sending : l10n.smartDesign,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMissingCategoriesWarning(BuildContext context, List<FinishingSubtypeEntity> missingSubtypes) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(FluentIcons.warning_24_filled, color: context.colors.gold, size: 28),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'تنبيه قبل التصميم',
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'لم تقم باختيار خامات لبعض الأقسام المتاحة. هل ترغب في متابعة التصميم بدونها أم العودة للاختيار؟',
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: missingSubtypes.map((subtype) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: context.colors.gold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.round),
                        border: Border.all(color: context.colors.gold.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        subtype.subtypeName,
                        style: TextStyle(
                          fontSize: AppFonts.bodySmall,
                          fontWeight: FontWeight.bold,
                          color: context.colors.gold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(bottomSheetContext);
                          context.read<AiRoomDesignCubit>().submitOrder();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.colors.textPrimary,
                          side: BorderSide(color: context.colors.border),
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                        ),
                        child: const Text('تصميم على أي حال', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(bottomSheetContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: context.colors.white,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                        ),
                        child: const Text('إلغاء وتكملة الاختيار', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
