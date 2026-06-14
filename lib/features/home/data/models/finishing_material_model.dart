import '../../domain/entities/finishing_material_entity.dart';

class FinishingMaterialModel extends FinishingMaterialEntity {
  const FinishingMaterialModel({
    required super.id,
    required super.name,
    required super.description,
    required super.unit,
    required super.finalPrice,
    super.imageUrl,
  });

  factory FinishingMaterialModel.fromJson(Map<String, dynamic> json) {
    return FinishingMaterialModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      unit: json['unit'] ?? '',
      finalPrice: json['final_price'] != null ? (json['final_price'] as num).toDouble() : 0.0,
      imageUrl: json['image_url'],
    );
  }
}
