import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

enum BiometricResult {
  success,
  failed,
  notAvailable,
  notEnrolled,
  error,
}

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  Future<BiometricResult> authenticate({
    required String reason,
  }) async {
    try {
      if (!await isAvailable()) {
        return BiometricResult.notAvailable;
      }

      final authenticated = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );

      return authenticated
          ? BiometricResult.success
          : BiometricResult.failed;
    } on PlatformException catch (e) {
      if (e.code == 'NotEnrolled') {
        return BiometricResult.notEnrolled;
      }
      return BiometricResult.error;
    } catch (_) {
      return BiometricResult.error;
    }
  }
}
