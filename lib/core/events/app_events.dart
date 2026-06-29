import 'dart:async';

class AppEvents {
  static final _contractSignedController = StreamController<String>.broadcast();
  
  static Stream<String> get onContractSigned => _contractSignedController.stream;
  
  static void emitContractSigned(String unitId) {
    _contractSignedController.add(unitId);
  }
}
