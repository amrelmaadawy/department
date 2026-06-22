import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/customer_render_entity.dart';
import '../repositories/project_repository.dart';

class GetCustomerRendersUseCase {
  final ProjectRepository repository;

  GetCustomerRendersUseCase(this.repository);

  Future<Either<Failure, List<RoomCustomerRendersEntity>>> call(int apartmentId) async {
    return await repository.getCustomerRenders(apartmentId);
  }
}
