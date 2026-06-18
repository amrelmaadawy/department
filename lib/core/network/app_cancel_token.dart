import 'package:dio/dio.dart';

class AppCancelToken {
  final CancelToken _token;

  AppCancelToken() : _token = CancelToken();

  CancelToken get token => _token;

  void cancel([String? reason]) {
    _token.cancel(reason);
  }
}
