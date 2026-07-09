import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../repositories/project_repository.dart';

import '../../../../core/network/app_cancel_token.dart';

class GetProjectsUseCase {
  final ProjectRepository repository;

  GetProjectsUseCase(this.repository);

  Future<Either<Failure, List<ProjectEntity>>> call({AppCancelToken? cancelToken, bool forceRefresh = false}) async {
    return await repository.getProjects(cancelToken: cancelToken, forceRefresh: forceRefresh);
  }
}
