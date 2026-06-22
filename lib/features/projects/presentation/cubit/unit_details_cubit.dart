import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/project_unit_entity.dart';
import '../../domain/usecases/get_unit_details_usecase.dart';
import '../../domain/usecases/get_customer_renders_use_case.dart';
import '../../domain/usecases/toggle_customer_render_favorite_use_case.dart';
import '../../domain/entities/customer_render_entity.dart';
import '../../data/datasources/local/room_design_cache_service.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart' as dartz;

part 'unit_details_state.dart';

class UnitDetailsCubit extends Cubit<UnitDetailsState> {
  final GetUnitDetailsUseCase getUnitDetailsUseCase;
  final GetCustomerRendersUseCase getCustomerRendersUseCase;
  final ToggleCustomerRenderFavoriteUseCase toggleCustomerRenderFavoriteUseCase;
  final RoomDesignCacheService cacheService;

  UnitDetailsCubit({
    required this.getUnitDetailsUseCase,
    required this.getCustomerRendersUseCase,
    required this.toggleCustomerRenderFavoriteUseCase,
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
        final roomCosts = _calculateRoomCosts(unit);
        final totalFinishingCost = roomCosts.values.fold(0.0, (sum, cost) => sum + cost);
        final completedRoomIds = _calculateCompletedRoomIds(unit);
        
        List<RoomCustomerRendersEntity> customerRenders = [];
        rendersResult.fold(
          (failure) {}, // Ignore renders failure silently or handle it
          (renders) => customerRenders = renders,
        );

        emit(UnitDetailsLoaded(
          unit: unit, 
          totalFinishingCost: totalFinishingCost,
          roomCosts: roomCosts,
          completedRoomIds: completedRoomIds,
          customerRenders: customerRenders,
        ));
      },
    );
  }

  Map<int, double> _calculateRoomCosts(ProjectUnitEntity unit) {
    Map<int, double> costs = {};
    for (final room in unit.rooms) {
      final cachedData = cacheService.getRoomDesignProgress(room.id);
      if (cachedData != null) {
        final roomCost = (cachedData['selectedMaterialsCost'] ?? 0.0).toDouble();
        costs[room.id] = roomCost;
      }
    }
    return costs;
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
      final roomCosts = _calculateRoomCosts(state.unit!);
      final total = roomCosts.values.fold(0.0, (sum, cost) => sum + cost);
      final completedRoomIds = _calculateCompletedRoomIds(state.unit!);
      if (state is UnitDetailsLoaded) {
        emit(UnitDetailsLoaded(
          unit: state.unit!, 
          totalFinishingCost: total,
          roomCosts: roomCosts,
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
            roomCosts: state.roomCosts,
            completedRoomIds: state.completedRoomIds,
            customerRenders: renders,
          ));
        }
      },
    );
  }

  Future<void> toggleRenderFavorite(int apartmentId, int roomId, String imageUrl) async {
    if (state is! UnitDetailsLoaded) return;
    final currentState = state as UnitDetailsLoaded;

    // Optimistic UI update
    final currentRenders = currentState.customerRenders;
    List<RoomCustomerRendersEntity> updatedRenders = [];

    for (var roomRender in currentRenders) {
      if (roomRender.id == roomId) {
        List<CustomerRenderEntity> newRenders = [];
        for (var render in roomRender.renders) {
          if (render.url == imageUrl) {
            newRenders.add(CustomerRenderEntity(
              url: render.url,
              isSaved: !render.isSaved,
              roomName: render.roomName,
            ));
          } else {
            newRenders.add(render);
          }
        }
        updatedRenders.add(RoomCustomerRendersEntity(
          id: roomRender.id,
          name: roomRender.name,
          type: roomRender.type,
          typeLabel: roomRender.typeLabel,
          area: roomRender.area,
          renders: newRenders,
        ));
      } else {
        updatedRenders.add(roomRender);
      }
    }

    emit(UnitDetailsLoaded(
      unit: currentState.unit!,
      totalFinishingCost: currentState.totalFinishingCost,
      roomCosts: currentState.roomCosts,
      completedRoomIds: currentState.completedRoomIds,
      customerRenders: updatedRenders,
    ));

    // Extract order_id from image_url (e.g., .../order_21_room_148_...jpg)
    int targetOrderId = apartmentId;
    try {
      final uri = Uri.parse(imageUrl);
      final filename = uri.pathSegments.last;
      if (filename.startsWith('order_')) {
        final parts = filename.split('_');
        if (parts.length > 1) {
          targetOrderId = int.parse(parts[1]);
        }
      }
    } catch (_) {
      // Keep fallback targetOrderId
    }

    // API call
    final result = await toggleCustomerRenderFavoriteUseCase(targetOrderId, imageUrl);

    result.fold(
      (failure) {
        // Rollback on failure
        if (!isClosed) {
          emit(currentState);
        }
      },
      (_) {
        // Success, nothing more to do
      },
    );
  }
}
