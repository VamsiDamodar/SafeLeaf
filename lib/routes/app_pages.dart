import 'package:get/get.dart';
import 'package:safeleaf/modules/arrange_images/arrange_images_binding.dart';
import 'package:safeleaf/modules/arrange_images/arrange_images_view.dart';
import 'package:safeleaf/modules/auth/binding/biometric_binding.dart';
import 'package:safeleaf/modules/auth/binding/pin_lock_binding.dart';
import 'package:safeleaf/modules/auth/binding/pin_setup_binding.dart';
import 'package:safeleaf/modules/auth/view/biometric_view.dart';
import 'package:safeleaf/modules/auth/view/pin_lock_view.dart';
import 'package:safeleaf/modules/auth/view/pin_setup_view.dart';
import 'package:safeleaf/modules/document_details/document_details_binding.dart';
import 'package:safeleaf/modules/document_details/document_details_view.dart';
import 'package:safeleaf/modules/enhance_document_images/enhance_document_binding.dart';
import 'package:safeleaf/modules/enhance_document_images/enhance_document_image_view.dart';
import 'package:safeleaf/modules/home/binding/home_binding.dart';
import 'package:safeleaf/modules/home/view/home_view.dart';
import 'package:safeleaf/modules/preview/preview_document_binding.dart';
import 'package:safeleaf/modules/preview/preview_document_view.dart';
import 'package:safeleaf/modules/saving/saving_binding.dart';
import 'package:safeleaf/modules/saving/saving_view.dart';
import 'package:safeleaf/modules/splash/view/splash_view.dart';
import 'package:safeleaf/modules/splash/binding/splash_binding.dart';
import 'package:safeleaf/modules/upload_document/upload_document_binding.dart';
import 'package:safeleaf/modules/upload_document/upload_document_view.dart';
import 'package:safeleaf/routes/app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.PIN_SETUP,
      page: () => const PinSetupView(),
      binding: PinSetupBinding(),
    ),
    GetPage(
      name: Routes.BIOMETRIC_SETUP,
      page: () => const BiometricSetupView(),
      binding: BiometricSetupBinding(),
    ),
    GetPage(
      name: Routes.PIN_LOCK,
      page: () => const PinLockView(),
      binding: PinLockBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.UPLOAD_DOCUMENT,
      page: () => const UploadDocumentView(),
      binding: UploadDocumentBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: Routes.SAVING,
      page: () => const SavingView(),
      binding: SavingBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: Routes.PREVIEW_DOCUMENT,
      page: () => const PreviewDocumentView(),
      binding: PreviewDocumentBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: Routes.ENHANCE_DOCUMENT,
      page: () => const EnhanceDocumentView(),
      binding: EnhanceDocumentBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),

    GetPage(
      name: Routes.ARRANGE_IMAGES,
      page: () => const ArrangeImagesView(),
      binding: ArrangeImagesBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),

    GetPage(
      name: Routes.DOCUMENT_DETAILS,
      page: () => const DocumentDetailsView(),
      binding: DocumentDetailsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
  ];
}
