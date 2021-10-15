import 'package:get/get.dart';

class SittingsController extends GetxController {
  //TODO: Implement SittingsController

  final count = 0.obs;
  var username = ''.obs;
  @override
  void onInit() {
    username.value = Get.arguments['username'];
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
