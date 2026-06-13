import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  static const String _tokenKey = 'auth_token';

  AuthInterceptor({required this.secureStorage});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip token injection for auth endpoints
    if (!options.path.contains('/auth/login') && !options.path.contains('/auth/register')) {
      final token = await secureStorage.read(key: _tokenKey);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    
    // Enforce JSON
    options.headers['Accept'] = 'application/json';
    
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // TODO: Implement Token Refresh logic if supported by backend
      // Or dispatch an event to log the user out
    }
    super.onError(err, handler);
  }
}
