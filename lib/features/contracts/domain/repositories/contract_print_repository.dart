import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contract_print_entity.dart';

abstract class ContractPrintRepository {
  Future<Either<Failure, ContractPrintEntity>> getBoneContractPrintData(int apartmentId);
  Future<Either<Failure, ContractPrintEntity>> getFinishingContractPrintData(int apartmentId);
  Future<Either<Failure, Uint8List>> downloadPdfBytes(String pdfUrl);
}
