import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/project_repository.dart';
import '../entities/saved_design_entity.dart';
import '../../data/models/save_design_request_model.dart';

class SaveDesignUseCase {
  final ProjectRepository repository;

  SaveDesignUseCase(this.repository);

  Future<Either<Failure, SavedDesignEntity>> call(SaveDesignRequestModel request) async {
    return await repository.saveDesign(request);
  }
}
