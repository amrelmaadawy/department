import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum NetworkStatus {
  online,          // متصل وعنده internet فعلي
  offline,         // مفيش connection خالص
  noInternet,      // متصل بـ Wi-Fi بس مفيش internet (Captive Portal)
  slow,            // متصل بس latency عالية
}

abstract class NetworkInfo {
  Stream<NetworkStatus> get onStatusChange;
  Future<NetworkStatus> get currentStatus;
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final InternetConnection _checker;

  NetworkInfoImpl(this._connectivity, this._checker);

  @override
  Stream<NetworkStatus> get onStatusChange async* {
    await for (final results in _connectivity.onConnectivityChanged) {
      if (results.contains(ConnectivityResult.none) || results.isEmpty) {
        yield NetworkStatus.offline;
      } else {
        final hasInternet = await _checker.hasInternetAccess;
        yield hasInternet ? NetworkStatus.online : NetworkStatus.noInternet;
      }
    }
  }

  @override
  Future<NetworkStatus> get currentStatus async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      return NetworkStatus.offline;
    }
    final hasInternet = await _checker.hasInternetAccess;
    return hasInternet ? NetworkStatus.online : NetworkStatus.noInternet;
  }

  @override
  Future<bool> get isConnected async {
    final status = await currentStatus;
    return status == NetworkStatus.online;
  }
}
