import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../home/domain/entities/project_unit_entity.dart';
import '../../data/datasources/local/room_design_cache_service.dart';

class UnitCostsResult {
  final double totalFinishingCost;
  final Map<int, double> roomCosts;
  final Set<int> completedRoomIds;

  UnitCostsResult({
    required this.totalFinishingCost,
    required this.roomCosts,
    required this.completedRoomIds,
  });
}

class CalculateUnitCostsUseCase {
  final RoomDesignCacheService cacheService;

  CalculateUnitCostsUseCase(this.cacheService);

  Future<Either<Failure, UnitCostsResult>> call(ProjectUnitEntity unit) async {
    try {
      Map<int, double> costs = {};
      Set<int> completedIds = {};
      double total = 0.0;

      for (final room in unit.rooms) {
        final cachedData = cacheService.getRoomDesignProgress(room.id);
        if (cachedData != null) {
          final selectedMaterialsCost = (cachedData['selectedMaterialsCost'] ?? 0.0).toDouble();
          final roomCost = selectedMaterialsCost * room.area;
          costs[room.id] = roomCost;
          total += roomCost;

          if (cachedData['isCompleted'] == true) {
            completedIds.add(room.id);
          }
        }
      }

      return Right(UnitCostsResult(
        totalFinishingCost: total,
        roomCosts: costs,
        completedRoomIds: completedIds,
      ));
    } catch (e) {
      return const Left(CacheFailure('Failed to calculate unit costs'));
    }
  }
}
