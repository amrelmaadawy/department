import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'project_unit_card.dart';

class ProjectUnitsTab extends StatefulWidget {
  final List<ProjectUnitEntity> units;

  const ProjectUnitsTab({super.key, required this.units});

  @override
  State<ProjectUnitsTab> createState() => _ProjectUnitsTabState();
}

class _ProjectUnitsTabState extends State<ProjectUnitsTab> {
  String _selectedFilter = 'all';
  String? _selectedUnitId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Filter units
    final filteredUnits = widget.units.where((unit) {
      if (_selectedFilter == 'all') return true;
      if (_selectedFilter == 'apartment' && unit.type == UnitType.apartment)
        return true;
      if (_selectedFilter == 'villa' && unit.type == UnitType.villa)
        return true;
      if (_selectedFilter == 'duplex' && unit.type == UnitType.duplex)
        return true;
      return false;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),

        // Horizontal Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              _buildFilterChip(l10n.filterAll, 'all'),
              const SizedBox(width: AppSpacing.sm),
              _buildFilterChip(l10n.filterApartment, 'apartment'),
              const SizedBox(width: AppSpacing.sm),
              _buildFilterChip(l10n.filterVilla, 'villa'),
              const SizedBox(width: AppSpacing.sm),
              _buildFilterChip(l10n.filterDuplex, 'duplex'),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Units List / Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // Tablet View
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          childAspectRatio: 2.5, // Wide card ratio
                        ),
                    itemCount: filteredUnits.length,
                    itemBuilder: (context, index) {
                      final unit = filteredUnits[index];
                      return ProjectUnitCard(
                        key: ValueKey(unit.id),
                        unit: unit,
                        index: index,
                        isSelected: _selectedUnitId == unit.id,
                        onTap: () {
                          setState(() {
                            _selectedUnitId = unit.id;
                          });
                          // Allow animation to finish or user to see selection
                          Future.delayed(const Duration(milliseconds: 150), () {
                            if (context.mounted) {
                              context.push(
                                AppRouter.unitDetails,
                                extra: {
                                  'unit': unit,
                                  'heroTag': 'unit_${unit.id}',
                                },
                              );
                            }
                          });
                        },
                      );
                    },
                  );
                }

                // Mobile View
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredUnits.length,
                  itemBuilder: (context, index) {
                    final unit = filteredUnits[index];
                    return ProjectUnitCard(
                      key: ValueKey(unit.id),
                      unit: unit,
                      index: index,
                      isSelected: _selectedUnitId == unit.id,
                      onTap: () {
                        setState(() {
                          _selectedUnitId = unit.id;
                        });
                        Future.delayed(const Duration(milliseconds: 150), () {
                          if (context.mounted) {
                            context.push(
                              AppRouter.unitDetails,
                              extra: {
                                'unit': unit,
                                'heroTag': 'unit_${unit.id}',
                              },
                            );
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildFilterChip(String label, String filterValue) {
    final isSelected = _selectedFilter == filterValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = filterValue;
          });
        }
      },
      selectedColor: AppColors.gold,
      backgroundColor: AppColors.background,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: AppFonts.bodyMedium,
      ),
      side: isSelected
          ? BorderSide.none
          : const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100), // Fully rounded pill shape
      ),
    );
  }
}
