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
    // Notify Cubit of total subtypes to determine completion status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AiRoomDesignCubit>().setTotalSubtypesCount(_allSubtypes.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_allSubtypes.isEmpty) return const SizedBox.shrink();

    final selectedSubtype = _allSubtypes[_selectedTabIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLinearProgressBar(context),
        const SizedBox(height: AppSpacing.md),
        // Tabs Section
        BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
          buildWhen: (previous, current) => previous.selectedMaterialIds != current.selectedMaterialIds,
          builder: (context, state) {
            return SizedBox(
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
                  final isCompleted = subtype.materials.any((m) => state.selectedMaterialIds.contains(m.id));
                  return _buildTabItem(context, subtype, isSelected, isCompleted, index);
                },
              ),
            );
          },
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
                      childAspectRatio: 0.75,
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
                            roomArea: widget.currentRoom?.area,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              context.read<AiRoomDesignCubit>().toggleMaterial(
                                material,
                                selectedSubtype.materials,
                              );
                              
                              // Auto-Advance Magic ✨
                              if (!isSelected && _selectedTabIndex < _allSubtypes.length - 1) {
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  if (mounted) {
                                    setState(() {
                                      _selectedTabIndex++;
                                    });
                                  }
                                });
                              }
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
    bool isCompleted,
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
          color: isSelected ? context.colors.gold.withValues(alpha: 0.1) : context.colors.background,
          borderRadius: BorderRadius.circular(AppRadius.round),
          border: Border.all(
            color: isSelected ? context.colors.gold : context.colors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCompleted) ...[
              Icon(
                FluentIcons.checkmark_circle_16_filled,
                size: 18,
                color: isSelected ? context.colors.gold : context.colors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              subtype.subtypeName,
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? context.colors.gold : context.colors.textSecondary,
              ),
            ),
          ],
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

  Widget _buildLinearProgressBar(BuildContext context) {
    return BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
      buildWhen: (previous, current) => previous.selectedMaterialIds != current.selectedMaterialIds,
      builder: (context, state) {
        if (_allSubtypes.isEmpty) return const SizedBox.shrink();

        final completedCount = _allSubtypes.where((subtype) {
          return subtype.materials.any((m) => state.selectedMaterialIds.contains(m.id));
        }).length;
        
        final progress = completedCount / _allSubtypes.length;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تقدم الغرفة',
                    style: TextStyle(
                      fontSize: AppFonts.labelMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textSecondary,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: AppFonts.labelMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.round),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: context.colors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
