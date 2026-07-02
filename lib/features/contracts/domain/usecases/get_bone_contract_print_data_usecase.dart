import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_print_entity.dart';
import '../repositories/contract_print_repository.dart';

class GetBoneContractPrintDataUseCase {
  final ContractPrintRepository repository;

  GetBoneContractPrintDataUseCase({required this.repository});

  Future<Either<Failure, ContractPrintEntity>> call(int apartmentId) {
    return repository.getBoneContractPrintData(apartmentId);
  }
}
