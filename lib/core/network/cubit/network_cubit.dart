import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../network_info.dart';
import 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkInfo _networkInfo;
  StreamSubscription<NetworkStatus>? _subscription;

  NetworkCubit(this._networkInfo) : super(NetworkInitial());

  void startMonitoring() {
    _subscription = _networkInfo.onStatusChange.listen((status) {
      switch (status) {
        case NetworkStatus.online:
          emit(NetworkOnline());
          break;
        case NetworkStatus.offline:
          emit(NetworkOffline());
          break;
        case NetworkStatus.noInternet:
          emit(NetworkNoInternet());
          break;
        case NetworkStatus.slow:
          break;
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
