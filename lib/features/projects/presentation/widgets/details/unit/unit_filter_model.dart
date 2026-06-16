import 'package:equatable/equatable.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';

class UnitFilterModel extends Equatable {
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;
  final int? bedrooms;
  final int? bathrooms;
  final String? floorZone;
  final UnitType? unitType;

  const UnitFilterModel({
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.bedrooms,
    this.bathrooms,
    this.floorZone,
    this.unitType,
  });

  UnitFilterModel copyWith({
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    int? bedrooms,
    int? bathrooms,
    String? floorZone,
    UnitType? unitType,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinArea = false,
    bool clearMaxArea = false,
    bool clearBedrooms = false,
    bool clearBathrooms = false,
    bool clearFloorZone = false,
    bool clearUnitType = false,
  }) {
    return UnitFilterModel(
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      minArea: clearMinArea ? null : (minArea ?? this.minArea),
      maxArea: clearMaxArea ? null : (maxArea ?? this.maxArea),
      bedrooms: clearBedrooms ? null : (bedrooms ?? this.bedrooms),
      bathrooms: clearBathrooms ? null : (bathrooms ?? this.bathrooms),
      floorZone: clearFloorZone ? null : (floorZone ?? this.floorZone),
      unitType: clearUnitType ? null : (unitType ?? this.unitType),
    );
  }

  bool get hasActiveFilters =>
      minPrice != null || maxPrice != null || minArea != null || maxArea != null || bedrooms != null || bathrooms != null || floorZone != null || unitType != null;

  int get activeFilterCount {
    int count = 0;
    if (minPrice != null || maxPrice != null) count++;
    if (minArea != null || maxArea != null) count++;
    if (bedrooms != null) count++;
    if (bathrooms != null) count++;
    if (floorZone != null) count++;
    if (unitType != null) count++;
    return count;
  }

  @override
  List<Object?> get props => [minPrice, maxPrice, minArea, maxArea, bedrooms, bathrooms, floorZone, unitType];
}
