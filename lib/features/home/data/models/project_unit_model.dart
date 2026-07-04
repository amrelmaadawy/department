import '../../domain/entities/project_unit_entity.dart';
import 'unit_room_model.dart';

class ProjectUnitModel extends ProjectUnitEntity {
  const ProjectUnitModel({
    required super.id,
    required super.title,
    super.projectName,
    super.isCurrentUserUnit,
    required super.unitNumber,
    required super.buildingNumber,
    required super.locationType,
    required super.locationTypeLabel,
    required super.roomsCount,
    required super.statusLabel,
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
    super.rooms,
  });

  factory ProjectUnitModel.fromJson(Map<String, dynamic> json) {
    // Parse list of images
    List<String> imagesList = [];
    if (json['images'] != null) {
      imagesList = List<String>.from(json['images']);
    }

    // Default image if images array is empty
    String mainImage = imagesList.isNotEmpty ? imagesList.first : '';

    // Parse rooms
    List<UnitRoomModel> roomsList = [];
    if (json['rooms'] != null) {
      roomsList = (json['rooms'] as List)
          .map((roomJson) => UnitRoomModel.fromJson(roomJson))
          .toList();
    }

    int parsedRoomsCount = int.tryParse(json['rooms_count']?.toString() ?? '') ??
        int.tryParse(json['rooms_number']?.toString() ?? '') ??
        int.tryParse(json['bedrooms']?.toString() ?? '') ??
        0;

    if (parsedRoomsCount == 0 && roomsList.isNotEmpty) {
      parsedRoomsCount = roomsList.length;
    }

    final double parsedArea = (json['area'] ?? 0).toDouble();
    if (parsedRoomsCount == 0 && parsedArea > 0) {
      parsedRoomsCount = (parsedArea / 35).ceil().clamp(1, 10);
    }

    String parsedProjectName = json['project_name']?.toString().trim() ?? '';
    if (parsedProjectName.isEmpty && json['project'] != null && json['project'] is Map) {
      parsedProjectName = json['project']['name']?.toString().trim() ?? '';
    }
    if (parsedProjectName.isEmpty && json['apartment'] != null && json['apartment'] is Map) {
      parsedProjectName = json['apartment']['project_name']?.toString().trim() ?? '';
      if (parsedProjectName.isEmpty && json['apartment']['project'] != null && json['apartment']['project'] is Map) {
        parsedProjectName = json['apartment']['project']['name']?.toString().trim() ?? '';
      }
    }

    return ProjectUnitModel(
      id: json['id']?.toString() ?? '',
      title: json['name'] ?? '',
      projectName: parsedProjectName,
      isCurrentUserUnit: json['is_current_user_unit'] == true ||
          json['is_my_unit'] == true ||
          json['owned_by_current_user'] == true ||
          json['status']?.toString().toLowerCase().trim() == 'owned',
      unitNumber: json['number']?.toString() ?? '',
      buildingNumber: json['building_number'] ?? 1,
      locationType: json['location_type'] ?? '',
      locationTypeLabel: json['location_type_label'] ?? '',
      roomsCount: parsedRoomsCount > 0 ? parsedRoomsCount : 1,
      area: parsedArea,
      price: (json['base_price'] ?? 0).toDouble(),
      floor: json['floor_number'] ?? 0,
      status: _parseUnitStatus(json['status']),
      statusLabel: json['status_label']?.toString().trim().isNotEmpty == true
          ? json['status_label'].toString().trim()
          : _defaultStatusLabel(json['status']),
      imagePath: mainImage,
      images: imagesList,
      rooms: roomsList,
      // Provide defaults for missing API fields
      type: UnitType.apartment,
      bedrooms: 0,
      bathrooms: 0,
      extras: const [],
      description: '',
    );
  }

  static UnitStatus _parseUnitStatus(dynamic status) {
    final s = status?.toString().toLowerCase().trim();
    if (s == 'sold') return UnitStatus.sold;
    if (s == 'reserved') return UnitStatus.reserved;
    if (s == 'owned') return UnitStatus.owned;
    return UnitStatus.available;
  }

  static String _defaultStatusLabel(dynamic status) {
    final s = status?.toString().toLowerCase().trim();
    if (s == 'sold') return 'مباعة';
    if (s == 'reserved') return 'محجوزة';
    if (s == 'owned') return 'مملوكة';
    return 'متاحة';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'project_name': projectName,
      'is_current_user_unit': isCurrentUserUnit,
      'number': unitNumber,
      'building_number': buildingNumber,
      'location_type': locationType,
      'location_type_label': locationTypeLabel,
      'rooms_count': roomsCount,
      'area': area,
      'base_price': price,
      'floor_number': floor,
      'status': status == UnitStatus.sold
          ? 'sold'
          : (status == UnitStatus.reserved 
              ? 'reserved' 
              : (status == UnitStatus.owned ? 'owned' : 'available')),
      'status_label': statusLabel,
      'images': images,
      'rooms': rooms.map((e) => (e as UnitRoomModel).toJson()).toList(),
    };
  }
}
