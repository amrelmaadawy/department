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
import 'room_designs_bottom_sheet.dart';
import 'ai_design_settings_bottom_sheet.dart';
import 'category_tab_controller.dart';

class RoomActionButtons extends StatelessWidget {
  final bool isLastRoom;
  final double finishingCost;
  final ProjectUnitEntity unit;
  final TabController tabController;
  final int currentTabIndex;
  final CategoryTabController categoryTabController;

  const RoomActionButtons({
    super.key,
    required this.isLastRoom,
    required this.finishingCost,
    required this.unit,
    required this.tabController,
    required this.currentTabIndex,
    required this.categoryTabController,
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
            // Next Category / Room Button
            Expanded(
              flex: 1,
              child: AnimatedBuilder(
                animation: categoryTabController,
                builder: (context, _) {
                  final isLastCategory = categoryTabController.isLastTab;
                  
                  return OutlinedButton(
                    onPressed: () {
                      if (!isLastCategory) {
                        categoryTabController.nextTab();
                        return;
                      }
                      
                      if (isLastRoom) {
                        final unitState = context.read<UnitDetailsCubit>().state;

                        final aiDesignedRoomIds = unitState.customerRenders
                            .where((cr) => cr.renders.isNotEmpty)
                            .map((cr) => cr.id)
                            .toSet();

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
                      !isLastCategory ? 'الخامة التالية' : (isLastRoom ? 'عرض الملخص' : l10n.nextRoom),
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            
            // AI Design Button
            Expanded(
              flex: 1,
              child: BlocSelector<UnitDetailsCubit, UnitDetailsState, bool>(
                selector: (unitState) {
                  if (unitState is UnitDetailsLoaded) {
                    final roomRenders = unitState.customerRenders.where((r) => r.id == unit.rooms[currentTabIndex].id).toList();
                    return roomRenders.isNotEmpty && roomRenders.first.renders.isNotEmpty;
                  }
                  return false;
                },
                builder: (context, hasRenders) {
                  final isLoading = state.status == AiDesignStatus.loading;
                  final buttonText = isLoading ? l10n.sending : (hasRenders ? l10n.roomDesigns : l10n.smartDesign);
                  final buttonIcon = isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: context.colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(hasRenders ? FluentIcons.image_multiple_24_regular : FluentIcons.sparkle_24_filled, size: 20);

                  return ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () {
                            void triggerNewDesign() {
                              void showAiSettingsSheet() {
                                AiDesignSettingsBottomSheet.show(
                                  context: context,
                                  aiRoomDesignCubit: context.read<AiRoomDesignCubit>(),
                                  onStartDesign: () {
                                    context.read<AiRoomDesignCubit>().submitOrder();
                                  },
                                );
                              }

                              final roomDetailsState = context.read<RoomDetailsCubit>().state;
                              if (roomDetailsState is RoomDetailsLoaded) {
                                final options = roomDetailsState.roomDetails.finishingOptions;
                                final allSubtypes = options.expand((c) => c.subtypes).toList();
                                
                                final missingSubtypes = allSubtypes.where((subtype) {
                                  if (subtype.materials.isEmpty) return false;
                                  return !subtype.materials.any((m) => state.selectedMaterialIds.contains(m.id));
                                }).toList();

                                if (missingSubtypes.isNotEmpty) {
                                  MissingCategoriesSheet.show(
                                    context: context,
                                    missingSubtypes: missingSubtypes,
                                    onContinueAnyway: showAiSettingsSheet,
                                  );
                                  return;
                                }
                              }
                              
                              showAiSettingsSheet();
                            }

                            if (hasRenders) {
                              final unitState = context.read<UnitDetailsCubit>().state as UnitDetailsLoaded;
                              final currentRoom = unit.rooms[currentTabIndex];
                              final roomRenders = unitState.customerRenders.firstWhere((r) => r.id == currentRoom.id).renders;
                              
                              RoomDesignsBottomSheet.show(
                                context: context,
                                roomName: currentRoom.name,
                                roomId: currentRoom.id,
                                unitId: unit.id,
                                renders: roomRenders,
                                onNewDesignPressed: triggerNewDesign,
                              );
                            } else {
                              triggerNewDesign();
                            }
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
                    icon: buttonIcon,
                    label: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
