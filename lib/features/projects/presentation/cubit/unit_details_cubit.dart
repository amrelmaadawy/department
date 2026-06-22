import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/project_unit_entity.dart';
import '../../domain/usecases/get_unit_details_usecase.dart';
import '../../domain/usecases/get_customer_renders_use_case.dart';
import '../../domain/entities/customer_render_entity.dart';
import '../../data/datasources/local/room_design_cache_service.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart' as dartz;

part 'unit_details_state.dart';

class UnitDetailsCubit extends Cubit<UnitDetailsState> {
  final GetUnitDetailsUseCase getUnitDetailsUseCase;
  final GetCustomerRendersUseCase getCustomerRendersUseCase;
  final RoomDesignCacheService cacheService;

  UnitDetailsCubit({
    required this.getUnitDetailsUseCase,
    required this.getCustomerRendersUseCase,
    required this.cacheService,
  }) : super(UnitDetailsInitial());

  Future<void> loadUnitDetails(int id, {ProjectUnitEntity? initialUnit}) async {
    emit(UnitDetailsLoading(unit: initialUnit));

    // Fetch unit details and customer renders concurrently
    final responses = await Future.wait([
      getUnitDetailsUseCase(id),
      getCustomerRendersUseCase(id),
    ]);

    final unitResult = responses[0] as dartz.Either<Failure, ProjectUnitEntity>;
    final rendersResult = responses[1] as dartz.Either<Failure, List<RoomCustomerRendersEntity>>;

    unitResult.fold(
      (failure) => emit(UnitDetailsError(
        message: failure.message,
        unit: initialUnit,
      )),
      (unit) {
        final totalFinishingCost = _calculateTotalFinishingCost(unit);
        final completedRoomIds = _calculateCompletedRoomIds(unit);
        
        List<RoomCustomerRendersEntity> customerRenders = [];
        rendersResult.fold(
          (failure) {}, // Ignore renders failure silently or handle it
          (renders) => customerRenders = renders,
        );

        emit(UnitDetailsLoaded(
          unit: unit, 
          totalFinishingCost: totalFinishingCost,
          completedRoomIds: completedRoomIds,
          customerRenders: customerRenders,
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
          customerRenders: state.customerRenders,
        ));
      }
    }
  }

  Future<void> refreshCustomerRenders() async {
    if (state.unit == null) return;
    
    final id = int.parse(state.unit!.id);
    final result = await getCustomerRendersUseCase(id);

    result.fold(
      (failure) {}, // Silently ignore failures on background refresh
      (renders) {
        if (state is UnitDetailsLoaded) {
          emit(UnitDetailsLoaded(
            unit: state.unit!,
            totalFinishingCost: state.totalFinishingCost,
            completedRoomIds: state.completedRoomIds,
            customerRenders: renders,
          ));
        }
      },
    );
  }
}
