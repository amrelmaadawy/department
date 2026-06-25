import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/contract_repository.dart';

class GetContractSignatureStatusUseCase {
  final ContractRepository repository;

  GetContractSignatureStatusUseCase(this.repository);

  Future<Either<Failure, bool>> call(String unitId, String contractType) async {
    return await repository.isContractSigned(unitId, contractType);
  }
}
