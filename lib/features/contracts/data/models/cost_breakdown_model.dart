import '../../domain/entities/cost_breakdown_entity.dart';

class CostBreakdownItemModel extends CostBreakdownItemEntity {
  const CostBreakdownItemModel({
    required super.materialId,
    required super.materialName,
    super.companyName,
    required super.unit,
    required super.quantity,
    required super.unitPrice,
    required super.total,
    super.imageUrl,
  });

  factory CostBreakdownItemModel.fromJson(Map<String, dynamic> json) {
    return CostBreakdownItemModel(
      materialId: json['material_id'] as int? ?? 0,
      materialName: json['material_name'] as String? ?? '',
      companyName: json['company_name'] as String?,
      unit: json['unit'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'material_id': materialId,
      'material_name': materialName,
      'company_name': companyName,
      'unit': unit,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total': total,
      'image_url': imageUrl,
    };
  }
}

class CostBreakdownRoomModel extends CostBreakdownRoomEntity {
  const CostBreakdownRoomModel({
    required super.roomId,
    required super.roomName,
    required super.roomType,
    required super.items,
    required super.roomTotal,
  });

  factory CostBreakdownRoomModel.fromJson(Map<String, dynamic> json) {
    return CostBreakdownRoomModel(
      roomId: json['room_id'] as int? ?? 0,
      roomName: json['room_name'] as String? ?? '',
      roomType: json['room_type'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CostBreakdownItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      roomTotal: (json['room_total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'room_name': roomName,
      'room_type': roomType,
      'items': items.map((e) => (e as CostBreakdownItemModel).toJson()).toList(),
      'room_total': roomTotal,
    };
  }
}

class CostBreakdownModel extends CostBreakdownEntity {
  const CostBreakdownModel({
    required super.rooms,
    required super.grandTotal,
  });

  factory CostBreakdownModel.fromJson(Map<String, dynamic> json) {
    return CostBreakdownModel(
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((e) => CostBreakdownRoomModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rooms': rooms.map((e) => (e as CostBreakdownRoomModel).toJson()).toList(),
      'grand_total': grandTotal,
    };
  }
}
