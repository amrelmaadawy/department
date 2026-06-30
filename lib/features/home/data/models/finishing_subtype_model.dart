import '../../domain/entities/finishing_subtype_entity.dart';
import 'finishing_material_model.dart';

class FinishingSubtypeModel extends FinishingSubtypeEntity {
  const FinishingSubtypeModel({
    required super.subtypeId,
    required super.subtypeName,
    required super.materials,
  });

  factory FinishingSubtypeModel.fromJson(Map<String, dynamic> json) {
    List<FinishingMaterialModel> materialsList = [];
    if (json['materials'] != null && json['materials'] is List) {
      materialsList = (json['materials'] as List)
          .whereType<Map<String, dynamic>>()
          .map((m) => FinishingMaterialModel.fromJson(m))
          .toList();
    }

    return FinishingSubtypeModel(
      subtypeId: int.tryParse(json['subtype_id']?.toString() ?? '') ?? 0,
      subtypeName: json['subtype_name']?.toString() ?? '',
      materials: materialsList,
    );
  }
}
