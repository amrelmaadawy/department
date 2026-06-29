import 'package:equatable/equatable.dart';
import 'cost_breakdown_entity.dart';

class ApartmentFinishingOrderAiRenderEntity extends Equatable {
  final int roomId;
  final String roomName;
  final String url;

  const ApartmentFinishingOrderAiRenderEntity({
    required this.roomId,
    required this.roomName,
    required this.url,
  });

  @override
  List<Object?> get props => [roomId, roomName, url];
}

class ApartmentFinishingOrderEntity extends Equatable {
  final int id;
  final String totalCost;
  final List<ApartmentFinishingOrderAiRenderEntity> aiRenders;
  final bool? isDraft;
  final String status;
  final String? statusLabel;
  final String? orderType;
  final String? orderTypeLabel;
  final String? createdAt;
  final CostBreakdownEntity? costBreakdown;

  const ApartmentFinishingOrderEntity({
    required this.id,
    required this.totalCost,
    required this.aiRenders,
    this.isDraft,
    required this.status,
    this.statusLabel,
    this.orderType,
    this.orderTypeLabel,
    this.createdAt,
    this.costBreakdown,
  });

  @override
  List<Object?> get props => [
        id,
        totalCost,
        aiRenders,
        isDraft,
        status,
        statusLabel,
        orderType,
        orderTypeLabel,
        createdAt,
        costBreakdown,
      ];
}

class ApartmentFinishingOrderRoomEntity extends Equatable {
  final String roomName;
  final List<ApartmentFinishingOrderEntity> orders;

  const ApartmentFinishingOrderRoomEntity({
    required this.roomName,
    required this.orders,
  });

  @override
  List<Object?> get props => [roomName, orders];
}
