import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:local_auth/local_auth.dart';

class AppSecurity {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Blocks screenshots on Android
  static Future<void> enableSecureMode() async {
    try {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (e) {
      // Handle iOS screenshot logic or errors
    }
  }

  /// App Lock Mechanism
  static Future<bool> authenticateUser() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Scan fingerprint to access FAIR ADDA',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );
    } catch (e) {
      return false;
    }
  }
}