import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_entity.dart';
import '../repositories/contract_repository.dart';

class SignContractUseCase {
  final ContractRepository repository;

  SignContractUseCase(this.repository);

  Future<Either<Failure, ContractEntity>> call({
    required int contractId,
    required String signatureBase64,
  }) async {
    // Basic validation before hitting the repository
    if (signatureBase64.isEmpty) {
      return const Left(ServerFailure('Signature cannot be empty'));
    }
    
    // Add data URI prefix if it's missing and required by convention, 
    // although raw base64 is usually accepted. We'll pass it exactly as encoded.
    // If backend fails, we might need to prefix 'data:image/png;base64,'
    
    return await repository.signContract(contractId, signatureBase64);
  }
}
