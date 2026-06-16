import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/project_repository.dart';

class GetPresetNotesUseCase {
  final ProjectRepository repository;

  GetPresetNotesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getPresetNotes();
  }
}
