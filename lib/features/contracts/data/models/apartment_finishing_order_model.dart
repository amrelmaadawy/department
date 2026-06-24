import '../../domain/entities/apartment_finishing_order_entity.dart';

class ApartmentFinishingOrderAiRenderModel extends ApartmentFinishingOrderAiRenderEntity {
  const ApartmentFinishingOrderAiRenderModel({
    required super.roomId,
    required super.roomName,
    required super.url,
  });

  factory ApartmentFinishingOrderAiRenderModel.fromJson(Map<String, dynamic> json) {
    return ApartmentFinishingOrderAiRenderModel(
      roomId: json['room_id'] as int? ?? 0,
      roomName: json['room_name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'room_name': roomName,
      'url': url,
    };
  }
}

class ApartmentFinishingOrderModel extends ApartmentFinishingOrderEntity {
  const ApartmentFinishingOrderModel({
    required super.id,
    required super.totalCost,
    required super.aiRenders,
    super.isDraft,
    required super.status,
  });

  factory ApartmentFinishingOrderModel.fromJson(Map<String, dynamic> json) {
    return ApartmentFinishingOrderModel(
      id: json['id'] as int? ?? 0,
      totalCost: json['total_cost'] as String? ?? '0.00',
      aiRenders: (json['ai_renders'] as List<dynamic>?)
              ?.map((e) => ApartmentFinishingOrderAiRenderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isDraft: json['is_draft'] as bool?,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_cost': totalCost,
      'ai_renders': aiRenders.map((e) => (e as ApartmentFinishingOrderAiRenderModel).toJson()).toList(),
      'is_draft': isDraft,
      'status': status,
    };
  }
}

class ApartmentFinishingOrderRoomModel extends ApartmentFinishingOrderRoomEntity {
  const ApartmentFinishingOrderRoomModel({
    required super.roomName,
    required super.orders,
  });

  factory ApartmentFinishingOrderRoomModel.fromJson(Map<String, dynamic> json) {
    return ApartmentFinishingOrderRoomModel(
      roomName: json['room_name'] as String? ?? '',
      orders: (json['orders'] as List<dynamic>?)
              ?.map((e) => ApartmentFinishingOrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_name': roomName,
      'orders': orders.map((e) => (e as ApartmentFinishingOrderModel).toJson()).toList(),
    };
  }
}
