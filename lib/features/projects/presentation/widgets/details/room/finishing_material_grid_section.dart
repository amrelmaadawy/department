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
  final bool isPackageMode;
  final VoidCallback onHighlightNextTab;

  const FinishingMaterialGridSection({
    super.key,
    required this.selectedSubtype,
    required this.filteredMaterials,
    required this.unitRooms,
    required this.currentRoom,
    required this.categoryTabController,
    required this.isReadOnly,
    this.isPackageMode = false,
    required this.onHighlightNextTab,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Grid System with Inline Action Bar
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: filteredMaterials.isEmpty
                ? const FinishingEmptyState()
                : LayoutBuilder(
                    key: ValueKey<String>('${selectedSubtype.subtypeId}_${filteredMaterials.length}'),
                    builder: (context, constraints) {
                      const double maxCrossAxisExtent = 220.0;
                      const double crossAxisSpacing = AppSpacing.md;
                      
                      int crossAxisCount = (constraints.maxWidth / (maxCrossAxisExtent + crossAxisSpacing)).ceil();
                      if (crossAxisCount < 1) crossAxisCount = 1;
                      
                      final List<List<FinishingMaterialEntity>> rows = [];
                      for (int i = 0; i < filteredMaterials.length; i += crossAxisCount) {
                        rows.add(
                          filteredMaterials.sublist(
                            i,
                            i + crossAxisCount > filteredMaterials.length
                                ? filteredMaterials.length
                                : i + crossAxisCount,
                          ),
                        );
                      }

                      return BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
                        buildWhen: (previous, current) {
                          final prevSelected = filteredMaterials.where((m) => previous.selectedMaterialIds.contains(m.id)).firstOrNull;
                          final currSelected = filteredMaterials.where((m) => current.selectedMaterialIds.contains(m.id)).firstOrNull;
                          return prevSelected?.id != currSelected?.id;
                        },
                        builder: (context, state) {
                          final selectedMaterial = filteredMaterials
                              .where((m) => state.selectedMaterialIds.contains(m.id))
                              .firstOrNull;
                          
                          final bool showActionBar = unitRooms.length > 1 && !isReadOnly && selectedMaterial != null;
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: rows.map((rowMaterials) {
                              final bool hasSelectedMaterial = selectedMaterial != null && 
                                  rowMaterials.any((m) => m.id == selectedMaterial.id);
                                  
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(crossAxisCount * 2 - 1, (index) {
                                        if (index.isOdd) return const SizedBox(width: AppSpacing.md);
                                        
                                        final colIndex = index ~/ 2;
                                        if (colIndex < rowMaterials.length) {
                                          final material = rowMaterials[colIndex];
                                          final isSelected = selectedMaterial?.id == material.id;
                                          return Expanded(
                                            child: AspectRatio(
                                              aspectRatio: 0.75,
                                              child: FinishingMaterialGridCard(
                                                material: material,
                                                isSelected: isSelected,
                                                roomArea: currentRoom?.area,
                                                onTap: () => _handleMaterialTap(context, material, isSelected),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const Expanded(child: SizedBox.shrink());
                                        }
                                      }),
                                    ),
                                  ),
                                  
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutCubic,
                                    child: (showActionBar && hasSelectedMaterial)
                                        ? _buildActionBarWithPointer(
                                            context, 
                                            selectedMaterial,
                                            rowMaterials.indexOf(selectedMaterial),
                                            crossAxisCount,
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              );
                            }).toList(),
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

  Widget _buildActionBarWithPointer(
    BuildContext context, 
    FinishingMaterialEntity selectedMaterial, 
    int colIndex, 
    int crossAxisCount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: List.generate(crossAxisCount * 2 - 1, (index) {
            if (index.isOdd) return const SizedBox(width: AppSpacing.md);
            final currColIndex = index ~/ 2;
            if (currColIndex == colIndex) {
              return Expanded(
                child: Center(
                  child: CustomPaint(
                    size: const Size(20, 10),
                    painter: _TrianglePainter(
                      color: context.colors.primary.withValues(alpha: 0.05),
                      borderColor: context.colors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                ),
              );
            } else {
              return const Expanded(child: SizedBox.shrink());
            }
          }),
        ),
        Transform.translate(
          offset: const Offset(0, -1),
          child: _buildActionBar(context, selectedMaterial),
        ),
      ],
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
    if (isReadOnly || isPackageMode) {
      final msg = isPackageMode
          ? 'تم اختيار هذه الخامات تلقائياً من الباقة المختارة ولا يمكن تغييرها.'
          : 'لقد قمت بتوقيع عقود التشطيب مسبقاً، ولا يمكن تغيير الخيارات الحالية.';
      AppToast.show(
        context,
        message: msg,
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

class _TrianglePainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  _TrianglePainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Draw only the top two sides of the triangle for the border
    final borderPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height);

    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.borderColor != borderColor;
  }
}
