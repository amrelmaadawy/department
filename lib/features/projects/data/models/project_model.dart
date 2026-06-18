import '../../../../features/home/domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    super.description,
    super.city,
    required super.location,
    required super.status,
    required super.images,
    required super.apartmentsCount,
    required super.buildingArea,
    super.features,
    super.isFeatured,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      location: (json['city'] != null && json['address'] != null) 
          ? '${json['city']} - ${json['address']}' 
          : json['address'] ?? json['city'] ?? json['location'] ?? '',
      status: json['status'] ?? 'available',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      apartmentsCount: json['apartments_count'] is int ? json['apartments_count'] : int.tryParse(json['apartments_count'].toString()) ?? 0,
      buildingArea: json['building_area'] is num ? (json['building_area'] as num).toDouble() : double.tryParse(json['building_area']?.toString() ?? '') ?? 0.0,
      features: json['features'] != null ? List<String>.from(json['features']) : [],
      isFeatured: json['is_featured'] ?? false,
    );
  }
}
