import 'package:equatable/equatable.dart';

class CostBreakdownItemEntity extends Equatable {
  final int materialId;
  final String materialName;
  final String? companyName;
  final String unit;
  final double quantity;
  final double unitPrice;
  final double total;
  final String? imageUrl;

  const CostBreakdownItemEntity({
    required this.materialId,
    required this.materialName,
    this.companyName,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        materialId,
        materialName,
        companyName,
        unit,
        quantity,
        unitPrice,
        total,
        imageUrl,
      ];
}

class CostBreakdownRoomEntity extends Equatable {
  final int roomId;
  final String roomName;
  final String roomType;
  final List<CostBreakdownItemEntity> items;
  final double roomTotal;

  const CostBreakdownRoomEntity({
    required this.roomId,
    required this.roomName,
    required this.roomType,
    required this.items,
    required this.roomTotal,
  });

  @override
  List<Object?> get props => [roomId, roomName, roomType, items, roomTotal];
}

class CostBreakdownEntity extends Equatable {
  final List<CostBreakdownRoomEntity> rooms;
  final double grandTotal;

  const CostBreakdownEntity({
    required this.rooms,
    required this.grandTotal,
  });

  @override
  List<Object?> get props => [rooms, grandTotal];
}
