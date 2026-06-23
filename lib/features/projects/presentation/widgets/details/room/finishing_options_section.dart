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
import '../../../../../home/domain/entities/unit_room_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

import 'finishing_material_grid_card.dart';
import 'inline_material_apply.dart';
import 'room_linear_progress_bar.dart';
import 'subtype_tab_item.dart';
import 'finishing_empty_state.dart';
import 'material_preview_sheet.dart';

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
  int? _highlightedTabIndex;

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
                  final isHighlighted = index == _highlightedTabIndex;
                  final subtype = _allSubtypes[index];
                  final isCompleted = subtype.materials.any((m) => state.selectedMaterialIds.contains(m.id));
                  return SubtypeTabItem(
                    subtype: subtype,
                    isSelected: isSelected,
                    isCompleted: isCompleted,
                    isHighlighted: isHighlighted,
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
                              MaterialPreviewSheet.show(
                                context,
                                material: material,
                                isSelected: isSelected,
                                roomArea: widget.currentRoom?.area,
                                onToggleSelection: () {
                                  context.read<AiRoomDesignCubit>().toggleMaterial(
                                    material,
                                    selectedSubtype.materials,
                                  );
                                  
                                  if (!isSelected && _selectedTabIndex < _allSubtypes.length - 1) {
                                    setState(() {
                                      _highlightedTabIndex = _selectedTabIndex + 1;
                                    });
                                    Future.delayed(const Duration(seconds: 2), () {
                                      if (mounted) {
                                        setState(() {
                                          _highlightedTabIndex = null;
                                        });
                                      }
                                    });
                                  }
                                },
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
            final selectedMaterialIdInSubtype = selectedSubtype.materials
                .map((m) => m.id)
                .firstWhere((id) => state.selectedMaterialIds.contains(id), orElse: () => -1);

            if (selectedMaterialIdInSubtype != -1 && widget.unitRooms.length > 1) {
              final selectedMaterial = selectedSubtype.materials.firstWhere((m) => m.id == selectedMaterialIdInSubtype);
              
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: InlineMaterialApply(
                  selectedMaterial: selectedMaterial,
                  otherRooms: widget.unitRooms.where((r) => r.id != widget.currentRoom?.id).toList(),
                  currentlyAppliedRoomIds: widget.unitRooms.where((r) {
                    final cachedData = context.read<AiRoomDesignCubit>().cacheService.getRoomDesignProgress(r.id);
                    if (cachedData == null) return false;
                    final ids = List<int>.from(cachedData['selectedMaterialIds'] ?? []);
                    return ids.contains(selectedMaterial.id);
                  }).map((r) => r.id).toList(),
                  onApplyChanged: (applyToAll, specificRoomIds) {
                    context.read<AiRoomDesignCubit>().applyMaterialToOtherRooms(
                      material: selectedMaterial,
                      siblingMaterials: selectedSubtype.materials,
                      targetRoomIds: specificRoomIds,
                      allOtherRoomIds: widget.unitRooms.where((r) => r.id != widget.currentRoom?.id).map((r) => r.id).toList(),
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
