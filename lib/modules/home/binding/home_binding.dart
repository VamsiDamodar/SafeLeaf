// lib/features/home/binding/home_binding.dart

import 'package:get/get.dart';
import 'package:safeleaf/modules/home/viewmodel/home_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}