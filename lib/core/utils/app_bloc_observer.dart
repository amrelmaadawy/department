import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      print('🟢 Bloc Created: ${bloc.runtimeType}');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      print(
        '🔄 Bloc Changed: ${bloc.runtimeType} | Current: ${change.currentState} -> Next: ${change.nextState}',
      );
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      print(
        '➡️ Bloc Transition: ${bloc.runtimeType} | Event: ${transition.event}',
      );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('❌ Bloc Error: ${bloc.runtimeType} | $error');
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    if (kDebugMode) {
      print('🔴 Bloc Closed: ${bloc.runtimeType}');
    }
    super.onClose(bloc);
  }
}
