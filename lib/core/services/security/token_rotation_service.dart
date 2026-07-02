import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:apartment/core/config/app_config.dart';

class TokenResponse {
  final String accessToken;
  final String refreshToken;

  const TokenResponse({
    required this.accessToken,
    required this.refreshToken,
  });
}

class TokenRotationService {
  final FlutterSecureStorage _secureStorage;
  final Dio _refreshDio;

  static const _accessTokenTTL = Duration(minutes: 15);

  TokenRotationService({
    required FlutterSecureStorage secureStorage,
    Dio? refreshDio,
  })  : _secureStorage = secureStorage,
        _refreshDio = refreshDio ?? Dio(BaseOptions(baseUrl: AppConfig.baseUrl));

  Future<bool> isAccessTokenExpired() async {
    final expiryStr = await _secureStorage.read(key: 'token_expiry');
    if (expiryStr == null) {
      // Check if JWT token has expiration claim inside it
      final token = await _secureStorage.read(key: 'auth_token') ??
          await _secureStorage.read(key: 'access_token');
      if (token != null) {
        final exp = _getJwtExpiry(token);
        if (exp != null) {
          return DateTime.now().isAfter(exp.subtract(const Duration(minutes: 1)));
        }
      }
      return false;
    }

    final expiry = DateTime.tryParse(expiryStr);
    if (expiry == null) return false;
    return DateTime.now().isAfter(expiry.subtract(const Duration(minutes: 1)));
  }

  DateTime? _getJwtExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final map = json.decode(payload) as Map<String, dynamic>;
      if (map.containsKey('exp') && map['exp'] is int) {
        return DateTime.fromMillisecondsSinceEpoch((map['exp'] as int) * 1000);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error decoding JWT expiry: $e\n$stackTrace');
      }
    }
    return null;
  }

  Future<bool> refreshTokens() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) return false;

    try {
      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final newAccess = data['access_token'] ?? data['token'];
        final newRefresh = data['refresh_token'] ?? refreshToken;

        if (newAccess != null) {
          await Future.wait([
            _secureStorage.write(key: 'auth_token', value: newAccess.toString()),
            _secureStorage.write(key: 'access_token', value: newAccess.toString()),
            _secureStorage.write(key: 'refresh_token', value: newRefresh.toString()),
            _secureStorage.write(
              key: 'token_expiry',
              value: DateTime.now().add(_accessTokenTTL).toIso8601String(),
            ),
          ]);
          return true;
        }
      }
      return false;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error refreshing tokens: $e\n$stackTrace');
      }
      await _secureStorage.deleteAll();
      return false;
    }
  }

  Future<String?> getValidAccessToken() async {
    if (await isAccessTokenExpired()) {
      final refreshed = await refreshTokens();
      if (!refreshed) {
        // Fallback to reading existing auth_token if refresh failed or not configured
        return await _secureStorage.read(key: 'auth_token') ??
            await _secureStorage.read(key: 'access_token');
      }
    }
    return await _secureStorage.read(key: 'auth_token') ??
        await _secureStorage.read(key: 'access_token');
  }
}
