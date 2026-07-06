import 'package:dartz/dartz.dart';
import 'package:apartment/core/error/failures.dart';
import 'package:apartment/core/services/pdf/pdf_generator_service.dart';
import 'package:apartment/core/network/network_info.dart';

class GenerateContractPdfUseCase {
  final IPdfGeneratorService pdfGeneratorService;
  final NetworkInfo networkInfo;

  GenerateContractPdfUseCase(this.pdfGeneratorService, this.networkInfo);

  Future<Either<Failure, String>> call(String htmlContent, {String fileNamePrefix = 'contract'}) async {
    try {
      if (htmlContent.isEmpty) {
        return const Left(UnknownFailure('محتوى العقد فارغ'));
      }
      if (!(await networkInfo.isConnected)) {
        return const Left(OfflineFailure('يرجى التحقق من الاتصال بالإنترنت أولاً لضمان تحميل أختام الشركة بالشكل الصحيح.'));
      }
      final filePath = await pdfGeneratorService.generatePdfFromHtml(
        htmlContent,
        fileNamePrefix: fileNamePrefix,
      );
      return Right(filePath);
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      return Left(ServerFailure('حدث خطأ أثناء تجهيز العقد: $errorMessage'));
    }
  }
}
