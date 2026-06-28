import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/app_toast.dart';
import 'package:apartment/core/routes/app_router.dart';

import '../../../../../home/domain/entities/project_unit_entity.dart';
import '../../../cubit/unit_details_cubit.dart';
import 'category_tab_controller.dart';

class RoomNextNavigationButton extends StatelessWidget {
  final bool isLastRoom;
  final double finishingCost;
  final ProjectUnitEntity unit;
  final TabController tabController;
  final int currentTabIndex;
  final CategoryTabController categoryTabController;

  const RoomNextNavigationButton({
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

    return AnimatedBuilder(
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
                  unitState.completedRoomIds.contains(r.id) ||
                  aiDesignedRoomIds.contains(r.id));

              final allRoomsAiDesigned =
                  unit.rooms.every((r) => aiDesignedRoomIds.contains(r.id));

              if (!allRoomsCompleted) {
                AppToast.showError(
                    context, 'يجب تشطيب جميع غرف الشقة أولاً قبل المتابعة');
                return;
              }

              if (!allRoomsAiDesigned) {
                AppToast.showError(context,
                    'لضمان دقة العقود، نرجو استكمال التصميم النهائي لباقي الغرف لتأكيد اختياراتك');
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
            !isLastCategory
                ? 'الخامة التالية'
                : (isLastRoom ? 'عرض الملخص' : l10n.nextRoom),
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
        );
      },
    );
  }
}
