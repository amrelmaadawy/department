import '../../domain/entities/unit_room_entity.dart';

class UnitRoomModel extends UnitRoomEntity {
  const UnitRoomModel({
    required super.id,
    required super.name,
    required super.type,
    required super.typeLabel,
    required super.area,
    super.length,
    super.width,
  });

  factory UnitRoomModel.fromJson(Map<String, dynamic> json) {
    return UnitRoomModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      typeLabel: json['type_label'] ?? '',
      area: (json['area'] ?? 0).toDouble(),
      length: json['length'] != null ? (json['length'] as num).toDouble() : null,
      width: json['width'] != null ? (json['width'] as num).toDouble() : null,
    );
  }
}
