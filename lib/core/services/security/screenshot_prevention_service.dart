import 'dart:io';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class ScreenshotPreventionService {
  static Future<void> enable() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(
        FlutterWindowManager.FLAG_SECURE,
      );
    }
  }

  static Future<void> disable() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.clearFlags(
        FlutterWindowManager.FLAG_SECURE,
      );
    }
  }
}
