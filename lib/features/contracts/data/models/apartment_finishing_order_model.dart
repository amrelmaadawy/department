import '../../domain/entities/apartment_finishing_order_entity.dart';
import 'cost_breakdown_model.dart';

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
    super.statusLabel,
    super.orderType,
    super.orderTypeLabel,
    super.createdAt,
    super.costBreakdown,
  });

  factory ApartmentFinishingOrderModel.fromJson(Map<String, dynamic> json) {
    return ApartmentFinishingOrderModel(
      id: json['id'] as int? ?? 0,
      totalCost: json['total_cost']?.toString() ?? '0.00',
      aiRenders: (json['ai_renders'] as List<dynamic>?)
              ?.map((e) => ApartmentFinishingOrderAiRenderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isDraft: json['is_draft'] as bool?,
      status: json['status'] as String? ?? '',
      statusLabel: json['status_label'] as String?,
      orderType: json['order_type'] as String?,
      orderTypeLabel: json['order_type_label'] as String?,
      createdAt: json['created_at'] as String?,
      costBreakdown: json['cost_breakdown'] != null
          ? CostBreakdownModel.fromJson(json['cost_breakdown'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_cost': totalCost,
      'ai_renders': aiRenders.map((e) => (e as ApartmentFinishingOrderAiRenderModel).toJson()).toList(),
      'is_draft': isDraft,
      'status': status,
      'status_label': statusLabel,
      'order_type': orderType,
      'order_type_label': orderTypeLabel,
      'created_at': createdAt,
      'cost_breakdown': costBreakdown != null ? (costBreakdown as CostBreakdownModel).toJson() : null,
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
