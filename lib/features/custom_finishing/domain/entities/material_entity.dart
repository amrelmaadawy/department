import 'package:equatable/equatable.dart';

import 'material_category.dart';

class MaterialEntity extends Equatable {
  final String id;
  final MaterialCategory category;
  final String name;
  final String description;
  final String imageUrl;
  final double pricePerSqm;
  final String tag;

  const MaterialEntity({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.pricePerSqm,
    required this.tag,
  });

  @override
  List<Object?> get props => [
    id,
    category,
    name,
    description,
    imageUrl,
    pricePerSqm,
    tag,
  ];
}
