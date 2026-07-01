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
    
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await secureStorage.delete(key: _tokenKey);
      await secureStorage.delete(key: 'access_token');
      await secureStorage.delete(key: 'refresh_token');
      AppRouter.clearAuthCache();
      AppRouter.router.go(AppRouter.auth);
    }
    super.onError(err, handler);
  }
}
