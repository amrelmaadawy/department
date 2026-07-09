import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/project_unit_entity.dart';
import '../repositories/project_repository.dart';

class GetUnitDetailsUseCase {
  final ProjectRepository repository;

  GetUnitDetailsUseCase(this.repository);

  Future<Either<Failure, ProjectUnitEntity>> call(int id, {bool forceRefresh = false}) async {
    return await repository.getUnitDetails(id, forceRefresh: forceRefresh);
  }
}
