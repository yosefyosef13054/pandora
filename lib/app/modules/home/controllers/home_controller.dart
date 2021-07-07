import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final selected = 1.obs;
  void selectTap(value) => selected.value = value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
