import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:safeleaf/routes/app_routes.dart';

class PinSetupController extends GetxController {
  static const int pinLength = 4;
  static const String _pinStorageKey = 'safeleaf_pin';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final RxString enteredPin = ''.obs;
  final RxString _createdPin = ''.obs;
  final RxBool isConfirmStep = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool showError = false.obs;
  final RxInt shakeKey = 0.obs;

  String get title =>
      isConfirmStep.value ? 'Confirm your PIN' : 'Create your PIN';

  String get subtitle {
    if (showError.value) {
      return 'PINs do not match. Try again.';
    }

    return isConfirmStep.value
        ? 'Re-enter the 4-digit PIN to make sure it matches.'
        : 'Set a 4-digit PIN to protect your SafeLeaf vault.';
  }

  int get filledDots => enteredPin.value.length;

  void onNumberPressed(String number) {
    if (isSaving.value || enteredPin.value.length >= pinLength) return;

    _clearErrorIfNeeded();
    enteredPin.value = '${enteredPin.value}$number';

    if (enteredPin.value.length == pinLength) {
      _handleCompletedPin();
    }
  }

  void onDeletePressed() {
    if (isSaving.value || enteredPin.value.isEmpty) return;

    _clearErrorIfNeeded();
    enteredPin.value =
        enteredPin.value.substring(0, enteredPin.value.length - 1);
  }

  void _clearErrorIfNeeded() {
    if (showError.value) {
      showError.value = false;
    }
  }

  Future<void> _handleCompletedPin() async {
    if (!isConfirmStep.value) {
      _createdPin.value = enteredPin.value;
      await Future.delayed(const Duration(milliseconds: 180));
      enteredPin.value = '';
      isConfirmStep.value = true;
      return;
    }

    if (enteredPin.value != _createdPin.value) {
      await _handlePinMismatch();
      return;
    }

    await _savePin();
  }

  Future<void> _handlePinMismatch() async {
    showError.value = true;
    shakeKey.value++;

    await Future.delayed(const Duration(milliseconds: 500));
    enteredPin.value = '';
    // showError ni ikkada false cheyyakudadhu
    // user malli input icche varaku red state alane untundi
  }

  Future<void> _savePin() async {
    isSaving.value = true;

    try {
      await _storage.write(
        key: _pinStorageKey,
        value: enteredPin.value,
      );
      Get.offNamed(Routes.BIOMETRIC_SETUP);
    } catch (_) {
      isSaving.value = false;
      showError.value = true;
      shakeKey.value++;
    }
  }
}