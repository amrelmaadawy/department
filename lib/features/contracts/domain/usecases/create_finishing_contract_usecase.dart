import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_entity.dart';
import '../repositories/contract_repository.dart';

class CreateFinishingContractUseCase {
  final ContractRepository repository;

  CreateFinishingContractUseCase(this.repository);

  Future<Either<Failure, ContractEntity>> call(List<int> finishingOrderIds) async {
    return await repository.createFinishingContract(finishingOrderIds);
  }
}
