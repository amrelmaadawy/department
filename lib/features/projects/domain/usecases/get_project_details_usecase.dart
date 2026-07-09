import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../repositories/project_repository.dart';

class GetProjectDetailsUseCase {
  final ProjectRepository repository;

  GetProjectDetailsUseCase(this.repository);

  Future<Either<Failure, ProjectEntity>> call(int id, {bool forceRefresh = false}) async {
    return await repository.getProjectDetails(id, forceRefresh: forceRefresh);
  }
}
