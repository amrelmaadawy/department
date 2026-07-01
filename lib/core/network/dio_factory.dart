import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:crypto/crypto.dart';
import 'package:apartment/core/config/app_config.dart';

enum RequestType { fetch, mutation, upload, aiRender }

class _Timeouts {
  final Duration connect;
  final Duration receive;
  final Duration send;

  const _Timeouts({
    required this.connect,
    required this.receive,
    required this.send,
  });
}

class DioFactory {
  static Dio createDio(RequestType type, {String? baseUrl}) {
    final timeouts = _getTimeouts(type);
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? AppConfig.baseUrl,
      connectTimeout: timeouts.connect,
      receiveTimeout: timeouts.receive,
      sendTimeout: timeouts.send,
    ));

    if (AppConfig.enableSSLPinning) {
      dio.httpClientAdapter = _createPinnedAdapter();
    }

    return dio;
  }

  static IOHttpClientAdapter _createPinnedAdapter() {
    return IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) {
          const validFingerprints = <String>{
            'XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX', // Primary
            'YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY', // Backup
          };

          final certFingerprint = sha256
              .convert(cert.der)
              .bytes
              .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
              .join(':');

          return validFingerprints.contains(certFingerprint);
        };
        return client;
      },
    );
  }

  static _Timeouts _getTimeouts(RequestType type) {
    switch (type) {
      case RequestType.fetch:
        return const _Timeouts(
          connect: Duration(seconds: 10),
          receive: Duration(seconds: 15),
          send: Duration(seconds: 10),
        );
      case RequestType.mutation:
        return const _Timeouts(
          connect: Duration(seconds: 10),
          receive: Duration(seconds: 30),
          send: Duration(seconds: 30),
        );
      case RequestType.upload:
        return const _Timeouts(
          connect: Duration(seconds: 10),
          receive: Duration(seconds: 120),
          send: Duration(seconds: 120),
        );
      case RequestType.aiRender:
        return const _Timeouts(
          connect: Duration(seconds: 10),
          receive: Duration(seconds: 180),
          send: Duration(seconds: 60),
        );
    }
  }
}
