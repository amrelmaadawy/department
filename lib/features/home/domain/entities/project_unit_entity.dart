import 'package:equatable/equatable.dart';

enum UnitType { apartment, villa, duplex }

enum UnitStatus { available, sold }

class ProjectUnitEntity extends Equatable {
  final String id;
  final String title;
  final UnitType type;
  final double area;
  final int bedrooms;
  final int bathrooms;
  final double price;
  final UnitStatus status;
  final String imagePath;
  final int floor;
  final List<String> extras;
  final String description;
  final List<String> images;

  const ProjectUnitEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.price,
    required this.status,
    required this.imagePath,
    required this.floor,
    required this.extras,
    required this.description,
    required this.images,
  });

  @override
  List<Object> get props => [
    id,
    title,
    type,
    area,
    bedrooms,
    bathrooms,
    price,
    status,
    imagePath,
    floor,
    extras,
    description,
    images,
  ];
}
