import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/contract_repository.dart';

class GetFinishingOrderIdsUseCase {
  final ContractRepository repository;

  GetFinishingOrderIdsUseCase(this.repository);

  Future<Either<Failure, List<int>>> call(int apartmentId) {
    return repository.getFinishingOrderIds(apartmentId);
  }
}
