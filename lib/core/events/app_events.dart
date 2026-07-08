import 'dart:async';

class AppEvents {
  static final _contractSignedController = StreamController<String>.broadcast();
  static final _logoutController = StreamController<void>.broadcast();
  static final _loginController = StreamController<void>.broadcast();
  
  static Stream<String> get onContractSigned => _contractSignedController.stream;
  static Stream<void> get onLogout => _logoutController.stream;
  static Stream<void> get onLogin => _loginController.stream;
  
  static void emitContractSigned(String unitId) {
    _contractSignedController.add(unitId);
  }

  static void emitLogout() {
    _logoutController.add(null);
  }

  static void emitLogin() {
    _loginController.add(null);
  }
}
