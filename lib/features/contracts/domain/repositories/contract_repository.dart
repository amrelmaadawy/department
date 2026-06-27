import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_entity.dart';
import '../entities/apartment_finishing_order_entity.dart';

abstract class ContractRepository {
  Future<Either<Failure, ContractEntity>> createBoneContract(int apartmentId);
  Future<Either<Failure, ContractEntity>> createFinishingContract(List<int> finishingOrderIds);
  Future<Either<Failure, ContractEntity>> signContract(int contractId, String signatureBase64);
  Future<Either<Failure, List<ApartmentFinishingOrderRoomEntity>>> getApartmentFinishingOrders(int apartmentId);
  
  Future<Either<Failure, bool>> isContractSigned(String unitId, String contractType);
  Future<Either<Failure, void>> markContractAsSigned(String unitId, String contractType, bool status);
  
  Future<Either<Failure, List<ContractEntity>>> getContracts();
}
