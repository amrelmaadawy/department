import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/customization_draft_entity.dart';
import '../repositories/project_repository.dart';

class SaveCustomizationDraftUseCase {
  final ProjectRepository repository;

  SaveCustomizationDraftUseCase(this.repository);

  Future<Either<Failure, CustomizationDraftEntity>> call(int apartmentId, Map<String, dynamic> draftData) {
    return repository.saveCustomizationDraft(apartmentId, draftData);
  }
}
