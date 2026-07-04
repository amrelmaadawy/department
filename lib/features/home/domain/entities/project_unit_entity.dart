import 'package:equatable/equatable.dart';
import 'unit_room_entity.dart';

enum UnitType { apartment, villa, duplex }

enum UnitStatus { available, sold, reserved, owned }

extension UnitStatusExtension on UnitStatus {
  bool get isAvailable => this == UnitStatus.available;
  bool get isSold => this == UnitStatus.sold;
  bool get isReserved => this == UnitStatus.reserved;
  bool get isOwned => this == UnitStatus.owned;
  bool get isUnavailable => this == UnitStatus.sold || this == UnitStatus.reserved;
}

class ProjectUnitEntity extends Equatable {
  final String id;
  final String title;
  final String projectName;
  final bool isCurrentUserUnit;
  
  // New API Fields
  final String unitNumber;
  final int buildingNumber;
  final String locationType;
  final String locationTypeLabel;
  final int roomsCount;
  final String statusLabel;

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
  final List<UnitRoomEntity> rooms;

  const ProjectUnitEntity({
    required this.id,
    required this.title,
    this.projectName = '',
    this.isCurrentUserUnit = false,
    this.unitNumber = '',
    this.buildingNumber = 1,
    this.locationType = '',
    this.locationTypeLabel = '',
    this.roomsCount = 0,
    this.statusLabel = '',
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
    this.rooms = const [],
  });

  ProjectUnitEntity copyWith({
    String? id,
    String? title,
    String? projectName,
    bool? isCurrentUserUnit,
    String? unitNumber,
    int? buildingNumber,
    String? locationType,
    String? locationTypeLabel,
    int? roomsCount,
    String? statusLabel,
    UnitType? type,
    double? area,
    int? bedrooms,
    int? bathrooms,
    double? price,
    UnitStatus? status,
    String? imagePath,
    int? floor,
    List<String>? extras,
    String? description,
    List<String>? images,
    List<UnitRoomEntity>? rooms,
  }) {
    return ProjectUnitEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      projectName: projectName ?? this.projectName,
      isCurrentUserUnit: isCurrentUserUnit ?? this.isCurrentUserUnit,
      unitNumber: unitNumber ?? this.unitNumber,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      locationType: locationType ?? this.locationType,
      locationTypeLabel: locationTypeLabel ?? this.locationTypeLabel,
      roomsCount: roomsCount ?? this.roomsCount,
      statusLabel: statusLabel ?? this.statusLabel,
      type: type ?? this.type,
      area: area ?? this.area,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      price: price ?? this.price,
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      floor: floor ?? this.floor,
      extras: extras ?? this.extras,
      description: description ?? this.description,
      images: images ?? this.images,
      rooms: rooms ?? this.rooms,
    );
  }

  @override
  List<Object> get props => [
    id,
    title,
    projectName,
    isCurrentUserUnit,
    unitNumber,
    buildingNumber,
    locationType,
    locationTypeLabel,
    roomsCount,
    statusLabel,
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
    rooms,
  ];
}
