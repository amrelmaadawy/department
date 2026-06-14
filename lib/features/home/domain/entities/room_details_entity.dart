import 'package:equatable/equatable.dart';
import 'unit_room_entity.dart';
import 'finishing_category_entity.dart';

class RoomDetailsEntity extends Equatable {
  final UnitRoomEntity room;
  final List<FinishingCategoryEntity> finishingOptions;

  const RoomDetailsEntity({
    required this.room,
    required this.finishingOptions,
  });

  @override
  List<Object?> get props => [
        room,
        finishingOptions,
      ];
}
