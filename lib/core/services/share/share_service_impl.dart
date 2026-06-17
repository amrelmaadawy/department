import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'share_service.dart';

class ShareServiceImpl implements IShareService {
  final Dio _dio;

  ShareServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<void> shareImage({required String imagePath, required String text}) async {
    if (imagePath.isEmpty) {
      throw Exception('Image path cannot be empty');
    }

    String localPath = imagePath;

    try {
      // Check if the imagePath is a network URL
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        final tempDir = await getTemporaryDirectory();
        final fileName = 'shared_design_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savePath = '${tempDir.path}/$fileName';

        // Download the image
        await _dio.download(imagePath, savePath);
        localPath = savePath;
      }

      // Share the file
      final xFile = XFile(localPath);
      await SharePlus.instance.share(ShareParams(files: [xFile], text: text));

    } catch (e) {
      throw Exception('Failed to share image: $e');
    }
  }
}
