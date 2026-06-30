import '../../domain/entities/finishing_material_entity.dart';

class FinishingMaterialModel extends FinishingMaterialEntity {
  const FinishingMaterialModel({
    required super.id,
    required super.name,
    required super.description,
    required super.unit,
    required super.finalPrice,
    super.imageUrl,
    super.companyId,
    super.companyName,
  });

  factory FinishingMaterialModel.fromJson(Map<String, dynamic> json) {
    return FinishingMaterialModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      finalPrice: double.tryParse(json['final_price']?.toString() ?? '') ?? 0.0,
      imageUrl: json['image_url']?.toString(),
      companyId: int.tryParse(json['company_id']?.toString() ?? ''),
      companyName: json['company_name']?.toString(),
    );
  }
}
