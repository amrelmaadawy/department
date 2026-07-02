import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/contract_print_entity.dart';
import '../../domain/repositories/contract_print_repository.dart';
import '../datasources/contract_print_remote_datasource.dart';

class ContractPrintRepositoryImpl implements ContractPrintRepository {
  final ContractPrintRemoteDataSource remoteDataSource;

  ContractPrintRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ContractPrintEntity>> getBoneContractPrintData(int apartmentId) async {
    try {
      final result = await remoteDataSource.getBoneContractPrintData(apartmentId);
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, ContractPrintEntity>> getFinishingContractPrintData(int apartmentId) async {
    try {
      final result = await remoteDataSource.getFinishingContractPrintData(apartmentId);
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> downloadPdfBytes(String pdfUrl) async {
    try {
      final bytes = await remoteDataSource.downloadPdfBytes(pdfUrl);
      return Right(bytes);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  Failure _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response?.statusCode == 403) {
        final msg = e.response?.data?['message']?.toString() ??
            'عقد العظم غير موجود أو لا تملك صلاحية الوصول إليه (تأكد أنك مسجل دخول بحساب العميل صاحب العقد)';
        return ForbiddenFailure(msg);
      }
      final serverMsg = e.response?.data?['message']?.toString();
      if (serverMsg != null && serverMsg.isNotEmpty) {
        return ServerFailure(serverMsg);
      }
    }
    final msg = e.toString().replaceAll('Exception: ', '');
    if (msg.contains('صلاحية') || msg.contains('غير موجود')) {
      return ForbiddenFailure(msg);
    }
    return ServerFailure(msg.isEmpty ? 'فشل في جلب بيانات الطباعة العقد' : msg);
  }
}
