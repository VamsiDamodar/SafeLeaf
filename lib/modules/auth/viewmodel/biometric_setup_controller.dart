import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../routes/app_routes.dart';

class BiometricSetupController extends GetxController {
  final _localAuth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();

  /// Enable biometric authentication
  Future<void> enableBiometric() async {
    try {
      // Check if device supports biometric
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        Get.snackbar(
          'Not Available',
          'Biometric authentication is not available on this device',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        // Skip to home anyway
        _navigateToHome();
        return;
      }

      // Try to authenticate
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to enable biometric unlock',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        // Save biometric preference
        await _storage.write(key: 'safeleaf_biometric_enabled', value: 'true');
        
        Get.snackbar(
          'Success!',
          'Biometric unlock enabled',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        _navigateToHome();
      } else {
        // Authentication failed — stay on this screen
        Get.snackbar(
          'Failed',
          'Biometric authentication was not successful',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not enable biometric: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Skip biometric and go to home
  void skipBiometric() {
    _navigateToHome();
  }

  /// Navigate to home screen
  void _navigateToHome() {
    Get.offAllNamed(Routes.HOME);
  }
}