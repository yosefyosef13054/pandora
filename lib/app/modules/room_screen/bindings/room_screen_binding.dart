import 'package:get/get.dart';

import '../controllers/room_screen_controller.dart';

class RoomScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoomScreenController>(
      () => RoomScreenController(),
    );
  }
}
