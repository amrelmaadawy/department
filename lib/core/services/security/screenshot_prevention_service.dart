import 'dart:io';
import 'package:flutter/services.dart';

class ScreenshotPreventionService {
  static const _channel = MethodChannel('com.codra.shatabha/security');

  static Future<void> enable() async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await _channel.invokeMethod('enableSecure');
      } catch (_) {}
    }
  }

  static Future<void> disable() async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await _channel.invokeMethod('disableSecure');
      } catch (_) {}
    }
  }
}
