import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/download/download_service.dart';
import 'download_image_state.dart';

class DownloadImageCubit extends Cubit<DownloadImageState> {
  final IDownloadService downloadService;

  DownloadImageCubit({required this.downloadService}) : super(DownloadImageInitial());

  Future<void> downloadImage(String url, {required String successMessage}) async {
    if (state is DownloadImageLoading) return;
    
    emit(DownloadImageLoading());
    try {
      final fileName = "ai_design_${DateTime.now().millisecondsSinceEpoch}";
      await downloadService.downloadAndSaveImage(url, fileName: fileName);
      emit(DownloadImageSuccess(message: successMessage));
    } catch (e) {
      emit(DownloadImageError(message: e.toString().replaceAll('ServerException: ', '').replaceAll('Exception: ', '')));
    }
  }
}
