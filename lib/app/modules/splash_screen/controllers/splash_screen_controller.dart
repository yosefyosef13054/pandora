import 'package:get/get.dart';
import 'package:pandora/app/modules/dio_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:auto_service_manager/app/services/socket_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:convert';

class SplashScreenController extends GetxController {
  final http = Get.find<HttpService>();
  //TODO: Implement SplashScreenController
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String pushToken;
  final count = 0.obs;
  @override
  void onInit() async {
    String token = "";
    var response =
        await http.appget('http://attendance.rmztech.net/api/application');
    if (response.data['application'] == 'true') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      pushToken = await _firebaseMessaging.getToken();

      /// token is auth tokne and pushtoken is firebasetoken
      token = prefs.getString("token");
      await prefs.setString('pushtoken', pushToken);
      Future.delayed(Duration(seconds: 1), () {
        prefs.containsKey("token") == false
            ? Get.offNamed('/onboarding-screens')
            : Get.offNamed('/home');
        print('hello');
        print(prefs.getString("token"));
        print(prefs.getString("pushtoken"));
      });
    } else {
      print('hello there ');
    }

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
