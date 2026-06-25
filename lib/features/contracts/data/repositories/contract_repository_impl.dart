import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/repositories/contract_repository.dart';
import '../../domain/entities/apartment_finishing_order_entity.dart';
import '../datasources/contract_remote_datasource.dart';

import '../datasources/contract_local_datasource.dart';

class ContractRepositoryImpl implements ContractRepository {
  final ContractRemoteDataSource remoteDataSource;
  final ContractLocalDataSource localDataSource;

  ContractRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ContractEntity>> createBoneContract(int apartmentId) async {
    try {
      final customerId = await localDataSource.getCustomerId();
      final contract = await remoteDataSource.createBoneContract(apartmentId, customerId);
      return Right(contract);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message']?.toString() ?? e.message ?? 'Network error'));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(ServerFailure(msg));
    }
  }

  @override
  Future<Either<Failure, bool>> isContractSigned(String unitId, String contractType) async {
    try {
      final isSigned = await localDataSource.getSignatureStatus(unitId, contractType);
      return Right(isSigned);
    } catch (e) {
      return Left(ServerFailure('Failed to read signature status'));
    }
  }

  @override
  Future<Either<Failure, void>> markContractAsSigned(String unitId, String contractType, bool status) async {
    try {
      await localDataSource.saveSignatureStatus(unitId, contractType, status);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to save signature status'));
    }
  }

  @override
  Future<Either<Failure, ContractEntity>> createFinishingContract(List<int> finishingOrderIds) async {
    try {
      final contract = await remoteDataSource.createFinishingContract(finishingOrderIds);
      return Right(contract);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message']?.toString() ?? e.message ?? 'Network error'));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(ServerFailure(msg));
    }
  }
  @override
  Future<Either<Failure, ContractEntity>> signContract(int contractId, String signatureBase64) async {
    try {
      final contract = await remoteDataSource.signContract(contractId, signatureBase64);
      return Right(contract);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message']?.toString() ?? e.message ?? 'Network error'));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(ServerFailure(msg));
    }
  }

  @override
  Future<Either<Failure, List<ApartmentFinishingOrderRoomEntity>>> getApartmentFinishingOrders(int apartmentId) async {
    try {
      final orders = await remoteDataSource.getApartmentFinishingOrders(apartmentId);
      return Right(orders);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message']?.toString() ?? e.message ?? 'Network error'));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(ServerFailure(msg));
    }
  }
}
