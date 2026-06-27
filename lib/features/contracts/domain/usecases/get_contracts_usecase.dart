import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_entity.dart';
import '../repositories/contract_repository.dart';

class GetContractsUseCase {
  final ContractRepository repository;

  GetContractsUseCase(this.repository);

  Future<Either<Failure, List<ContractEntity>>> call() async {
    return await repository.getContracts();
  }
}
