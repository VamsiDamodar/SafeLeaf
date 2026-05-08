import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:safeleaf/routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final RxDouble progressValue = 0.0.obs;
  final RxString loadingText = 'Initializing...'.obs;
  final RxBool showContent = false.obs;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final List<String> _messages = const [
    'Initializing...',
    'Loading your vault...',
    'Securing your data...',
    'Almost ready...',
  ];

  @override
  void onReady() {
    super.onReady();
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    await Future.delayed(const Duration(milliseconds: 100));

    FlutterNativeSplash.remove();
    showContent.value = true;

    for (int i = 0; i < _messages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      loadingText.value = _messages[i];
      progressValue.value = (i + 1) / _messages.length;
    }

    await Future.delayed(const Duration(milliseconds: 400));
    await _navigate();
  }

  Future<void> _navigate() async {
    final pin = await _storage.read(key: 'safeleaf_pin');

    if (pin != null && pin.isNotEmpty) {
      Get.offAllNamed(Routes.PIN_LOCK);
      return;
    }

    Get.offAllNamed(Routes.PIN_SETUP);
  }
}
