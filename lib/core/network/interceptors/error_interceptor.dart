import 'package:dio/dio.dart';
import 'dart:developer';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Centralized global error catching before it hits the repository
    if (err.response?.statusCode == 401) {
      log('Global Error Interceptor: Unauthorized access detected.');
      // Handle logout or refresh here globally
    } else if (err.response?.statusCode == 500) {
      log('Global Error Interceptor: Internal Server Error.');
    }
    
    super.onError(err, handler);
  }
}
