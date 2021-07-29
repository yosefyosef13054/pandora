import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController

  final count = 0.obs;
  @override
  void onInit() async {
    String token = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    Future.delayed(Duration(seconds: 3), () {
      prefs.containsKey("token") == false
          ? Get.offNamed('/onboarding-screens')
          : Get.offNamed('/home');
      print('hello');
    });

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
