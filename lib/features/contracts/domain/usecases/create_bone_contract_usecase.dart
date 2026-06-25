import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_entity.dart';
import '../repositories/contract_repository.dart';

class CreateBoneContractUseCase {
  final ContractRepository repository;

  CreateBoneContractUseCase(this.repository);

  Future<Either<Failure, ContractEntity>> call({required int apartmentId}) async {
    return await repository.createBoneContract(apartmentId);
  }
}
