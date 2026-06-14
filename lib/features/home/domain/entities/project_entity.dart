import 'package:equatable/equatable.dart';

import 'project_service_entity.dart';
import 'project_unit_entity.dart';

class ProjectEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String location;
  final String status;
  final List<String> images;
  final int apartmentsCount;

  // Legacy/Optional UI fields
  final double startingPrice;
  final List<String> amenities;
  final String totalArea;
  final String unitTypes;
  final String deliveryDate;
  final String finishingType;
  final List<ProjectServiceEntity> services;
  final List<ProjectUnitEntity> units;

  const ProjectEntity({
    required this.id,
    required this.name,
    this.description = '',
    required this.location,
    this.status = 'available',
    this.images = const [],
    this.apartmentsCount = 0,
    this.startingPrice = 0.0,
    this.amenities = const [],
    this.totalArea = '',
    this.unitTypes = '',
    this.deliveryDate = '',
    this.finishingType = '',
    this.services = const [],
    this.units = const [],
  });

  // Getter for legacy imagePath support
  String get imagePath => images.isNotEmpty ? images.first : '';

  @override
  List<Object> get props => [
    id,
    name,
    description,
    location,
    status,
    images,
    apartmentsCount,
    startingPrice,
    amenities,
    totalArea,
    unitTypes,
    deliveryDate,
    finishingType,
    services,
    units,
  ];
}
