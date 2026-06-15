import 'package:equatable/equatable.dart';

class FinishingOrderRequestEntity extends Equatable {
  final int apartmentId;
  final String type;
  final bool isDraft;
  final String style;
  final String notes;
  final double expectedTotalCost;
  final List<RoomSelectionEntity> selections;

  const FinishingOrderRequestEntity({
    required this.apartmentId,
    required this.type,
    required this.isDraft,
    required this.style,
    required this.notes,
    required this.expectedTotalCost,
    required this.selections,
  });

  @override
  List<Object?> get props => [
        apartmentId,
        type,
        isDraft,
        style,
        notes,
        expectedTotalCost,
        selections,
      ];
}

class RoomSelectionEntity extends Equatable {
  final int roomId;
  final List<int> materialIds;

  const RoomSelectionEntity({
    required this.roomId,
    required this.materialIds,
  });

  @override
  List<Object?> get props => [roomId, materialIds];
}
