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

class FinishingOptionsSection extends StatefulWidget {
  final List<FinishingCategoryEntity> options;

  const FinishingOptionsSection({super.key, required this.options});

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
        int totalSteps = _allSubtypes.length;
        int completedSteps = 0;

        for (var subtype in _allSubtypes) {
          bool hasSelection = subtype.materials.any((m) => state.selectedMaterialIds.contains(m.id));
          if (hasSelection) {
            completedSteps++;
          }
        }

        double progress = totalSteps == 0 ? 0 : completedSteps / totalSteps;
        int percentage = (progress * 100).toInt();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تقدم التشطيب',
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  Text(
                    '$completedSteps / $totalSteps ($percentage%)',
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.colors.border.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
                alignment: AlignmentDirectional.centerStart,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  tween: Tween<double>(begin: 0, end: progress),
                  builder: (context, value, _) {
                    return FractionallySizedBox(
                      widthFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colors.primary,
                          borderRadius: BorderRadius.circular(AppRadius.round),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
