import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:apartment/l10n/app_localizations.dart';

import '../../../../../home/domain/entities/project_unit_entity.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';

import 'room_action_buttons.dart';
import 'category_tab_controller.dart';

class UnifiedRoomBottomBar extends StatelessWidget {
  final TabController tabController;
  final CategoryTabController categoryTabController;
  final ProjectUnitEntity unit;
  final double finishingCost;

  const UnifiedRoomBottomBar({
    super.key,
    required this.tabController,
    required this.categoryTabController,
    required this.unit,
    required this.finishingCost,
  });


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
                if (finishingCost > 0)
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'إجمالي سعر تشطيب الشقة:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: context.colors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${formatter.format(finishingCost).trim()} ${l10n.sar}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.gold,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      );
                    }
                  ),
                RoomActionButtons(
                  isLastRoom: isLastRoom,
                  finishingCost: finishingCost,
                  unit: unit,
                  tabController: tabController,
                  currentTabIndex: currentIndex,
                  categoryTabController: categoryTabController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

