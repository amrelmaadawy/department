import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/features/packages/domain/entities/package_item_entity.dart';
import 'package:apartment/features/packages/domain/entities/package_material_entity.dart';

class PackageMaterialModel extends PackageMaterialEntity {
  const PackageMaterialModel({
    required super.id,
    required super.name,
    required super.unit,
    required super.priceMaterial,
    required super.priceLabor,
    required super.finalUnitPrice,
    required super.images,
  });

  factory PackageMaterialModel.fromJson(Map<String, dynamic> json) {
    return PackageMaterialModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      priceMaterial: double.tryParse(json['price_material']?.toString() ?? '') ?? 0.0,
      priceLabor: double.tryParse(json['price_labor']?.toString() ?? '') ?? 0.0,
      finalUnitPrice: double.tryParse(json['final_unit_price']?.toString() ?? '') ?? 0.0,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class PackageItemModel extends PackageItemEntity {
  const PackageItemModel({
    required super.roomType,
    required super.material,
  });

  factory PackageItemModel.fromJson(Map<String, dynamic> json) {
    final matJson = json['material'];
    return PackageItemModel(
      roomType: json['room_type']?.toString() ?? '',
      material: matJson is Map<String, dynamic>
          ? PackageMaterialModel.fromJson(matJson)
          : const PackageMaterialModel(
              id: 0,
              name: '',
              unit: '',
              priceMaterial: 0.0,
              priceLabor: 0.0,
              finalUnitPrice: 0.0,
              images: [],
            ),
    );
  }
}

class PackageModel extends FinishingPackageEntity {
  const PackageModel({
    required super.id,
    required super.name,
    super.badges = const [],
    required super.description,
    required super.calculatedPrice,
    required super.items,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final rawBadges = json['badges'] as List<dynamic>?;
    final singleBadge = json['badge'] as String?;

    final List<String> parsedBadges = rawBadges != null
        ? rawBadges
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList()
        : (singleBadge != null && singleBadge.trim().isNotEmpty
            ? [singleBadge.trim()]
            : []);

    return PackageModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      badges: parsedBadges,
      description: json['description']?.toString() ?? '',
      calculatedPrice: double.tryParse(json['calculated_price']?.toString() ?? '') ?? 0.0,
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map((e) => PackageItemModel.fromJson(e))
          .toList(),
    );
  }
}

