import 'package:equatable/equatable.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';

class ComparisonState extends Equatable {
  final bool isComparisonMode;
  final List<ProjectUnitEntity> selectedUnits;
  final int maxUnits;

  const ComparisonState({
    this.isComparisonMode = false,
    this.selectedUnits = const [],
    this.maxUnits = 3,
  });

  bool get canAddMore => selectedUnits.length < maxUnits;

  ComparisonState copyWith({
    bool? isComparisonMode,
    List<ProjectUnitEntity>? selectedUnits,
    int? maxUnits,
  }) {
    return ComparisonState(
      isComparisonMode: isComparisonMode ?? this.isComparisonMode,
      selectedUnits: selectedUnits ?? this.selectedUnits,
      maxUnits: maxUnits ?? this.maxUnits,
    );
  }

  @override
  List<Object> get props => [isComparisonMode, selectedUnits, maxUnits];
}
