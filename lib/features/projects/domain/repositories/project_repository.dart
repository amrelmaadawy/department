import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../../../home/domain/entities/project_unit_entity.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();
  Future<Either<Failure, ProjectEntity>> getProjectDetails(int id);
  Future<Either<Failure, List<ProjectUnitEntity>>> getProjectUnits(int id);
  Future<Either<Failure, ProjectUnitEntity>> getUnitDetails(int id);
}
