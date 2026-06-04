import 'package:equatable/equatable.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';

class DesignContextState extends Equatable {
  final ProjectUnitEntity? selectedUnit;
  final double baseArea;

  const DesignContextState({
    this.selectedUnit,
    this.baseArea = 100.0, // Default area for unselected unit
  });

  DesignContextState copyWith({
    ProjectUnitEntity? selectedUnit,
    double? baseArea,
    bool clearUnit = false,
  }) {
    return DesignContextState(
      selectedUnit: clearUnit ? null : (selectedUnit ?? this.selectedUnit),
      baseArea: baseArea ?? this.baseArea,
    );
  }

  bool get isCustomArea => selectedUnit == null;

  @override
  List<Object?> get props => [selectedUnit, baseArea];
}
