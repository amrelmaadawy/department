import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_signature_status_entity.dart';
import '../repositories/contract_repository.dart';

class GetContractStatusesListUseCase {
  final ContractRepository repository;

  GetContractStatusesListUseCase(this.repository);

  Future<Either<Failure, List<ContractSignatureStatusEntity>>> call(String unitId) async {
    final result = await repository.getContractStatusesList(unitId);
    return result.map((list) {
      final sortedList = List<ContractSignatureStatusEntity>.from(list)
        ..sort((a, b) => a.sequenceOrder.compareTo(b.sequenceOrder));
      return sortedList;
    });
  }
}
