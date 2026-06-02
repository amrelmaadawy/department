import 'package:equatable/equatable.dart';

import 'project_service_entity.dart';

class ProjectEntity extends Equatable {
  final String id;
  final String name;
  final String location;
  final double startingPrice;
  final String imagePath;
  final String description;
  final List<String> amenities;
  final String totalArea;
  final String unitTypes;
  final String deliveryDate;
  final String finishingType;
  final List<ProjectServiceEntity> services;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.startingPrice,
    required this.imagePath,
    this.description = '',
    this.amenities = const [],
    this.totalArea = '',
    this.unitTypes = '',
    this.deliveryDate = '',
    this.finishingType = '',
    this.services = const [],
  });

  @override
  List<Object> get props => [
    id,
    name,
    location,
    startingPrice,
    imagePath,
    description,
    amenities,
    totalArea,
    unitTypes,
    deliveryDate,
    finishingType,
    services,
  ];
}
