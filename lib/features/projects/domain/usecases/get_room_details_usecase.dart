import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/room_details_entity.dart';
import '../repositories/project_repository.dart';

class GetRoomDetailsUseCase {
  final ProjectRepository repository;

  GetRoomDetailsUseCase(this.repository);

  Future<Either<Failure, RoomDetailsEntity>> call(int id) async {
    return await repository.getRoomDetails(id);
  }
}
