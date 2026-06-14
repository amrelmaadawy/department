import 'package:equatable/equatable.dart';

enum UnitType { apartment, villa, duplex }

enum UnitStatus { available, sold }

class ProjectUnitEntity extends Equatable {
  final String id;
  final String title;
  
  // New API Fields
  final String unitNumber;
  final int buildingNumber;
  final String locationType;
  final String locationTypeLabel;
  final int roomsCount;

  // Existing Fields
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
    this.unitNumber = '',
    this.buildingNumber = 1,
    this.locationType = '',
    this.locationTypeLabel = '',
    this.roomsCount = 0,
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
    unitNumber,
    buildingNumber,
    locationType,
    locationTypeLabel,
    roomsCount,
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
