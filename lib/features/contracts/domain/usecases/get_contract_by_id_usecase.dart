import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_entity.dart';
import '../repositories/contract_repository.dart';

class GetContractByIdUseCase {
  final ContractRepository repository;

  GetContractByIdUseCase(this.repository);

  Future<Either<Failure, ContractEntity>> call(int id) {
    return repository.getContractById(id);
  }
}
