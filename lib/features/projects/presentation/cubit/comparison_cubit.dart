import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'comparison_state.dart';

class ComparisonCubit extends Cubit<ComparisonState> {
  ComparisonCubit() : super(const ComparisonState());

  void toggleComparisonMode() {
    emit(state.copyWith(
      isComparisonMode: !state.isComparisonMode,
      selectedUnits: !state.isComparisonMode ? state.selectedUnits : [], // Clear if closing
    ));
  }

  void toggleUnit(ProjectUnitEntity unit) {
    if (!state.isComparisonMode) return;

    final currentUnits = List<ProjectUnitEntity>.from(state.selectedUnits);
    final isSelected = currentUnits.any((u) => u.id == unit.id);

    if (isSelected) {
      currentUnits.removeWhere((u) => u.id == unit.id);
      emit(state.copyWith(selectedUnits: currentUnits));
    } else {
      if (state.canAddMore) {
        currentUnits.add(unit);
        emit(state.copyWith(selectedUnits: currentUnits));
      }
    }
  }

  void clearSelection() {
    emit(state.copyWith(selectedUnits: []));
  }
}
