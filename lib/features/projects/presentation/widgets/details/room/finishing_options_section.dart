import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../home/domain/entities/finishing_category_entity.dart';
import '../../../../../home/domain/entities/finishing_subtype_entity.dart';
import '../../../../../../core/widgets/app_toast.dart';
import '../../../../../home/domain/entities/unit_room_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

import 'finishing_material_grid_card.dart';
import 'material_apply_banner.dart';
import 'room_selection_bottom_sheet.dart';
import 'room_linear_progress_bar.dart';
import 'subtype_tab_item.dart';
import 'finishing_empty_state.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AiRoomDesignCubit>().setTotalSubtypesCount(_allSubtypes.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_allSubtypes.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    final selectedSubtype = _allSubtypes[_selectedTabIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoomLinearProgressBar(allSubtypes: _allSubtypes),
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
                  return SubtypeTabItem(
                    subtype: subtype,
                    isSelected: isSelected,
                    isCompleted: isCompleted,
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                  );
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
            l10n.chooseTypeOf(selectedSubtype.subtypeName),
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
                ? const FinishingEmptyState()
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
}
