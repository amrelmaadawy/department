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

  // Helper mock data for the bottom sheet
  List<ProjectUnitEntity> getMockOwnedUnits() {
    return [
      ProjectUnitEntity(
        id: 'u101',
        title: 'شقة فاخرة - الدور الأول',
        type: UnitType.apartment,
        price: 3500000,
        area: 145.0,
        bedrooms: 3,
        bathrooms: 2,
        status: UnitStatus.available,
        imagePath: 'assets/images/placeholder_unit.png',
        floor: 1,
        extras: const ['بلكونة', 'مطبخ مفتوح'],
        description: 'شقة فاخرة في موقع متميز',
        images: const ['assets/images/placeholder_unit.png'],
      ),
      ProjectUnitEntity(
        id: 'v205',
        title: 'فيلا مستقلة - إطلالة بحرية',
        type: UnitType.villa,
        price: 12000000,
        area: 320.0,
        bedrooms: 5,
        bathrooms: 4,
        status: UnitStatus.available,
        imagePath: 'assets/images/placeholder_unit.png',
        floor: 0,
        extras: const ['مسبح خاص', 'حديقة'],
        description: 'فيلا راقية تطل على البحر',
        images: const ['assets/images/placeholder_unit.png'],
      ),
    ];
  }
}
