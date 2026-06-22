import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../home/domain/entities/project_unit_entity.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/theme_extension.dart';

import '../../../cubit/ai_room_design_cubit.dart';

import 'ai_design_settings_section.dart';
import 'room_price_display.dart';
import 'room_action_buttons.dart';

class UnifiedRoomBottomBar extends StatelessWidget {
  final TabController tabController;
  final ProjectUnitEntity unit;
  final double finishingCost;

  const UnifiedRoomBottomBar({
    super.key,
    required this.tabController,
    required this.unit,
    required this.finishingCost,
  });

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
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        final currentIndex = tabController.index;
        final isLastRoom = unit.rooms.isEmpty || currentIndex == unit.rooms.length - 1;

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
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
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoomPriceDisplay(
                  unit: unit,
                  finishingCost: finishingCost,
                  onDesignOptionsPressed: () {
                    final cubit = context.read<AiRoomDesignCubit>();
                    _showSettingsBottomSheet(context, cubit);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                RoomActionButtons(
                  isLastRoom: isLastRoom,
                  finishingCost: finishingCost,
                  unit: unit,
                  tabController: tabController,
                  currentTabIndex: currentIndex,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

