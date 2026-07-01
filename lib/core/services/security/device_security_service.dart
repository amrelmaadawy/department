import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

enum DeviceSecurityStatus {
  secure,
  jailbroken,
  developerMode,
}

class DeviceSecurityService {
  Future<DeviceSecurityStatus> checkDeviceSecurity() async {
    try {
      final isJailbroken = await FlutterJailbreakDetection.jailbroken;
      if (isJailbroken) return DeviceSecurityStatus.jailbroken;

      final isDeveloperMode = await FlutterJailbreakDetection.developerMode;
      if (isDeveloperMode) return DeviceSecurityStatus.developerMode;

      return DeviceSecurityStatus.secure;
    } catch (_) {
      return DeviceSecurityStatus.secure;
    }
  }
}
