import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:auto_service_manager/app/services/socket_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:convert';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String pushToken;
  final count = 0.obs;
  @override
  void onInit() async {
    String token = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pushToken = await _firebaseMessaging.getToken();

    /// token is auth tokne and pushtoken is firebasetoken
    token = prefs.getString("token");
    await prefs.setString('pushtoken', pushToken);
    Future.delayed(Duration(seconds: 3), () {
      prefs.containsKey("token") == false
          ? Get.offNamed('/onboarding-screens')
          : Get.offNamed('/home');
      print('hello');
      print(prefs.getString("token"));
      print(prefs.getString("pushtoken"));
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
