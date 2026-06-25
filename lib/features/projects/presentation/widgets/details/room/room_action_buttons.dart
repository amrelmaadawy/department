import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/app_toast.dart';
import 'package:apartment/core/routes/app_router.dart';

import '../../../../../home/domain/entities/project_unit_entity.dart';
import '../../../cubit/ai_room_design_cubit.dart';
import '../../../cubit/ai_room_design_state.dart';
import '../../../cubit/room_details_cubit.dart';
import '../../../cubit/room_details_state.dart';
import '../../../cubit/unit_details_cubit.dart';
import 'missing_categories_sheet.dart';

class RoomActionButtons extends StatelessWidget {
  final bool isLastRoom;
  final double finishingCost;
  final ProjectUnitEntity unit;
  final TabController tabController;
  final int currentTabIndex;

  const RoomActionButtons({
    super.key,
    required this.isLastRoom,
    required this.finishingCost,
    required this.unit,
    required this.tabController,
    required this.currentTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AiRoomDesignCubit, AiRoomDesignState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AiDesignStatus.success) {
          AppToast.showSuccess(context, l10n.requestSentSuccessfully);
          if (state.resultOrder != null) {
            context.push(
              '/ai-renders/${state.resultOrder!.id}',
              extra: {
                'features': unit.extras,
                'projectName': unit.title,
              },
            ).then((_) {
              if (context.mounted) {
                context.read<UnitDetailsCubit>().refreshCustomerRenders();
              }
            });
          }
        } else if (state.status == AiDesignStatus.failure) {
          AppToast.showError(context, state.errorMessage ?? l10n.unexpectedError);
        }
      },
      builder: (context, state) {
        return Row(
          children: [
            // Next Room Button
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {
                  if (isLastRoom) {
                    final unitState = context.read<UnitDetailsCubit>().state;
                    final totalRooms = unit.rooms.length;

                    final aiDesignedRoomIds = unitState.customerRenders
                        .where((cr) => cr.renders.isNotEmpty)
                        .map((cr) => cr.id)
                        .toSet();

                    // A room is completed if it's in the local completed state OR if it already has an AI design from the server
                    final allRoomsCompleted = unit.rooms.every((r) => 
                        unitState.completedRoomIds.contains(r.id) || aiDesignedRoomIds.contains(r.id));
                        
                    final allRoomsAiDesigned = unit.rooms.every((r) => aiDesignedRoomIds.contains(r.id));

                    if (!allRoomsCompleted) {
                      AppToast.showError(context, 'يجب تشطيب جميع غرف الشقة أولاً قبل المتابعة');
                      return;
                    }

                    if (!allRoomsAiDesigned) {
                      AppToast.showError(context, 'لضمان دقة العقود، نرجو استكمال التصميم النهائي لباقي الغرف لتأكيد اختياراتك');
                      return;
                    }

                    context.push(
                      AppRouter.finishingSummary,
                      extra: {
                        'totalFinishingCost': finishingCost,
                        'unit': unit,
                      },
                    );
                  } else {
                    tabController.animateTo(currentTabIndex + 1);
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  side: BorderSide(color: context.colors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
                child: Text(
                  isLastRoom ? 'عرض الملخص' : l10n.nextRoom,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            
            // AI Design Button
            Expanded(
              flex: 1,
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
                            MissingCategoriesSheet.show(context, missingSubtypes);
                            return;
                          }
                        }
                        context.read<AiRoomDesignCubit>().submitOrder();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                  style: const TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
