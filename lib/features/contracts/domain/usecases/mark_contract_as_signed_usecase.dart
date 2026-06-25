import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/contract_repository.dart';

class MarkContractAsSignedUseCase {
  final ContractRepository repository;

  MarkContractAsSignedUseCase(this.repository);

  Future<Either<Failure, void>> call(String unitId, String contractType, bool status) async {
    return await repository.markContractAsSigned(unitId, contractType, status);
  }
}
