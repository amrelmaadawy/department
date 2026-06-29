import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/app_toast.dart';

import '../../../../../home/domain/entities/project_unit_entity.dart';
import '../../../cubit/ai_room_design_cubit.dart';
import '../../../cubit/ai_room_design_state.dart';
import '../../../cubit/unit_details_cubit.dart';
import 'category_tab_controller.dart';
import '../../ai_renders/ai_credits_depleted_dialog.dart';
import 'room_next_navigation_button.dart';
import 'room_ai_design_button.dart';

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

    return BlocListener<AiRoomDesignCubit, AiRoomDesignState>(
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
          final errorMessage = state.errorMessage?.toLowerCase() ?? '';
          if (errorMessage.contains('credit') || errorMessage.contains('رصيد')) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const AiCreditsDepletedDialog(),
            );
          } else {
            AppToast.showError(context, state.errorMessage ?? l10n.unexpectedError);
          }
        }
      },
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: RoomNextNavigationButton(
              isLastRoom: isLastRoom,
              finishingCost: finishingCost,
              unit: unit,
              tabController: tabController,
              currentTabIndex: currentTabIndex,
              categoryTabController: categoryTabController,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 1,
            child: RoomAiDesignButton(
              unit: unit,
              currentTabIndex: currentTabIndex,
            ),
          ),
        ],
      ),
    );
  }
}
