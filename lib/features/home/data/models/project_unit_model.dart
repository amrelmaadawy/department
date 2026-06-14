import '../../domain/entities/project_unit_entity.dart';

class ProjectUnitModel extends ProjectUnitEntity {
  const ProjectUnitModel({
    required super.id,
    required super.title,
    required super.unitNumber,
    required super.buildingNumber,
    required super.locationType,
    required super.locationTypeLabel,
    required super.roomsCount,
    required super.type,
    required super.area,
    required super.bedrooms,
    required super.bathrooms,
    required super.price,
    required super.status,
    required super.imagePath,
    required super.floor,
    required super.extras,
    required super.description,
    required super.images,
  });

  factory ProjectUnitModel.fromJson(Map<String, dynamic> json) {
    // Parse list of images
    List<String> imagesList = [];
    if (json['images'] != null) {
      imagesList = List<String>.from(json['images']);
    }

    // Default image if images array is empty
    String mainImage = imagesList.isNotEmpty ? imagesList.first : '';

    return ProjectUnitModel(
      id: json['id']?.toString() ?? '',
      title: json['name'] ?? '',
      unitNumber: json['number']?.toString() ?? '',
      buildingNumber: json['building_number'] ?? 1,
      locationType: json['location_type'] ?? '',
      locationTypeLabel: json['location_type_label'] ?? '',
      roomsCount: json['rooms_count'] ?? 0,
      area: (json['area'] ?? 0).toDouble(),
      price: (json['base_price'] ?? 0).toDouble(),
      floor: json['floor_number'] ?? 0,
      status: json['status'] == 'sold' ? UnitStatus.sold : UnitStatus.available,
      imagePath: mainImage,
      images: imagesList,
      // Provide defaults for missing API fields
      type: UnitType.apartment,
      bedrooms: 0,
      bathrooms: 0,
      extras: const [],
      description: '',
    );
  }
}
