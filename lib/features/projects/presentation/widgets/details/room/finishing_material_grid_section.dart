import 'package:apartment/core/theme/app_radius.dart';
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
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contextual Action Bar
          if (unitRooms.length > 1 && !isReadOnly)
            BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
              buildWhen: (previous, current) {
                // Rebuild only if the selected materials in this subtype changed
                final prevSelected = filteredMaterials.where((m) => previous.selectedMaterialIds.contains(m.id)).firstOrNull;
                final currSelected = filteredMaterials.where((m) => current.selectedMaterialIds.contains(m.id)).firstOrNull;
                return prevSelected?.id != currSelected?.id;
              },
              builder: (context, state) {
                final selectedMaterial = filteredMaterials
                    .where((m) => state.selectedMaterialIds.contains(m.id))
                    .firstOrNull;
                return _buildActionBar(context, selectedMaterial);
              },
            ),
          
          // Materials Grid
          AnimatedSwitcher(
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
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context, FinishingMaterialEntity? selectedMaterial) {
    if (selectedMaterial == null) return const SizedBox.shrink();

    final otherRooms = unitRooms.where((r) => r.id != currentRoom?.id).toList();
    if (otherRooms.isEmpty) return const SizedBox.shrink();

    final currentlyAppliedRoomIds = otherRooms.where((r) {
      final cachedData = context.read<AiRoomDesignCubit>().cacheService.getRoomDesignProgress(r.id);
      if (cachedData == null) return false;
      final ids = List<int>.from(cachedData['selectedMaterialIds'] ?? []);
      return ids.contains(selectedMaterial.id);
    }).map((r) => r.id).toList();

    return InlineContextualActionBar(
      material: selectedMaterial,
      otherRooms: otherRooms,
      currentlyAppliedRoomIds: currentlyAppliedRoomIds,
      onApplyToAll: () => _applyToAllOtherRooms(context, selectedMaterial),
      onApplyToSpecific: (specificRoomIds) {
        context.read<AiRoomDesignCubit>().applyMaterialToOtherRooms(
              material: selectedMaterial,
              siblingMaterials: selectedSubtype.materials,
              targetRoomIds: specificRoomIds,
              allOtherRoomIds: otherRooms.map((r) => r.id).toList(),
            );
        AppToast.show(
          context,
          message: 'تم تطبيق الخامة على الغرف المحددة.',
          isError: false,
        );
      },
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
    );
  }

  void _applyToAllOtherRooms(BuildContext context, FinishingMaterialEntity material) {
    final otherRooms = unitRooms.where((r) => r.id != currentRoom?.id).toList();
    if (otherRooms.isEmpty) return;

    context.read<AiRoomDesignCubit>().applyMaterialToOtherRooms(
          material: material,
          siblingMaterials: selectedSubtype.materials,
          targetRoomIds: otherRooms.map((r) => r.id).toList(),
          allOtherRoomIds: otherRooms.map((r) => r.id).toList(),
        );

    AppToast.show(
      context,
      message: 'تم تطبيق الخامة على باقي الغرف بنجاح.',
      isError: false,
    );
  }

}

class InlineContextualActionBar extends StatefulWidget {
  final FinishingMaterialEntity material;
  final List<UnitRoomEntity> otherRooms;
  final List<int> currentlyAppliedRoomIds;
  final VoidCallback onApplyToAll;
  final Function(List<int>) onApplyToSpecific;

  const InlineContextualActionBar({
    super.key,
    required this.material,
    required this.otherRooms,
    required this.currentlyAppliedRoomIds,
    required this.onApplyToAll,
    required this.onApplyToSpecific,
  });

  @override
  State<InlineContextualActionBar> createState() => _InlineContextualActionBarState();
}

class _InlineContextualActionBarState extends State<InlineContextualActionBar> {
  bool isSelecting = false;
  late Set<int> selectedRoomIds;

  @override
  void initState() {
    super.initState();
    selectedRoomIds = widget.currentlyAppliedRoomIds.toSet();
  }

  @override
  void didUpdateWidget(InlineContextualActionBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.material.id != widget.material.id) {
      isSelecting = false;
      selectedRoomIds = widget.currentlyAppliedRoomIds.toSet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.primary.withValues(alpha: 0.15)),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: isSelecting ? _buildSelectionMode(context) : _buildDefaultMode(context),
      ),
    );
  }

  Widget _buildDefaultMode(BuildContext context) {
    return Row(
      children: [
        Icon(FluentIcons.sparkle_24_filled, size: 18, color: context.colors.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'تطبيق على الغرف الأخرى؟',
            style: TextStyle(
              fontSize: AppFonts.labelLarge,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isSelecting = true;
            });
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'تحديد',
            style: TextStyle(
              fontSize: AppFonts.labelMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.textSecondary,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 16,
          color: context.colors.border,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        ),
        TextButton(
          onPressed: widget.onApplyToAll,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'الكل',
            style: TextStyle(
              fontSize: AppFonts.labelMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionMode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'اختر الغرف للتطبيق:',
                style: TextStyle(
                  fontSize: AppFonts.labelMedium,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isSelecting = false;
                  selectedRoomIds = widget.currentlyAppliedRoomIds.toSet();
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.close, size: 18, color: context.colors.textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: widget.otherRooms.map((room) {
            final isSelected = selectedRoomIds.contains(room.id);
            return FilterChip(
              label: Text(room.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedRoomIds.add(room.id);
                  } else {
                    selectedRoomIds.remove(room.id);
                  }
                });
              },
              backgroundColor: context.colors.white,
              selectedColor: context.colors.primary.withValues(alpha: 0.1),
              checkmarkColor: context.colors.primary,
              labelStyle: TextStyle(
                fontSize: AppFonts.labelMedium,
                color: isSelected ? context.colors.primary : context.colors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? context.colors.primary : context.colors.border,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  widget.onApplyToSpecific(selectedRoomIds.toList());
                  setState(() {
                    isSelecting = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  minimumSize: const Size(0, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: const Text('تأكيد التطبيق', style: TextStyle(fontSize: AppFonts.labelMedium, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
