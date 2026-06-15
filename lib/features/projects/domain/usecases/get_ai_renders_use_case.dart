import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/ai_renders_entity.dart';
import '../repositories/project_repository.dart';

class GetAiRendersUseCase {
  final ProjectRepository repository;

  GetAiRendersUseCase(this.repository);

  Future<Either<Failure, AiRendersEntity>> call(int orderId) async {
    return await repository.getAiRenders(orderId);
  }
}
