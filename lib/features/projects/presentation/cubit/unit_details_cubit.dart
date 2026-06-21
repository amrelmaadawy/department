import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/project_unit_entity.dart';
import '../../domain/usecases/get_unit_details_usecase.dart';
import '../../data/datasources/local/room_design_cache_service.dart';

part 'unit_details_state.dart';

class UnitDetailsCubit extends Cubit<UnitDetailsState> {
  final GetUnitDetailsUseCase getUnitDetailsUseCase;
  final RoomDesignCacheService cacheService;

  UnitDetailsCubit({
    required this.getUnitDetailsUseCase,
    required this.cacheService,
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
      (unit) {
        final totalFinishingCost = _calculateTotalFinishingCost(unit);
        final completedRoomIds = _calculateCompletedRoomIds(unit);
        emit(UnitDetailsLoaded(
          unit: unit, 
          totalFinishingCost: totalFinishingCost,
          completedRoomIds: completedRoomIds,
        ));
      },
    );
  }

  double _calculateTotalFinishingCost(ProjectUnitEntity unit) {
    double total = 0.0;
    for (final room in unit.rooms) {
      final cachedData = cacheService.getRoomDesignProgress(room.id);
      if (cachedData != null) {
        final roomCost = (cachedData['selectedMaterialsCost'] ?? 0.0).toDouble();
        // Since roomCost already includes per-sqm multiplication when user selected in RoomDetailsScreen,
        // we just sum the total cost of each room from cache.
        total += roomCost;
      }
    }
    return total;
  }

  Set<int> _calculateCompletedRoomIds(ProjectUnitEntity unit) {
    Set<int> ids = {};
    for (final room in unit.rooms) {
      final cachedData = cacheService.getRoomDesignProgress(room.id);
      if (cachedData != null && cachedData['isCompleted'] == true) {
        ids.add(room.id);
      }
    }
    return ids;
  }

  void refreshFinishingCost() {
    if (state.unit != null) {
      final total = _calculateTotalFinishingCost(state.unit!);
      final completedRoomIds = _calculateCompletedRoomIds(state.unit!);
      if (state is UnitDetailsLoaded) {
        emit(UnitDetailsLoaded(
          unit: state.unit!, 
          totalFinishingCost: total,
          completedRoomIds: completedRoomIds,
        ));
      }
    }
  }
}
