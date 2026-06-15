import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'design_context_state.dart';

class DesignContextCubit extends Cubit<DesignContextState> {
  DesignContextCubit() : super(const DesignContextState());

  void selectUnit(ProjectUnitEntity unit) {
    emit(state.copyWith(
      selectedUnit: unit,
      baseArea: unit.area,
    ));
  }

  void clearUnitSelection() {
    emit(state.copyWith(
      clearUnit: true,
      baseArea: 100.0, // Default back to 100
    ));
  }

  void updateCustomArea(double area) {
    if (state.selectedUnit == null) {
      emit(state.copyWith(baseArea: area));
    }
  }

  // Helper mock data for the bottom sheet (To be replaced with actual API call)
  List<ProjectUnitEntity> getMockOwnedUnits() {
    return [];
  }
}
