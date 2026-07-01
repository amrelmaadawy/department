import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SecureLoggingInterceptor extends Interceptor {
  static const _sensitiveKeys = {
    'password',
    'password_confirmation',
    'token',
    'access_token',
    'refresh_token',
    'authorization',
    'secret',
    'pin',
    'otp',
    'card_number',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('→ REQUEST: ${options.method} ${options.uri}');
      debugPrint('→ HEADERS: ${_sanitize(options.headers)}');
      debugPrint('→ BODY: ${_sanitize(options.data)}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('← RESPONSE: ${response.statusCode}');
      debugPrint('← BODY: ${_sanitize(response.data)}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('✗ ERROR: ${err.type} | ${err.response?.statusCode}');
    }
    handler.next(err);
  }

  dynamic _sanitize(dynamic data) {
    if (data is Map) {
      return data.map((key, value) {
        final isSensitive = _sensitiveKeys.contains(
          key.toString().toLowerCase(),
        );
        return MapEntry(key, isSensitive ? '********' : _sanitize(value));
      });
    }
    if (data is List) return data.map(_sanitize).toList();
    return data;
  }
}
