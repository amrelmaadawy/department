import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'unit_filter_model.dart';
import 'floor_zones_tabs.dart';

class UnitFilterBottomSheet extends StatefulWidget {
  final UnitFilterModel initialFilter;
  final double minProjectPrice;
  final double maxProjectPrice;
  final double minProjectArea;
  final double maxProjectArea;
  final List<String> availableZones;
  final List<int> availableBedrooms;
  final List<int> availableBathrooms;
  final List<UnitType> availableTypes;

  const UnitFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.minProjectPrice,
    required this.maxProjectPrice,
    required this.minProjectArea,
    required this.maxProjectArea,
    required this.availableZones,
    required this.availableBedrooms,
    required this.availableBathrooms,
    required this.availableTypes,
  });

  @override
  State<UnitFilterBottomSheet> createState() => _UnitFilterBottomSheetState();

  static Future<UnitFilterModel?> show({
    required BuildContext context,
    required UnitFilterModel initialFilter,
    required double minProjectPrice,
    required double maxProjectPrice,
    required double minProjectArea,
    required double maxProjectArea,
    required List<String> availableZones,
    required List<int> availableBedrooms,
    required List<int> availableBathrooms,
    required List<UnitType> availableTypes,
  }) {
    return showModalBottomSheet<UnitFilterModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UnitFilterBottomSheet(
        initialFilter: initialFilter,
        minProjectPrice: minProjectPrice,
        maxProjectPrice: maxProjectPrice,
        minProjectArea: minProjectArea,
        maxProjectArea: maxProjectArea,
        availableZones: availableZones,
        availableBedrooms: availableBedrooms,
        availableBathrooms: availableBathrooms,
        availableTypes: availableTypes,
      ),
    );
  }
}

