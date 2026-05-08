import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:safeleaf/routes/app_routes.dart';

class PinLockController extends GetxController {
  static const int pinLength = 4;
  static const String _pinStorageKey = 'safeleaf_pin';
  static const String _biometricKey = 'safeleaf_biometric_enabled';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  final RxString enteredPin = ''.obs;
  final RxBool isUnlocking = false.obs;
  final RxBool showError = false.obs;
  final RxInt shakeKey = 0.obs;
  final RxBool isBiometricEnabled = false.obs;

  String get title => 'Enter your PIN';

  String get subtitle => showError.value
      ? 'Incorrect PIN. Please try again.'
      : 'Enter your 4-digit PIN to unlock SafeLeaf.';

  int get filledDots => enteredPin.value.length;

  @override
  void onInit() {
    super.onInit();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final enabled = await _storage.read(key: _biometricKey);
    isBiometricEnabled.value = enabled == 'true';
  }

  void onNumberPressed(String number) {
    if (isUnlocking.value || enteredPin.value.length >= pinLength) return;

    _clearErrorIfNeeded();
    enteredPin.value = '${enteredPin.value}$number';

    if (enteredPin.value.length == pinLength) {
      _validatePin();
    }
  }

  void onDeletePressed() {
    if (isUnlocking.value || enteredPin.value.isEmpty) return;

    _clearErrorIfNeeded();
    enteredPin.value =
        enteredPin.value.substring(0, enteredPin.value.length - 1);
  }

  void _clearErrorIfNeeded() {
    if (showError.value) {
      showError.value = false;
    }
  }

  Future<void> _validatePin() async {
    isUnlocking.value = true;

    try {
      final savedPin = await _storage.read(key: _pinStorageKey);

      if (savedPin == enteredPin.value) {
        Get.offAllNamed(Routes.HOME);
        return;
      }

      await _handleInvalidPin();
    } catch (_) {
      await _handleInvalidPin();
    } finally {
      isUnlocking.value = false;
    }
  }

  Future<void> authenticateWithBiometric() async {
    if (!isBiometricEnabled.value || isUnlocking.value) return;

    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        return;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock SafeLeaf',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        Get.offAllNamed(Routes.HOME);
        return;
      }

      await _handleInvalidPin();
    } catch (_) {
      await _handleInvalidPin();
    }
  }

  Future<void> _handleInvalidPin() async {
    showError.value = true;
    shakeKey.value++;

    await Future.delayed(const Duration(milliseconds: 500));
    enteredPin.value = '';
  }
}