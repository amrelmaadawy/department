import 'package:equatable/equatable.dart';
import 'finishing_subtype_entity.dart';

class FinishingCategoryEntity extends Equatable {
  final int categoryId;
  final String categoryName;
  final List<FinishingSubtypeEntity> subtypes;

  const FinishingCategoryEntity({
    required this.categoryId,
    required this.categoryName,
    required this.subtypes,
  });

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        subtypes,
      ];
}
