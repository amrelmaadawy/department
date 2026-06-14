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
    if (json['materials'] != null) {
      materialsList = (json['materials'] as List)
          .map((m) => FinishingMaterialModel.fromJson(m))
          .toList();
    }

    return FinishingSubtypeModel(
      subtypeId: json['subtype_id'] ?? 0,
      subtypeName: json['subtype_name'] ?? '',
      materials: materialsList,
    );
  }
}
