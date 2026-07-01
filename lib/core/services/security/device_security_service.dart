import 'dart:io';
import 'package:flutter/services.dart';

enum DeviceSecurityStatus {
  secure,
  jailbroken,
  developerMode,
}

class DeviceSecurityService {
  static const _channel = MethodChannel('com.codra.shatabha/security');

  Future<DeviceSecurityStatus> checkDeviceSecurity() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final bool isJailbroken = await _channel.invokeMethod('isJailbroken') ?? false;
        if (isJailbroken) return DeviceSecurityStatus.jailbroken;

        final bool isDevMode = await _channel.invokeMethod('isDeveloperMode') ?? false;
        if (isDevMode) return DeviceSecurityStatus.developerMode;
      }
      return DeviceSecurityStatus.secure;
    } catch (_) {
      return DeviceSecurityStatus.secure;
    }
  }
}
