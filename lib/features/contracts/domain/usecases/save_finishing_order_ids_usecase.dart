import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/contract_repository.dart';

class SaveFinishingOrderIdsUseCase {
  final ContractRepository repository;

  SaveFinishingOrderIdsUseCase(this.repository);

  Future<Either<Failure, void>> call(int apartmentId, List<int> ids) {
    return repository.saveFinishingOrderIds(apartmentId, ids);
  }
}
