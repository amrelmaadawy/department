import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/finishing_progress_stage_entity.dart';
import '../repositories/project_repository.dart';
class GetFinishingProgressUseCase {
  final ProjectRepository repository;

  GetFinishingProgressUseCase(this.repository);

  Future<Either<Failure, List<FinishingProgressStageEntity>>> call(int apartmentId) async {
    return await repository.getFinishingProgress(apartmentId);
  }
}
