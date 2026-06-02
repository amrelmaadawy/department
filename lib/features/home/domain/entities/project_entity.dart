import 'package:equatable/equatable.dart';

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
      ];
}
