import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_entity.dart';
import '../entities/apartment_finishing_order_entity.dart';
import '../entities/contract_signature_status_entity.dart';

abstract class ContractRepository {
  Future<Either<Failure, ContractEntity>> createBoneContract(int apartmentId);
  Future<Either<Failure, ContractEntity>> createFinishingContract(List<int> finishingOrderIds);
  Future<Either<Failure, ContractEntity>> signContract(int contractId, String signatureBase64);
  Future<Either<Failure, List<ApartmentFinishingOrderRoomEntity>>> getApartmentFinishingOrders(int apartmentId);

  Future<Either<Failure, bool>> isContractSigned(String unitId, String contractType);
  Future<Either<Failure, void>> markContractAsSigned(String unitId, String contractType, bool status);
  Future<Either<Failure, List<ContractSignatureStatusEntity>>> getContractStatusesList(String unitId);

  /// Persists finishing order IDs locally so they survive app restarts.
  Future<Either<Failure, void>> saveFinishingOrderIds(int apartmentId, List<int> ids);

  /// Returns locally cached finishing order IDs (empty list = not yet cached).
  Future<Either<Failure, List<int>>> getFinishingOrderIds(int apartmentId);

  Future<Either<Failure, List<ContractEntity>>> getContracts();
  Future<Either<Failure, ContractEntity>> getContractById(int id);
}
