import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/di/injection_container.dart' as di;
import 'package:collection/collection.dart';

import '../../../../../home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/projects/domain/usecases/check_duplicate_ai_design_use_case.dart';
import '../../../cubit/ai_room_design_cubit.dart';
import '../../../cubit/ai_room_design_state.dart';
import '../../../cubit/room_details_cubit.dart';
import '../../../cubit/room_details_state.dart';
import '../../../cubit/unit_details_cubit.dart';
import 'missing_categories_sheet.dart';
import 'room_designs_bottom_sheet.dart';
import 'ai_design_settings_bottom_sheet.dart';
import 'duplicate_ai_design_alert_sheet.dart';

class RoomAiDesignButton extends StatelessWidget {
  final ProjectUnitEntity unit;
  final int currentTabIndex;

  const RoomAiDesignButton({
    super.key,
    required this.unit,
    required this.currentTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AiRoomDesignCubit>().state;

    return BlocSelector<UnitDetailsCubit, UnitDetailsState, bool>(
      selector: (unitState) {
        if (unitState is UnitDetailsLoaded) {
          final roomRenders = unitState.customerRenders
              .where((r) => r.id == unit.rooms[currentTabIndex].id)
              .toList();
          return roomRenders.isNotEmpty && roomRenders.first.renders.isNotEmpty;
        }
        return false;
      },
      builder: (context, hasRenders) {
        final isLoading = state.status == AiDesignStatus.loading;
        final buttonText = isLoading
            ? l10n.sending
            : (hasRenders ? l10n.roomDesigns : l10n.smartDesign);
        final buttonIcon = isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: context.colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(
                hasRenders
                    ? FluentIcons.image_multiple_24_regular
                    : FluentIcons.sparkle_24_filled,
                size: 20,
              );

        return ElevatedButton.icon(
          onPressed: isLoading ? null : () => _handlePressed(context, state, hasRenders),
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
    );
  }

  void _handlePressed(BuildContext context, AiRoomDesignState state, bool hasRenders) {
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

      void proceedWithValidation() {
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

      final checkDuplicateUseCase = di.sl<CheckDuplicateAiDesignUseCase>();
      final isDuplicate = checkDuplicateUseCase.call(
        roomId: state.roomId,
        currentMaterialIds: state.selectedMaterialIds,
      );

      if (isDuplicate && hasRenders) {
        DuplicateAiDesignAlertSheet.show(
          context: context,
          onViewPreviousDesigns: () => _showRendersSheet(context, triggerNewDesign),
          onContinueAnyway: proceedWithValidation,
        );
      } else {
        proceedWithValidation();
      }
    }

    if (hasRenders) {
      _showRendersSheet(context, triggerNewDesign);
    } else {
      triggerNewDesign();
    }
  }

  void _showRendersSheet(BuildContext context, VoidCallback triggerNewDesign) {
    final unitState = context.read<UnitDetailsCubit>().state;
    if (unitState is! UnitDetailsLoaded) return;

    if (currentTabIndex >= unit.rooms.length) return;
    final currentRoom = unit.rooms[currentTabIndex];

    final roomRenderGroup = unitState.customerRenders
        .firstWhereOrNull((r) => r.id == currentRoom.id);
    final roomRenders = roomRenderGroup?.renders ?? [];

    RoomDesignsBottomSheet.show(
      context: context,
      roomName: currentRoom.name,
      roomId: currentRoom.id,
      unitId: unit.id,
      renders: roomRenders,
      onNewDesignPressed: triggerNewDesign,
    );
  }
}
