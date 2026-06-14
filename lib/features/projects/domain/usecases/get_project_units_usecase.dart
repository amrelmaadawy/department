import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/project_unit_entity.dart';
import '../repositories/project_repository.dart';

class GetProjectUnitsUseCase {
  final ProjectRepository repository;

  GetProjectUnitsUseCase(this.repository);

  Future<Either<Failure, List<ProjectUnitEntity>>> call(int id) async {
    return await repository.getProjectUnits(id);
  }
}
