import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/home/domain/entities/unit_room_entity.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/features/packages/domain/entities/package_item_entity.dart';
import 'package:apartment/features/projects/data/datasources/local/room_design_cache_service.dart';

class PackageHelper {
  static void applyPackageToRooms(ProjectUnitEntity unit, FinishingPackageEntity package) {
    final cacheService = sl<RoomDesignCacheService>();
    for (final room in unit.rooms) {
      final items = _findDynamicMatchingItems(room, package);

      if (items.isNotEmpty) {
        final materialIds = items.map((e) => e.material.id).toList();
        final cost = items.fold<double>(0.0, (sum, item) => sum + item.material.finalUnitPrice);
        cacheService.saveRoomDesignProgress(
          roomId: room.id,
          selectedMaterialIds: materialIds,
          selectedMaterialsCost: cost,
          selectedStyle: null,
          notes: 'تم الاختيار من باقة ${package.name}',
          isCompleted: true,
        );
      }
    }
  }

  /// Dynamically matches a room to package items supporting exact, token, and semantic cluster matches.
  static List<PackageItemEntity> _findDynamicMatchingItems(UnitRoomEntity room, FinishingPackageEntity package) {
    // 1. Tier 1: Exact or direct normalized match
    var items = package.itemsForRoom(room.type);
    if (items.isNotEmpty) return items;

    final roomClean = _cleanToken(room.type);
    items = package.items.where((e) => _cleanToken(e.roomType) == roomClean).toList();
    if (items.isNotEmpty) return items;

    // 2. Tier 2: Dynamic Token & Semantic Cluster Scoring against available package room types
    final availablePackageTypes = package.roomTypes;
    if (availablePackageTypes.isEmpty) return [];

    String? bestMatchedPackageType;
    int highestScore = 0;

    for (final pkgType in availablePackageTypes) {
      final score = _calculateMatchScore(room, pkgType);
      if (score > highestScore && score >= 50) {
        highestScore = score;
        bestMatchedPackageType = pkgType;
      }
    }

    if (bestMatchedPackageType != null) {
      return package.itemsForRoom(bestMatchedPackageType);
    }

    return [];
  }

  static String _cleanToken(String text) => text.trim().toLowerCase().replaceAll(RegExp(r'[\s\-_]+'), '');

  static int _calculateMatchScore(UnitRoomEntity room, String packageRoomType) {
    final roomStr = '${room.type} ${room.name}'.toLowerCase();
    final pkgStr = packageRoomType.toLowerCase();

    // Direct substring check
    if (roomStr.contains(pkgStr) || pkgStr.contains(_cleanToken(room.type))) {
      return 90;
    }

    // Token overlap scoring
    final roomTokens = _extractTokens(roomStr);
    final pkgTokens = _extractTokens(pkgStr);
    for (final rt in roomTokens) {
      if (pkgTokens.contains(rt)) return 80;
    }

    // Semantic cluster checking (Dashboard flexibility across languages & synonyms)
    for (final cluster in _semanticClusters) {
      final bool roomInCluster = cluster.any((syn) => roomStr.contains(syn));
      final bool pkgInCluster = cluster.any((syn) => pkgStr.contains(syn));
      if (roomInCluster && pkgInCluster) return 70;
    }

    return 0;
  }

  static List<String> _extractTokens(String text) {
    return text
        .split(RegExp(r'[\s\-_/]+'))
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.length > 2 && !['room', 'غرفة', 'area'].contains(e))
        .toList();
  }

  static const List<List<String>> _semanticClusters = [
    ['salon', 'living', 'reception', 'lounge', 'sitting', 'صالون', 'معيش', 'ريسبشن', 'جلوس', 'استقبال'],
    ['bed', 'master', 'sleep', 'guestbed', 'نوم', 'ماستر'],
    ['bath', 'toilet', 'wc', 'restroom', 'حمام', 'تواليت'],
    ['kitchen', 'cook', 'pantry', 'مطبخ'],
    ['dining', 'eat', 'سفرة', 'طعام'],
    ['office', 'study', 'work', 'مكتب', 'دراسة'],
    ['balcony', 'terrace', 'garden', 'outdoor', 'تراس', 'بلكون', 'حديقة'],
    ['dressing', 'closet', 'wardrobe', 'ملابس', 'دريسنج'],
  ];
}
