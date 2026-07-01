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
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isContractSigned(String unitId, String contractType) async {
    try {
      final isSigned = await localDataSource.getSignatureStatus(unitId, contractType);
      return Right(isSigned);
    } catch (e) {
      return const Left(ServerFailure('فشل في قراءة حالة التوقيع'));
    }
  }

  @override
  Future<Either<Failure, void>> markContractAsSigned(String unitId, String contractType, bool status) async {
    try {
      await localDataSource.saveSignatureStatus(unitId, contractType, status);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('فشل في حفظ حالة التوقيع'));
    }
  }

  @override
  Future<Either<Failure, ContractEntity>> createFinishingContract(List<int> finishingOrderIds) async {
    try {
      final contract = await remoteDataSource.createFinishingContract(finishingOrderIds);
      return Right(contract);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, ContractEntity>> signContract(int contractId, String signatureBase64) async {
    try {
      final contract = await remoteDataSource.signContract(contractId, signatureBase64);
      return Right(contract);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<ApartmentFinishingOrderRoomEntity>>> getApartmentFinishingOrders(int apartmentId) async {
    try {
      final orders = await remoteDataSource.getApartmentFinishingOrders(apartmentId);
      return Right(orders);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<ContractEntity>>> getContracts() async {
    try {
      final contracts = await remoteDataSource.getContracts();
      return Right(contracts);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, ContractEntity>> getContractById(int id) async {
    try {
      final contract = await remoteDataSource.getContractById(id);
      return Right(contract);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  Failure _handleError(Object e) {
    if (e is DioException) {
      if (e.error is Failure) {
        final fail = e.error as Failure;
        return _ensureArabicFailure(fail);
      }
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return const TimeoutFailure('انتهت مهلة الاتصال بالخادم، يرجى التحقق من جودة الإنترنت والمحاولة مرة أخرى');
        case DioExceptionType.connectionError:
          return const OfflineFailure('لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة');
        default:
          final serverMsg = e.response?.data?['message']?.toString();
          if (serverMsg != null && serverMsg.isNotEmpty) {
            return ServerFailure(_translateToArabic(serverMsg));
          }
          return const ServerFailure('حدث خطأ أثناء الاتصال بالخادم، يرجى إعادة المحاولة');
      }
    }
    final msg = e.toString().replaceAll('Exception: ', '');
    return ServerFailure(_translateToArabic(msg));
  }

  Failure _ensureArabicFailure(Failure failure) {
    final msg = _translateToArabic(failure.message);
    if (failure is TimeoutFailure) return TimeoutFailure(msg);
    if (failure is OfflineFailure) return OfflineFailure(msg);
    if (failure is ServerFailure) return ServerFailure(msg, failure.code);
    return ServerFailure(msg);
  }

  String _translateToArabic(String msg) {
    if (msg.isEmpty) return 'حدث خطأ غير متوقع، يرجى إعادة المحاولة.';
    final lower = msg.toLowerCase();
    if (lower.contains('timeout') || lower.contains('took longer than')) {
      return 'انتهت مهلة الاتصال بالخادم، يرجى التحقق من جودة الإنترنت والمحاولة مرة أخرى.';
    }
    if (lower.contains('connection') || lower.contains('socket') || lower.contains('network') || lower.contains('failed host lookup')) {
      return 'تعذر الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت.';
    }
    if (lower.contains('already signed')) {
      return 'تم توقيع هذا العقد بالفعل.';
    }
    if (lower.contains('invalid signature')) {
      return 'التوقيع المرسل غير صالح، يرجى إعادة التوقيع.';
    }
    if (lower.contains('unauthorized') || lower.contains('unauthenticated')) {
      return 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى.';
    }
    if (lower.contains('not found')) {
      return 'العقد المطلوب غير موجود.';
    }
    if (RegExp(r'^[a-zA-Z0-9\s\.\,\:\-\_\/\(\)]+$').hasMatch(msg)) {
      return 'استغرقت العملية وقتاً أطول من المعتاد أو حدث خطأ في الخادم، يرجى إعادة المحاولة.';
    }
    return msg;
  }
}
