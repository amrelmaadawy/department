import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';

import '../../error/exceptions.dart';

abstract class IDownloadService {
  Future<void> downloadAndSaveImage(String url, {required String fileName});
}

class DownloadServiceImpl implements IDownloadService {
  final Dio _dio;

  DownloadServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<void> downloadAndSaveImage(String url, {required String fileName}) async {
    if (kIsWeb) {
      throw const ServerException(message: 'حفظ الصور في المعرض غير مدعوم على الويب');
    }

    try {
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (!await Gal.hasAccess()) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          throw const ServerException(message: 'يجب منح صلاحية الوصول للمعرض لحفظ الصور');
        }
      }

      await Gal.putImageBytes(
        Uint8List.fromList(response.data),
        name: fileName,
      );
    } on DioException catch (e) {
      throw ServerException(message: 'فشل في تحميل الصورة: ${e.message}');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'حدث خطأ أثناء حفظ الصورة: $e');
    }
  }
}
