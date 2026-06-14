import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/entities/unit_room_entity.dart';
import '../../domain/usecases/get_room_details_usecase.dart';
import 'room_details_state.dart';

class RoomDetailsCubit extends Cubit<RoomDetailsState> {
  final GetRoomDetailsUseCase getRoomDetailsUseCase;

  RoomDetailsCubit({
    required this.getRoomDetailsUseCase,
  }) : super(RoomDetailsInitial());

  Future<void> loadRoomDetails(UnitRoomEntity room) async {
    emit(RoomDetailsLoading(room: room));

    final result = await getRoomDetailsUseCase(room.id);

    result.fold(
      (failure) => emit(RoomDetailsError(
        message: failure.message,
        room: room,
      )),
      (roomDetails) => emit(RoomDetailsLoaded(roomDetails: roomDetails)),
    );
  }
}
