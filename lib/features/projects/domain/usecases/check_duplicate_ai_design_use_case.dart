import '../../data/datasources/local/room_design_cache_service.dart';

class CheckDuplicateAiDesignUseCase {
  final RoomDesignCacheService cacheService;

  CheckDuplicateAiDesignUseCase(this.cacheService);

  bool call({
    required int roomId,
    required List<int> currentMaterialIds,
  }) {
    if (currentMaterialIds.isEmpty) return false;

    final submittedIds = cacheService.getSubmittedAiDesignMaterials(roomId);
    if (submittedIds == null || submittedIds.isEmpty) return false;

    if (submittedIds.length != currentMaterialIds.length) return false;

    final submittedSet = submittedIds.toSet();
    final currentSet = currentMaterialIds.toSet();

    return submittedSet.length == currentSet.length &&
        submittedSet.containsAll(currentSet);
  }
}
