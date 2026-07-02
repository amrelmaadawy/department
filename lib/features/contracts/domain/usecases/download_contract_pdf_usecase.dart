import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/contract_print_repository.dart';

class DownloadContractPdfUseCase {
  final ContractPrintRepository repository;

  DownloadContractPdfUseCase({required this.repository});

  Future<Either<Failure, Uint8List>> call(String pdfUrl) {
    return repository.downloadPdfBytes(pdfUrl);
  }
}
