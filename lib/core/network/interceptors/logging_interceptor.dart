import 'dart:developer';
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('==================== API REQUEST ====================');
    log('${options.method.toUpperCase()} ${options.uri}');
    log('Headers: ${options.headers}');
    if (options.queryParameters.isNotEmpty) {
      log('QueryParameters: ${options.queryParameters}');
    }
    if (options.data != null) {
      log('Body: ${options.data}');
    }
    log('====================================================');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('==================== API RESPONSE ==================');
    log('${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}');
    log('Status Code: ${response.statusCode}');
    log('Data: ${response.data}');
    log('====================================================');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('==================== API ERROR =====================');
    log('${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri}');
    log('Status Code: ${err.response?.statusCode}');
    log('Error Message: ${err.message}');
    if (err.response?.data != null) {
      log('Error Data: ${err.response?.data}');
    }
    log('====================================================');
    super.onError(err, handler);
  }
}
