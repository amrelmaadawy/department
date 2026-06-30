import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/app_toast.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../home/domain/entities/finishing_material_entity.dart';
import '../../../../../home/domain/entities/finishing_subtype_entity.dart';
import '../../../../../home/domain/entities/unit_room_entity.dart';
import 'apply_to_other_rooms_sheet.dart';
import 'category_tab_controller.dart';
import 'finishing_empty_state.dart';
import 'finishing_material_grid_card.dart';
import 'material_preview_sheet.dart';

class FinishingMaterialGridSection extends StatelessWidget {
  final FinishingSubtypeEntity selectedSubtype;
  final List<FinishingMaterialEntity> filteredMaterials;
  final List<UnitRoomEntity> unitRooms;
  final UnitRoomEntity? currentRoom;
  final CategoryTabController categoryTabController;
  final bool isReadOnly;
  final VoidCallback onHighlightNextTab;

  const FinishingMaterialGridSection({
    super.key,
    required this.selectedSubtype,
    required this.filteredMaterials,
    required this.unitRooms,
    required this.currentRoom,
    required this.categoryTabController,
    required this.isReadOnly,
    required this.onHighlightNextTab,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: filteredMaterials.isEmpty
            ? const FinishingEmptyState()
            : GridView.builder(
                key: ValueKey<String>('${selectedSubtype.subtypeId}_${filteredMaterials.length}'),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredMaterials.length,
                itemBuilder: (context, index) {
                  final material = filteredMaterials[index];
                  return BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
                    builder: (context, state) {
                      final isSelected = state.selectedMaterialIds.contains(material.id);
                      return FinishingMaterialGridCard(
                        material: material,
                        isSelected: isSelected,
                        roomArea: currentRoom?.area,
                        onTap: () => _handleMaterialTap(context, material, isSelected),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  void _handleMaterialTap(BuildContext context, FinishingMaterialEntity material, bool isSelected) {
    if (isReadOnly) {
      AppToast.show(
        context,
        message: 'تم اختيار هذه الخامات تلقائياً من الباقة المختارة ولا يمكن تغييرها.',
        isError: false,
      );
      return;
    }
    HapticFeedback.lightImpact();
    MaterialPreviewSheet.show(
      context,
      material: material,
      isSelected: isSelected,
      roomArea: currentRoom?.area,
      onToggleSelection: () {
        context.read<AiRoomDesignCubit>().toggleMaterial(
              material,
              selectedSubtype.materials,
            );

        if (!isSelected) {
          onHighlightNextTab();
        }
      },
    ).then((wasSelected) {
      if (wasSelected == true && unitRooms.length > 1 && context.mounted) {
        _checkAndApplyToOtherRooms(context, material);
      }
    });
  }

  void _checkAndApplyToOtherRooms(BuildContext context, FinishingMaterialEntity material) {
    final otherRooms = unitRooms.where((r) => r.id != currentRoom?.id).toList();
    if (otherRooms.isEmpty) return;

    final currentlyAppliedRoomIds = unitRooms.where((r) {
      final cachedData = context.read<AiRoomDesignCubit>().cacheService.getRoomDesignProgress(r.id);
      if (cachedData == null) return false;
      final ids = List<int>.from(cachedData['selectedMaterialIds'] ?? []);
      return ids.contains(material.id);
    }).map((r) => r.id).toList();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!context.mounted) return;
      ApplyToOtherRoomsSheet.show(
        context,
        selectedMaterial: material,
        otherRooms: otherRooms,
        currentlyAppliedRoomIds: currentlyAppliedRoomIds,
        onApply: (specificRoomIds) {
          context.read<AiRoomDesignCubit>().applyMaterialToOtherRooms(
                material: material,
                siblingMaterials: selectedSubtype.materials,
                targetRoomIds: specificRoomIds,
                allOtherRoomIds: otherRooms.map((r) => r.id).toList(),
              );
        },
      );
    });
  }
}
