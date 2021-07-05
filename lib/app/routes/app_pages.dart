import 'package:get/get.dart';

import 'package:pandora/app/modules/home/bindings/home_binding.dart';
import 'package:pandora/app/modules/home/views/home_view.dart';
import 'package:pandora/app/modules/onboarding_screens/bindings/onboarding_screens_binding.dart';
import 'package:pandora/app/modules/onboarding_screens/views/onboarding_screens_view.dart';
import 'package:pandora/app/modules/splash_screen/bindings/splash_screen_binding.dart';
import 'package:pandora/app/modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_SCREENS,
      page: () => OnboardingScreensView(),
      binding: OnboardingScreensBinding(),
    ),
  ];
}
