import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/project_unit_entity.dart';
import '../../domain/usecases/get_unit_details_usecase.dart';

part 'unit_details_state.dart';

class UnitDetailsCubit extends Cubit<UnitDetailsState> {
  final GetUnitDetailsUseCase getUnitDetailsUseCase;

  UnitDetailsCubit({
    required this.getUnitDetailsUseCase,
  }) : super(UnitDetailsInitial());

  Future<void> loadUnitDetails(int id, {ProjectUnitEntity? initialUnit}) async {
    // Show initial unit if provided, but indicate it's loading details
    emit(UnitDetailsLoading(unit: initialUnit));

    final result = await getUnitDetailsUseCase(id);

    result.fold(
      (failure) => emit(UnitDetailsError(
        message: failure.message,
        unit: initialUnit,
      )),
      (unit) => emit(UnitDetailsLoaded(unit: unit)),
    );
  }
}
