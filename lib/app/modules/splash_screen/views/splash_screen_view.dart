import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
      height: height,
      width: width,
      child: Image.asset(
        'assets/images/splashScreen.jpeg',
        fit: BoxFit.cover,
      ),
    ));
  }
}
