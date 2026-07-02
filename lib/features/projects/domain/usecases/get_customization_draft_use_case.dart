import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/customization_draft_entity.dart';
import '../repositories/project_repository.dart';

class GetCustomizationDraftUseCase {
  final ProjectRepository repository;

  GetCustomizationDraftUseCase(this.repository);

  Future<Either<Failure, CustomizationDraftEntity>> call(int apartmentId) {
    return repository.getCustomizationDraft(apartmentId);
  }
}
