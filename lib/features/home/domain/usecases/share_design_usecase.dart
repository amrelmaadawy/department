import 'package:dartz/dartz.dart';
import 'package:apartment/core/error/failures.dart';
import 'package:apartment/core/services/share/share_service.dart';

class ShareDesignUseCase {
  final IShareService _shareService;

  ShareDesignUseCase({required IShareService shareService}) : _shareService = shareService;

  Future<Either<Failure, void>> call(String imagePath, String text) async {
    try {
      await _shareService.shareImage(imagePath: imagePath, text: text);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('فشل في مشاركة التصميم'));
    }
  }
}
