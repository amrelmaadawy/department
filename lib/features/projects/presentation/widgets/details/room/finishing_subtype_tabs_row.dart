import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../home/domain/entities/finishing_subtype_entity.dart';
import 'category_tab_controller.dart';
import 'subtype_tab_item.dart';

class FinishingSubtypeTabsRow extends StatelessWidget {
  final List<FinishingSubtypeEntity> allSubtypes;
  final CategoryTabController categoryTabController;
  final int? highlightedTabIndex;

  const FinishingSubtypeTabsRow({
    super.key,
    required this.allSubtypes,
    required this.categoryTabController,
    this.highlightedTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
      buildWhen: (previous, current) => previous.selectedMaterialIds != current.selectedMaterialIds,
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [
                  AppColors.transparent,
                  AppColors.white,
                  AppColors.white,
                  AppColors.transparent,
                ],
                stops: [0.0, 0.05, 0.95, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              physics: const BouncingScrollPhysics(),
              itemCount: allSubtypes.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final isSelected = index == categoryTabController.currentIndex;
                final isHighlighted = index == highlightedTabIndex;
                final subtype = allSubtypes[index];
                final isCompleted = subtype.materials.any((m) => state.selectedMaterialIds.contains(m.id));
                return SubtypeTabItem(
                  subtype: subtype,
                  isSelected: isSelected,
                  isCompleted: isCompleted,
                  isHighlighted: isHighlighted,
                  onTap: () => categoryTabController.setIndex(index),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
