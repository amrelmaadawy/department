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
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      typeLabel: json['type_label']?.toString() ?? '',
      area: double.tryParse(json['area']?.toString() ?? '') ?? 0.0,
      length: double.tryParse(json['length']?.toString() ?? ''),
      width: double.tryParse(json['width']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'type_label': typeLabel,
      'area': area,
      'length': length,
      'width': width,
    };
  }
}
