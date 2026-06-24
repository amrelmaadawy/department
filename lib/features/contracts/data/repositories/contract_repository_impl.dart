import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/repositories/contract_repository.dart';
import '../../domain/entities/apartment_finishing_order_entity.dart';
import '../datasources/contract_remote_datasource.dart';

class ContractRepositoryImpl implements ContractRepository {
  final ContractRemoteDataSource remoteDataSource;

  ContractRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ContractEntity>> createBoneContract(int apartmentId, int customerId) async {
    try {
      final contract = await remoteDataSource.createBoneContract(apartmentId, customerId);
      return Right(contract);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message']?.toString() ?? e.message ?? 'Network error'));
    } catch (e) {
      // Extract clean message if it's a standard exception
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
