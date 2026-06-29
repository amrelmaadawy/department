import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/projects/presentation/cubit/comparison_cubit.dart' as import_comparison;
import 'package:apartment/features/projects/presentation/cubit/comparison_state.dart' as import_comparison;
import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'project_unit_card.dart';
import 'unit/unit_filter_model.dart';
import 'unit/unit_filter_bottom_sheet.dart';
import 'package:apartment/core/utils/responsive_builder.dart';

class ProjectUnitsTab extends StatefulWidget {
  final List<ProjectUnitEntity> units;

  const ProjectUnitsTab({super.key, required this.units});

  @override
  State<ProjectUnitsTab> createState() => _ProjectUnitsTabState();
}

class _ProjectUnitsTabState extends State<ProjectUnitsTab> {
  String? _selectedUnitId;
  UnitFilterModel _activeFilter = const UnitFilterModel();
  List<int> _floors = [];
  List<String> _zones = [];
  List<int> _bedrooms = [];
  List<int> _bathrooms = [];
  List<UnitType> _types = [];
  double _minPrice = 0;
  double _maxPrice = 0;
  double _minArea = 0;
  double _maxArea = 0;

  @override
  void initState() {
    super.initState();
    _extractFilterData();
  }

  @override
  void didUpdateWidget(covariant ProjectUnitsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.units != oldWidget.units) {
      _extractFilterData();
    }
  }

  void _extractFilterData() {
    if (widget.units.isEmpty) return;

    final uniqueFloors = widget.units.map((u) => u.floor).toSet().toList();
    uniqueFloors.sort();
    
    final uniqueBeds = widget.units.map((u) => u.roomsCount).where((c) => c > 0).toSet().toList();
    uniqueBeds.sort();

    final uniqueBaths = widget.units.map((u) => u.bathrooms).where((b) => b > 0).toSet().toList();
    uniqueBaths.sort();

    final uniqueTypes = widget.units.map((u) => u.type).toSet().toList();

    double minP = widget.units.first.price;
    double maxP = widget.units.first.price;
    double minA = widget.units.first.area;
    double maxA = widget.units.first.area;

    for (var u in widget.units) {
      if (u.price < minP) minP = u.price;
      if (u.price > maxP) maxP = u.price;
      if (u.area < minA) minA = u.area;
      if (u.area > maxA) maxA = u.area;
    }

    setState(() {
      _floors = uniqueFloors;
      _bedrooms = uniqueBeds;
      _bathrooms = uniqueBaths;
      _types = uniqueTypes;
      _minPrice = minP;
      _maxPrice = maxP;
      _minArea = minA;
      _maxArea = maxA;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_floors.isNotEmpty && _zones.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _zones = _floors.map((f) => _getFloorZoneName(f, l10n)).toList();
      });
    }
  }

  Future<void> _openFilterSheet() async {
    final result = await UnitFilterBottomSheet.show(
      context: context,
      initialFilter: _activeFilter,
      minProjectPrice: _minPrice,
      maxProjectPrice: _maxPrice,
      minProjectArea: _minArea,
      maxProjectArea: _maxArea,
      availableZones: _zones,
      availableBedrooms: _bedrooms,
      availableBathrooms: _bathrooms,
      availableTypes: _types,
    );

    if (result != null) {
      setState(() {
        _activeFilter = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.units.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xxxl),
        child: _buildEmptyState(context, isFilter: false),
      );
    }

    final filteredUnits = widget.units.where((u) {
      if (_activeFilter.minPrice != null && u.price < _activeFilter.minPrice!) return false;
      if (_activeFilter.maxPrice != null && u.price > _activeFilter.maxPrice!) return false;
      if (_activeFilter.minArea != null && u.area < _activeFilter.minArea!) return false;
      if (_activeFilter.maxArea != null && u.area > _activeFilter.maxArea!) return false;
      if (_activeFilter.bedrooms != null && u.roomsCount != _activeFilter.bedrooms) return false;
      if (_activeFilter.bathrooms != null && u.bathrooms != _activeFilter.bathrooms) return false;
      if (_activeFilter.unitType != null && u.type != _activeFilter.unitType) return false;
      if (_activeFilter.floorZone != null) {
        if (_getFloorZoneName(u.floor, AppLocalizations.of(context)!) != _activeFilter.floorZone) return false;
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Unit Type Categories
        if (_types.length > 1) ...[
          _buildTypeTabs(),
          const SizedBox(height: AppSpacing.xl),
        ],

        // Filter & Compare Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${filteredUnits.length} ${AppLocalizations.of(context)!.noMatchingUnits.split(' ').last}', // Reusing units text or formatting
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge, // Smaller and elegant
                    color: context.colors.textSecondary, // Lighter color for better visual hierarchy
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  // Compare Button
                  BlocBuilder<import_comparison.ComparisonCubit, import_comparison.ComparisonState>(
                    builder: (context, compState) {
                      final isCompMode = compState.isComparisonMode;
                      return GestureDetector(
                        onTap: () => context.read<import_comparison.ComparisonCubit>().toggleComparisonMode(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
                          margin: const EdgeInsets.only(right: AppSpacing.sm), // RTL: left side of compare is filter
                          decoration: BoxDecoration(
                            color: isCompMode ? context.colors.gold : context.colors.background,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            border: Border.all(
                              color: isCompMode ? context.colors.gold : context.colors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                FluentIcons.slide_multiple_24_regular,
                                size: 20,
                                color: isCompMode ? context.colors.white : context.colors.textPrimary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                AppLocalizations.of(context)!.compareUnits,
                                style: TextStyle(
                                  fontSize: AppFonts.labelLarge,
                                  fontWeight: FontWeight.bold,
                                  color: isCompMode ? context.colors.white : context.colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Filter Button
                  GestureDetector(
                onTap: _openFilterSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
                  decoration: BoxDecoration(
                    color: _activeFilter.hasActiveFilters 
                        ? context.colors.primary 
                        : context.colors.background,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: _activeFilter.hasActiveFilters 
                          ? context.colors.gold 
                          : context.colors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FluentIcons.filter_24_regular,
                        size: 20,
                        color: _activeFilter.hasActiveFilters 
                            ? context.colors.white 
                            : context.colors.textPrimary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        AppLocalizations.of(context)!.filter,
                        style: TextStyle(
                          fontSize: AppFonts.labelLarge,
                          fontWeight: FontWeight.bold,
                          color: _activeFilter.hasActiveFilters 
                              ? context.colors.white 
                              : context.colors.textPrimary,
                        ),
                      ),
                      if (_activeFilter.activeFilterCount > 0) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: context.colors.gold,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${_activeFilter.activeFilterCount}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: context.colors.white,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ), // Closes Row
                ), // Closes Container
              ), // Closes GestureDetector
              ], // Closes inner Row children
            ), // Closes inner Row widget
            ], // Closes main Row children
          ), // Closes main Row widget
        ), // Closes Padding
        const SizedBox(height: AppSpacing.md),
        // Units List / Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            child: Builder(
              builder: (context) {
                if (filteredUnits.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: _buildEmptyState(context, isFilter: true),
                  );
                }

                final groupedUnits = <int, List<ProjectUnitEntity>>{};
                for (var unit in filteredUnits) {
                  groupedUnits.putIfAbsent(unit.floor, () => []).add(unit);
                }
                final sortedFloors = groupedUnits.keys.toList()..sort();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: sortedFloors.map((floor) {
                    final unitsInFloor = groupedUnits[floor]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFloorHeader(floor, AppLocalizations.of(context)!),
                        if (!context.isMobile)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: context.responsiveCrossAxisCount,
                              crossAxisSpacing: AppSpacing.md,
                              mainAxisSpacing: AppSpacing.md,
                              mainAxisExtent: 200, // Fixed safe height for all widths
                            ),
                            itemCount: unitsInFloor.length,
                            itemBuilder: (context, index) => _buildUnitCard(context, unitsInFloor[index], index),
                          )
                        else
                          ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: unitsInFloor.length,
                            itemBuilder: (context, index) => _buildUnitCard(context, unitsInFloor[index], index),
                          ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildUnitCard(BuildContext context, ProjectUnitEntity unit, int index) {
    return BlocBuilder<import_comparison.ComparisonCubit, import_comparison.ComparisonState>(
      builder: (context, compState) {
        final isCompMode = compState.isComparisonMode;
        final isSelected = isCompMode 
            ? compState.selectedUnits.any((u) => u.id == unit.id)
            : _selectedUnitId == unit.id;

        return ProjectUnitCard(
          key: ValueKey(unit.id),
          unit: unit,
          index: index,
          isSelected: isSelected,
          isComparisonMode: isCompMode,
          onTap: () {
            if (isCompMode) {
              context.read<import_comparison.ComparisonCubit>().toggleUnit(unit);
              return;
            }

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
  }

  Widget _buildFloorHeader(int floor, AppLocalizations l10n) {
    String floorName = _getFloorZoneName(floor, l10n);
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
            decoration: BoxDecoration(
              color: context.colors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: context.colors.gold.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FluentIcons.building_multiple_24_regular,
                  color: context.colors.gold,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  floorName,
                  style: TextStyle(
                    fontSize: AppFonts.labelLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.gold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Divider(
              color: context.colors.border.withValues(alpha: 0.5),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, {required bool isFilter}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: context.colors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFilter ? FluentIcons.filter_dismiss_24_regular : FluentIcons.building_desktop_24_regular,
              size: 48,
              color: context.colors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            isFilter ? AppLocalizations.of(context)!.noMatchingUnits : AppLocalizations.of(context)!.noAvailableUnits,
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isFilter 
                ? AppLocalizations.of(context)!.tryAdjustingFilters
                : AppLocalizations.of(context)!.unitsWillBeAddedSoon,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              color: context.colors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (isFilter) ...[
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _activeFilter = const UnitFilterModel();
                });
              },
              icon: const Icon(FluentIcons.arrow_counterclockwise_24_regular, size: 20),
              label: Text(AppLocalizations.of(context)!.clearFilters, style: const TextStyle(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colors.error,
                side: BorderSide(color: context.colors.error.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          _buildTypeTabItem(null, AppLocalizations.of(context)!.all),
          ..._types.map((type) => _buildTypeTabItem(type, _getTypeLabel(type, AppLocalizations.of(context)!))),
        ],
      ),
    );
  }

  Widget _buildTypeTabItem(UnitType? type, String label) {
    final isSelected = _activeFilter.unitType == type;
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.md),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeFilter = _activeFilter.copyWith(
              unitType: type,
              clearUnitType: type == null,
            );
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      context.colors.gold,
                      context.colors.gold.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : context.colors.background,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: isSelected ? AppColors.transparent : context.colors.border.withValues(alpha: 0.5),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.colors.gold.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? context.colors.white : context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  String _getTypeLabel(UnitType type, AppLocalizations l10n) {
    switch (type) {
      case UnitType.apartment:
        return l10n.apartments;
      case UnitType.villa:
        return l10n.villas;
      case UnitType.duplex:
        return l10n.duplexes;
    }
  }

  String _getFloorZoneName(int floor, AppLocalizations l10n) {
    return floor == 0 ? l10n.groundFloor : l10n.floorDesc(floor.toString());
  }
}
