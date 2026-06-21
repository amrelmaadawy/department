import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../home/domain/entities/finishing_category_entity.dart';
import '../../../../../home/domain/entities/finishing_subtype_entity.dart';
import 'finishing_material_grid_card.dart';
import 'material_apply_banner.dart';
import 'room_selection_bottom_sheet.dart';
import '../../../../../../core/widgets/app_toast.dart';
import '../../../../../home/domain/entities/unit_room_entity.dart';

class FinishingOptionsSection extends StatefulWidget {
  final List<FinishingCategoryEntity> options;
  final List<UnitRoomEntity> unitRooms;
  final UnitRoomEntity? currentRoom;

  const FinishingOptionsSection({
    super.key, 
    required this.options,
    this.unitRooms = const [],
    this.currentRoom,
  });

  @override
  State<FinishingOptionsSection> createState() => _FinishingOptionsSectionState();
}

class _FinishingOptionsSectionState extends State<FinishingOptionsSection> {
  late List<FinishingSubtypeEntity> _allSubtypes;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _flattenSubtypes();
  }

  @override
  void didUpdateWidget(FinishingOptionsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options != oldWidget.options) {
      _flattenSubtypes();
      if (_selectedTabIndex >= _allSubtypes.length) {
        _selectedTabIndex = 0;
      }
    }
  }

  void _flattenSubtypes() {
    _allSubtypes = widget.options.expand((category) => category.subtypes).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_allSubtypes.isEmpty) return const SizedBox.shrink();

    final selectedSubtype = _allSubtypes[_selectedTabIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressBar(context),
        const SizedBox(height: AppSpacing.md),
        // Tabs Section
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            physics: const BouncingScrollPhysics(),
            itemCount: _allSubtypes.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final isSelected = index == _selectedTabIndex;
              final subtype = _allSubtypes[index];
              return _buildTabItem(context, subtype, isSelected, index);
            },
          ),
        ),
        
        const SizedBox(height: AppSpacing.lg),
        
        // Header Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'اختر نوع ${selectedSubtype.subtypeName}',
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Grid Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedSubtype.materials.isEmpty
                ? _buildEmptyState(context)
                : GridView.builder(
                    key: ValueKey<int>(selectedSubtype.subtypeId),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: selectedSubtype.materials.length,
                    itemBuilder: (context, index) {
                      final material = selectedSubtype.materials[index];
                      return BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
                        builder: (context, state) {
                          final isSelected = state.selectedMaterialIds.contains(material.id);
                          return FinishingMaterialGridCard(
                            material: material,
                            isSelected: isSelected,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              context.read<AiRoomDesignCubit>().toggleMaterial(
                                material,
                                selectedSubtype.materials,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
        
        // Apply Material Banner
        BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
          builder: (context, state) {
            // Find if there is a selected material in the CURRENT subtype
            final selectedMaterialIdInSubtype = selectedSubtype.materials
                .map((m) => m.id)
                .firstWhere((id) => state.selectedMaterialIds.contains(id), orElse: () => -1);

            if (selectedMaterialIdInSubtype != -1 && widget.unitRooms.length > 1) {
              final selectedMaterial = selectedSubtype.materials.firstWhere((m) => m.id == selectedMaterialIdInSubtype);
              
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: MaterialApplyBanner(
                  onApplyToAll: () {
                    HapticFeedback.mediumImpact();
                    context.read<AiRoomDesignCubit>().applyMaterialToOtherRooms(
                      material: selectedMaterial,
                      siblingMaterials: selectedSubtype.materials,
                      targetRoomIds: widget.unitRooms.map((r) => r.id).toList(),
                    );
                    AppToast.showSuccess(
                      context,
                      'تم تطبيق ${selectedMaterial.name} على جميع الغرف بنجاح',
                    );
                  },
                  onSelectSpecific: () {
                    HapticFeedback.lightImpact();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (bottomSheetContext) => RoomSelectionBottomSheet(
                        availableRooms: widget.unitRooms.where((r) => r.id != widget.currentRoom?.id).toList(),
                        onApply: (selectedRoomIds) {
                          context.read<AiRoomDesignCubit>().applyMaterialToOtherRooms(
                            material: selectedMaterial,
                            siblingMaterials: selectedSubtype.materials,
                            targetRoomIds: selectedRoomIds,
                          );
                          AppToast.showSuccess(
                            context,
                            'تم تطبيق ${selectedMaterial.name} على الغرف المحددة بنجاح',
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    FinishingSubtypeEntity subtype,
    bool isSelected,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primary : context.colors.background,
          borderRadius: BorderRadius.circular(AppRadius.round),
          border: Border.all(
            color: isSelected ? context.colors.primary : context.colors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          subtype.subtypeName,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? context.colors.white : context.colors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      key: const ValueKey('empty_state'),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FluentIcons.box_24_regular,
            size: 48,
            color: context.colors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'لا توجد خامات متاحة في هذا القسم حالياً',
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
      buildWhen: (previous, current) => previous.selectedMaterialIds != current.selectedMaterialIds,
      builder: (context, state) {
        if (_allSubtypes.isEmpty) return const SizedBox.shrink();

        // Determine completion for each subtype
        List<bool> completedStatus = _allSubtypes.map((subtype) {
          return subtype.materials.any((m) => state.selectedMaterialIds.contains(m.id));
        }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تقدم التشطيب',
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.round),
                      ),
                      child: Text(
                        '${completedStatus.where((c) => c).length} / ${_allSubtypes.length} (${(_allSubtypes.isEmpty ? 0 : (completedStatus.where((c) => c).length / _allSubtypes.length * 100)).toInt()}%)',
                        style: TextStyle(
                          fontSize: AppFonts.labelMedium,
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_allSubtypes.length * 2 - 1, (index) {
                    if (index.isOdd) {
                      // Connector line
                      final leftIndex = index ~/ 2;
                      final rightIndex = leftIndex + 1;
                      final isLineGold = completedStatus[leftIndex] && completedStatus[rightIndex];

                      return Container(
                        width: 40,
                        margin: const EdgeInsets.only(top: 14), // Align with center of 28px circle
                        height: 2,
                        color: isLineGold ? context.colors.primary : context.colors.border,
                      );
                    } else {
                      // Step node
                      final stepIndex = index ~/ 2;
                      final subtype = _allSubtypes[stepIndex];
                      final isCompleted = completedStatus[stepIndex];

                      return SizedBox(
                        width: 70, // Fixed width for centering text
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted ? context.colors.primary : context.colors.background,
                                border: Border.all(
                                  color: isCompleted ? context.colors.primary : context.colors.border,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                FluentIcons.checkmark_12_filled,
                                size: 16,
                                color: isCompleted ? context.colors.white : context.colors.border,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              subtype.subtypeName,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppFonts.bodySmall,
                                fontWeight: isCompleted ? FontWeight.bold : FontWeight.w600,
                                color: isCompleted ? context.colors.textPrimary : context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
