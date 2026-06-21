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

import 'ai_design_settings_section.dart';

class RoomDesignBottomBar extends StatelessWidget {
  const RoomDesignBottomBar({super.key});

  void _showSettingsBottomSheet(BuildContext context, AiRoomDesignCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            ),
            padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: AiDesignSettingsSection(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<AiRoomDesignCubit, AiRoomDesignState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AiDesignStatus.success) {
          AppToast.showSuccess(context, l10n.requestSentSuccessfully);
          if (state.resultOrder != null) {
            context.push('/ai-renders/${state.resultOrder!.id}');
          }
        } else if (state.status == AiDesignStatus.failure) {
          AppToast.showError(context, state.errorMessage ?? l10n.unexpectedError);
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  final cubit = context.read<AiRoomDesignCubit>();
                  _showSettingsBottomSheet(context, cubit);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  side: BorderSide(color: context.colors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
                child: Icon(
                  FluentIcons.settings_24_regular,
                  color: context.colors.textPrimary,
                  size: 24,
                ),
              ),
              SizedBox(width: AppSpacing.md),
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
