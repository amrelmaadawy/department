import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/finishing_order_entity.dart';
import '../entities/finishing_order_request_entity.dart';
import '../repositories/project_repository.dart';

class SubmitFinishingOrderUseCase {
  final ProjectRepository repository;

  SubmitFinishingOrderUseCase(this.repository);

  Future<Either<Failure, FinishingOrderEntity>> call(FinishingOrderRequestEntity params) async {
    return await repository.submitFinishingOrder(params);
  }
}
