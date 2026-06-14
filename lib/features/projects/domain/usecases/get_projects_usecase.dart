import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../repositories/project_repository.dart';

class GetProjectsUseCase {
  final ProjectRepository repository;

  GetProjectsUseCase(this.repository);

  Future<Either<Failure, List<ProjectEntity>>> call() async {
    return await repository.getProjects();
  }
}
