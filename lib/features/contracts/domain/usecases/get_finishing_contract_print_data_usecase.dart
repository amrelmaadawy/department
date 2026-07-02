import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_print_entity.dart';
import '../repositories/contract_print_repository.dart';

class GetFinishingContractPrintDataUseCase {
  final ContractPrintRepository repository;

  GetFinishingContractPrintDataUseCase({required this.repository});

  Future<Either<Failure, ContractPrintEntity>> call(int apartmentId) {
    return repository.getFinishingContractPrintData(apartmentId);
  }
}
