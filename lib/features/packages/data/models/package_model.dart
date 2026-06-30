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
      id: json['id'] as int,
      name: json['name'] as String,
      unit: json['unit'] as String,
      priceMaterial: double.tryParse(json['price_material'].toString()) ?? 0.0,
      priceLabor: (json['price_labor'] as num).toDouble(),
      finalUnitPrice: (json['final_unit_price'] as num).toDouble(),
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
    return PackageItemModel(
      roomType: json['room_type'] as String,
      material: PackageMaterialModel.fromJson(
        json['material'] as Map<String, dynamic>,
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
      id: json['id'] as int,
      name: json['name'] as String,
      badges: parsedBadges,
      description: json['description'] as String? ?? '',
      calculatedPrice: (json['calculated_price'] as num).toDouble(),
      items: rawItems
          .map((e) => PackageItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

