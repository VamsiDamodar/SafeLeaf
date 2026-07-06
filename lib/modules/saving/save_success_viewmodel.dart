import 'dart:async';

import 'package:get/get.dart';
import 'package:safeleaf/routes/app_routes.dart';

class SaveSuccessViewModel extends GetxController {
  final progress = 0.0.obs;
  final isComplete = false.obs;
  final fileName = ''.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      fileName.value = (args['fileName'] as String?) ?? '';
    }
    _startProgressAnimation();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void onDoneTap() {
    Get.offAllNamed(Routes.HOME);
  }

  void _startProgressAnimation() {
    progress.value = 0.0;
    isComplete.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      final next = (progress.value + 0.05).clamp(0.0, 1.0);
      progress.value = next;

      if (next >= 1.0) {
        isComplete.value = true;
        timer.cancel();
      }
    });
  }
}
