import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/project_unit_entity.dart';
import '../../domain/usecases/get_unit_details_usecase.dart';
import '../../domain/usecases/get_customer_renders_use_case.dart';
import '../../domain/usecases/toggle_customer_render_favorite_use_case.dart';
import '../../domain/entities/customer_render_entity.dart';
import '../../domain/usecases/calculate_unit_costs_use_case.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/app_cancel_token.dart';
import 'package:dartz/dartz.dart' as dartz;

part 'unit_details_state.dart';

class UnitDetailsCubit extends Cubit<UnitDetailsState> {
  final GetUnitDetailsUseCase getUnitDetailsUseCase;
  final GetCustomerRendersUseCase getCustomerRendersUseCase;
  final ToggleCustomerRenderFavoriteUseCase toggleCustomerRenderFavoriteUseCase;
  final CalculateUnitCostsUseCase calculateUnitCostsUseCase;

  final _cancelToken = AppCancelToken();

  UnitDetailsCubit({
    required this.getUnitDetailsUseCase,
    required this.getCustomerRendersUseCase,
    required this.toggleCustomerRenderFavoriteUseCase,
    required this.calculateUnitCostsUseCase,
  }) : super(UnitDetailsInitial());

  @override
  Future<void> close() {
    _cancelToken.cancel('UnitDetailsCubit disposed');
    return super.close();
  }

  Future<void> loadUnitDetails(int id, {ProjectUnitEntity? initialUnit}) async {
    emit(UnitDetailsLoading(unit: initialUnit));

    // Fetch unit details and customer renders concurrently
    final responses = await Future.wait([
      getUnitDetailsUseCase(id),
      getCustomerRendersUseCase(id),
    ]);

    final unitResult = responses[0] as dartz.Either<Failure, ProjectUnitEntity>;
    final rendersResult = responses[1] as dartz.Either<Failure, List<RoomCustomerRendersEntity>>;

    if (isClosed) return;

    unitResult.fold(
      (failure) => emit(UnitDetailsError(
        message: failure.message,
        unit: initialUnit,
      )),
      (unit) async {
        final costsResult = await calculateUnitCostsUseCase(unit);
        if (isClosed) return;

        costsResult.fold(
          (failure) => emit(UnitDetailsError(message: failure.message, unit: unit)),
          (costs) {
            List<RoomCustomerRendersEntity> customerRenders = [];
            rendersResult.fold(
              (failure) {}, // Ignore renders failure silently or handle it
              (renders) => customerRenders = renders,
            );

            // Rehydrate completed rooms from server data in case local cache is wiped
            final Set<int> syncedCompletedRooms = Set.from(costs.completedRoomIds);
            for (var render in customerRenders) {
              if (render.renders.isNotEmpty) {
                syncedCompletedRooms.add(render.id);
              }
            }

            emit(UnitDetailsLoaded(
              unit: unit, 
              totalFinishingCost: costs.totalFinishingCost,
              roomCosts: costs.roomCosts,
              completedRoomIds: syncedCompletedRooms,
              customerRenders: customerRenders,
            ));
          }
        );
      },
    );
  }

  void refreshFinishingCost() async {
    if (state.unit != null) {
      final costsResult = await calculateUnitCostsUseCase(state.unit!);
      if (isClosed) return;

      costsResult.fold(
        (failure) {}, // Ignore silent failure on refresh
        (costs) {
          if (state is UnitDetailsLoaded) {
            final currentState = state as UnitDetailsLoaded;
            
            // Rehydrate completed rooms from server data in case local cache is wiped
            final Set<int> syncedCompletedRooms = Set.from(costs.completedRoomIds);
            for (var render in currentState.customerRenders) {
              if (render.renders.isNotEmpty) {
                syncedCompletedRooms.add(render.id);
              }
            }
            
            emit(UnitDetailsLoaded(
              unit: currentState.unit!, 
              totalFinishingCost: costs.totalFinishingCost,
              roomCosts: costs.roomCosts,
              completedRoomIds: syncedCompletedRooms,
              customerRenders: currentState.customerRenders,
            ));
          }
        }
      );
    }
  }

  Future<void> refreshCustomerRenders() async {
    if (state.unit == null) return;
    
    final id = int.tryParse(state.unit!.id) ?? 0;
    final result = await getCustomerRendersUseCase(id);
    if (isClosed) return;

    result.fold(
      (failure) {}, // Silently ignore failures on background refresh
      (renders) {
        if (state is UnitDetailsLoaded) {
          final currentState = state as UnitDetailsLoaded;
          
          // Rehydrate completed rooms from server data
          final Set<int> syncedCompletedRooms = Set.from(currentState.completedRoomIds);
          for (var render in renders) {
            if (render.renders.isNotEmpty) {
              syncedCompletedRooms.add(render.id);
            }
          }
          
          emit(UnitDetailsLoaded(
            unit: currentState.unit!,
            totalFinishingCost: currentState.totalFinishingCost,
            roomCosts: currentState.roomCosts,
            completedRoomIds: syncedCompletedRooms,
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
