import 'package:equatable/equatable.dart';

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

  const ApartmentFinishingOrderEntity({
    required this.id,
    required this.totalCost,
    required this.aiRenders,
    this.isDraft,
    required this.status,
  });

  @override
  List<Object?> get props => [id, totalCost, aiRenders, isDraft, status];
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
