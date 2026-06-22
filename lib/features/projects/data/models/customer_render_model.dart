import '../../domain/entities/customer_render_entity.dart';

class CustomerRenderModel extends CustomerRenderEntity {
  const CustomerRenderModel({
    required super.url,
    required super.isSaved,
    required super.roomName,
  });

  factory CustomerRenderModel.fromJson(Map<String, dynamic> json) {
    return CustomerRenderModel(
      url: json['url'] ?? '',
      isSaved: json['is_saved'] ?? false,
      roomName: json['room_name'] ?? '',
    );
  }
}

class RoomCustomerRendersModel extends RoomCustomerRendersEntity {
  const RoomCustomerRendersModel({
    required super.id,
    required super.name,
    required super.type,
    required super.typeLabel,
    required super.area,
    required super.renders,
  });

  factory RoomCustomerRendersModel.fromJson(Map<String, dynamic> json) {
    return RoomCustomerRendersModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      typeLabel: json['type_label'] ?? '',
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      renders: (json['renders'] as List<dynamic>?)
              ?.map((e) => CustomerRenderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
