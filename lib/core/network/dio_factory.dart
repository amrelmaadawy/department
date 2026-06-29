import 'package:dio/dio.dart';

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
    return Dio(BaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: timeouts.connect,
      receiveTimeout: timeouts.receive,
      sendTimeout: timeouts.send,
    ));
  }

  static _Timeouts _getTimeouts(RequestType type) {
    switch (type) {
      case RequestType.fetch:
        return const _Timeouts(
          connect: Duration(seconds: 10), 
          receive: Duration(seconds: 15), 
          send: Duration(seconds: 10)
        );
      case RequestType.mutation:
        return const _Timeouts(
          connect: Duration(seconds: 10), 
          receive: Duration(seconds: 30), 
          send: Duration(seconds: 30)
        );
      case RequestType.upload:
        return const _Timeouts(
          connect: Duration(seconds: 10), 
          receive: Duration(seconds: 120), 
          send: Duration(seconds: 120)
        );
      case RequestType.aiRender:
        return const _Timeouts(
          connect: Duration(seconds: 10), 
          receive: Duration(seconds: 180), 
          send: Duration(seconds: 60)
        );
    }
  }
}
