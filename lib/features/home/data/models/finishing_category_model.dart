import '../../domain/entities/finishing_category_entity.dart';
import 'finishing_subtype_model.dart';

class FinishingCategoryModel extends FinishingCategoryEntity {
  const FinishingCategoryModel({
    required super.categoryId,
    required super.categoryName,
    required super.subtypes,
  });

  factory FinishingCategoryModel.fromJson(Map<String, dynamic> json) {
    List<FinishingSubtypeModel> subtypesList = [];
    if (json['subtypes'] != null) {
      subtypesList = (json['subtypes'] as List)
          .map((s) => FinishingSubtypeModel.fromJson(s))
          .toList();
    }

    return FinishingCategoryModel(
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      subtypes: subtypesList,
    );
  }
}
