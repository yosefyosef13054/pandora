import 'package:get/get.dart';

import '../controllers/onboarding_screens_controller.dart';

class OnboardingScreensBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OnboardingScreensController>(
      OnboardingScreensController(),
    );
  }
}