class _UnitFilterBottomSheetState extends State<UnitFilterBottomSheet> {
  late UnitFilterModel _currentFilter;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
  }

  void _applyFilters() {
    Navigator.of(context).pop(_currentFilter);
  }

  void _resetFilters() {
    setState(() {
      _currentFilter = const UnitFilterModel();
    });
  }

  Widget _buildDivider() {
    return Divider(
      height: 48,
      thickness: 1,
      color: context.colors.border.withValues(alpha: 0.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.md),
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تصفية الوحدات',
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  style: TextButton.styleFrom(
                    foregroundColor: context.colors.error,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  ),
                  child: Text(
                    'مسح الكل',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFonts.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Divider(color: context.colors.border.withValues(alpha: 0.5), height: 1),

          // Scrollable Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildPriceSection(),
                _buildDivider(),
                _buildAreaSection(),
                _buildDivider(),
                _buildBedroomsSection(),
                _buildDivider(),
                _buildBathroomsSection(),
                _buildDivider(),
                _buildFloorSection(),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.colors.background,
              boxShadow: [
                BoxShadow(
                  color: context.colors.textPrimary.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  minimumSize: const Size(double.infinity, 56),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'تطبيق الفلاتر',
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.white,
                      ),
                    ),
                    if (_currentFilter.activeFilterCount > 0) ...[
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.colors.gold,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_currentFilter.activeFilterCount}',
                          style: TextStyle(
                            fontSize: AppFonts.labelMedium,
                            fontWeight: FontWeight.bold,
                            color: context.colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    double minVal = widget.minProjectPrice;
    double maxVal = widget.maxProjectPrice > widget.minProjectPrice ? widget.maxProjectPrice : minVal + 1000000;
    
    double currentMin = _currentFilter.minPrice ?? minVal;
    double currentMax = _currentFilter.maxPrice ?? maxVal;

    currentMin = currentMin.clamp(minVal, maxVal);
    currentMax = currentMax.clamp(currentMin, maxVal);

    return _buildFilterSection(
      title: 'نطاق السعر',
      valueWidget: Row(
        children: [
          Text(
            '${_formatPrice(currentMin)}',
            style: TextStyle(
              color: context.colors.gold,
              fontWeight: FontWeight.bold,
              fontSize: AppFonts.bodyLarge,
            ),
          ),
          Text(
            ' - ',
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: AppFonts.bodyLarge,
            ),
          ),
          Text(
            '${_formatPrice(currentMax)} ريال',
            style: TextStyle(
              color: context.colors.gold,
              fontWeight: FontWeight.bold,
              fontSize: AppFonts.bodyLarge,
            ),
          ),
        ],
      ),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6.0,
          activeTrackColor: context.colors.gold,
          inactiveTrackColor: context.colors.background,
          thumbColor: context.colors.gold,
          overlayColor: context.colors.gold.withValues(alpha: 0.15),
          rangeThumbShape: const RoundRangeSliderThumbShape(
            enabledThumbRadius: 12,
            elevation: 4,
          ),
        ),
        child: RangeSlider(
          values: RangeValues(currentMin, currentMax),
          min: minVal,
          max: maxVal,
          onChanged: (RangeValues values) {
            setState(() {
              _currentFilter = _currentFilter.copyWith(
                minPrice: values.start,
                maxPrice: values.end,
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildAreaSection() {
    double minVal = widget.minProjectArea;
    double maxVal = widget.maxProjectArea > widget.minProjectArea ? widget.maxProjectArea : minVal + 100;
    
    double currentMin = _currentFilter.minArea ?? minVal;
    double currentMax = _currentFilter.maxArea ?? maxVal;

    currentMin = currentMin.clamp(minVal, maxVal);
    currentMax = currentMax.clamp(currentMin, maxVal);

    return _buildFilterSection(
      title: 'المساحة',
      valueWidget: Row(
        children: [
          Text(
            '${currentMin.toInt()}',
            style: TextStyle(
              color: context.colors.gold,
              fontWeight: FontWeight.bold,
              fontSize: AppFonts.bodyLarge,
            ),
          ),
          Text(
            ' - ',
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: AppFonts.bodyLarge,
            ),
          ),
          Text(
            '${currentMax.toInt()} م²',
            style: TextStyle(
              color: context.colors.gold,
              fontWeight: FontWeight.bold,
              fontSize: AppFonts.bodyLarge,
            ),
          ),
        ],
      ),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6.0,
          activeTrackColor: context.colors.gold,
          inactiveTrackColor: context.colors.background,
          thumbColor: context.colors.gold,
          overlayColor: context.colors.gold.withValues(alpha: 0.15),
          rangeThumbShape: const RoundRangeSliderThumbShape(
            enabledThumbRadius: 12,
            elevation: 4,
          ),
        ),
        child: RangeSlider(
          values: RangeValues(currentMin, currentMax),
          min: minVal,
          max: maxVal,
          onChanged: (RangeValues values) {
            setState(() {
              _currentFilter = _currentFilter.copyWith(
                minArea: values.start,
                maxArea: values.end,
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildBedroomsSection() {
    if (widget.availableBedrooms.isEmpty) return const SizedBox.shrink();

    return _buildFilterSection(
      title: 'عدد الغرف',
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: widget.availableBedrooms.map((beds) {
          final isSelected = _currentFilter.bedrooms == beds;
          return _buildPremiumChip(
            label: '$beds',
            isSelected: isSelected,
            onSelected: (selected) {
              setState(() {
                _currentFilter = _currentFilter.copyWith(
                  bedrooms: selected ? beds : null,
                  clearBedrooms: !selected,
                );
              });
            },
            isCircular: true,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBathroomsSection() {
    if (widget.availableBathrooms.isEmpty) return const SizedBox.shrink();

    return _buildFilterSection(
      title: 'عدد الحمامات',
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: widget.availableBathrooms.map((baths) {
          final isSelected = _currentFilter.bathrooms == baths;
          return _buildPremiumChip(
            label: '$baths',
            isSelected: isSelected,
            onSelected: (selected) {
              setState(() {
                _currentFilter = _currentFilter.copyWith(
                  bathrooms: selected ? baths : null,
                  clearBathrooms: !selected,
                );
              });
            },
            isCircular: true,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFloorSection() {
    if (widget.availableZones.isEmpty) return const SizedBox.shrink();
    
    return _buildFilterSection(
      title: 'الدور / المنطقة',
      child: Transform.translate(
        offset: const Offset(-AppSpacing.lg, 0),
        child: FloorZonesTabs(
          zones: widget.availableZones,
          selectedZone: _currentFilter.floorZone,
          onZoneSelected: (zone) {
            setState(() {
              _currentFilter = _currentFilter.copyWith(
                floorZone: zone,
                clearFloorZone: zone == null,
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    Widget? valueWidget,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          if (valueWidget != null) ...[
            const SizedBox(height: AppSpacing.xs),
            valueWidget,
          ],
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }

  Widget _buildPremiumChip({
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
    bool isCircular = false,
  }) {
    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isCircular ? 24 : AppSpacing.xl,
          vertical: isCircular ? 18 : 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.gold : context.colors.background,
          borderRadius: BorderRadius.circular(isCircular ? 100 : AppRadius.xl),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.colors.gold.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.bodyLarge,
            fontWeight: FontWeight.bold,
            color: isSelected ? context.colors.white : context.colors.textPrimary,
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)} مليون';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)} ألف';
    }
    return price.toStringAsFixed(0);
  }
}
