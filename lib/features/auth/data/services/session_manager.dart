import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  final FlutterSecureStorage _secureStorage;

  static const _sessionDuration = Duration(hours: 24);
  static const _sensitiveDuration = Duration(minutes: 30);

  SessionManager({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  Future<bool> isSessionValid() async {
    final startStr = await _secureStorage.read(key: 'session_start');
    if (startStr == null) return false;

    final start = DateTime.tryParse(startStr);
    if (start == null) return false;
    return DateTime.now().difference(start) < _sessionDuration;
  }

  Future<bool> isSensitiveSessionValid() async {
    final startStr = await _secureStorage.read(key: 'session_start');
    if (startStr == null) return false;

    final start = DateTime.tryParse(startStr);
    if (start == null) return false;
    return DateTime.now().difference(start) < _sensitiveDuration;
  }

  Future<void> refreshSession() async {
    await _secureStorage.write(
      key: 'session_start',
      value: DateTime.now().toIso8601String(),
    );
  }

  Future<bool> validateAndRefresh({bool sensitive = false}) async {
    final valid = sensitive
        ? await isSensitiveSessionValid()
        : await isSessionValid();

    if (!valid) {
      await _secureStorage.deleteAll();
      return false;
    }

    await refreshSession();
    return true;
  }
}
