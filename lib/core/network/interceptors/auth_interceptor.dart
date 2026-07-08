import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/security/token_rotation_service.dart';
import '../../routes/app_router.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final TokenRotationService? tokenRotationService;
  static const String _tokenKey = 'auth_token';

  AuthInterceptor({
    required this.secureStorage,
    this.tokenRotationService,
  });

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.path.contains('/auth/login') && !options.path.contains('/auth/register')) {
      String? token;
      if (tokenRotationService != null) {
        token = await tokenRotationService!.getValidAccessToken();
      } else {
        token = await secureStorage.read(key: _tokenKey);
      }

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    
    if (options.responseType != ResponseType.bytes) {
      options.headers['Accept'] = 'application/json';
    } else {
      options.headers['Accept'] ??= '*/*';
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final responseData = err.response?.data?.toString().toLowerCase() ?? '';
    final message = err.message?.toLowerCase() ?? '';

    final isUnauthorized = statusCode == 401 ||
        statusCode == 403 ||
        responseData.contains('unauthenticated') ||
        responseData.contains('unauthorized') ||
        message.contains('unauthenticated') ||
        message.contains('unauthorized');

    if (isUnauthorized) {
      // 1. Delete all tokens
      await secureStorage.delete(key: _tokenKey);
      await secureStorage.delete(key: 'access_token');
      await secureStorage.delete(key: 'refresh_token');
      
      // 2. Clear Auth Cache to force false
      AppRouter.clearAuthCache();
      AppRouter.setUnauthenticated();
      
      // 3. Force navigation to Auth Screen and clear the entire navigation stack
      AppRouter.router.go(AppRouter.auth);
      
      // Do not propagate the error to avoid showing ugly messages to the user
      // We resolve it as a fake successful empty response to kill the error chain gracefully
      return handler.reject(DioException(
        requestOptions: err.requestOptions,
        error: 'session_expired',
        type: DioExceptionType.cancel,
      ));
    }
    super.onError(err, handler);
  }
}
