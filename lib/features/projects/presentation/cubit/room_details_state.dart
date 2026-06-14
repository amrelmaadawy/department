import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/room_details_entity.dart';
import '../../../home/domain/entities/unit_room_entity.dart';

abstract class RoomDetailsState extends Equatable {
  const RoomDetailsState();

  @override
  List<Object?> get props => [];
}

class RoomDetailsInitial extends RoomDetailsState {}

class RoomDetailsLoading extends RoomDetailsState {
  final UnitRoomEntity room;
  const RoomDetailsLoading({required this.room});

  @override
  List<Object?> get props => [room];
}

class RoomDetailsLoaded extends RoomDetailsState {
  final RoomDetailsEntity roomDetails;
  const RoomDetailsLoaded({required this.roomDetails});

  @override
  List<Object?> get props => [roomDetails];
}

class RoomDetailsError extends RoomDetailsState {
  final String message;
  final UnitRoomEntity room;

  const RoomDetailsError({required this.message, required this.room});

  @override
  List<Object?> get props => [message, room];
}
