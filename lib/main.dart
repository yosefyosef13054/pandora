import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pandora/app/modules/dio_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:auto_service_manager/app/services/socket_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:convert';

void main() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => HttpService().init());
  //uncomment
  await Firebase.initializeApp();
  //uncomment
  // String token = "";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // token = prefs.getString("token");

  runApp(
    GetMaterialApp(
      title: "Application",
      theme: ThemeData(
          // primarySwatch: Colors.yellow,
          fontFamily: 'Cairo'
          // visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
