import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../dio_api.dart';

class OnboardingScreensController extends GetxController {
  ///sound to text vars
  final http = Get.find<HttpService>();
  stt.SpeechToText speech;
  var isListening = false.obs;
  var text = 'Press the button and start speaking'.obs;
  double confidence = 1.0;

  void listen() async {
    if (!isListening.value) {
      bool available = await speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          isListening.value = val == 'notListening' ? false : true;
          // Future.delayed(Duration(seconds: 2), () {
          //   if (text.value.substring(0) == 'm') {
          //     print('mele');
          //   }
          // });
          // if (isListening.value == false) {
          //   if (text.value.substring(0) == 'm') {
          //     print('mele');
          //   }
          // }
        },
        onError: (val) {
          isListening.value = false;
          print('onError: $val');
        },
      );
      if (available) {
        isListening.value = true;
        speech.listen(
            listenFor: Duration(seconds: 10),
            onResult: (val) {
              text.value = val.recognizedWords;
              if (val.hasConfidenceRating && val.confidence > 0) {
                confidence = val.confidence;
              }
            });
      }
    } else {
      isListening.value = false;
      speech.stop();
      // print(text.value);
      // Future.delayed(Duration(seconds: 2), () {
      //   if (text.value.substring(0) == 'm') {
      //     print('mele');
      //   }
      // });
    }
    Future.delayed(Duration(seconds: 7), () {
      print(text.value);
      print(text.value.toString().substring(0));
      if (text.value.substring(0) == 'm') {
        print('mele');
      }
    });
  }

  ///sound to text vars
  final Map<String, HighlightedWord> highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  //TODO: Implement OnboardingScreensController
  var maincolor = Color.fromRGBO(215, 70, 239, 1);
  var fullhight = 0.0.obs;
  var fullwidth = 0.0.obs;
  var containerwidth = 0.0.obs;
  var containerheight = 4.0.obs;
  var color = Color.fromRGBO(215, 70, 239, 1).obs;
  final BorderRadiusGeometry borderRadius = BorderRadius.circular(8);
  final count = 0.obs;
  sethightandwidth(hight, width) {
    fullwidth.value = width;
    fullhight.value = hight;
  }

  var page = 1.obs;
  List genderList = ['Male', 'Female', 'Prefer not to say'];
  List ageList = ['Young, Wild and Free 13 - 18', 'Adult 18 +', 'Old 30 +'];
  var usernames = List().obs;

  var slectedgender = ''.obs;
  var slectedage = ''.obs;
  var slectedusername = ''.obs;
  void setdata(value) {
    if (page.value == 1) {
      page.value = 2;
      slectedgender.value = value;
      containerwidth.value = fullwidth.value * .33;
    } else if (page.value == 2) {
      page.value = 3;
      slectedage.value = value;
      containerwidth.value = fullwidth.value * .33;
    } else if (page.value == 3 || page.value == 4) {
      print(value);
      slectedusername.value = value.toString();
      page.value = 4;
    }
  }

/////submit the data to the backnd
  void submit() async {
    var response = await http.postUrl('user/signup', {
      "username": slectedusername.value,
      "gender": slectedgender.value,
      "age": slectedage.value,
      "device_token": "adbjshgdfs"
    });

    print(response.data);
  }

  void getusersData() async {
    try {
      var response = await http.get('get/username');
      print(response.data);
      usernames.clear();
      await usernames.addAll(response.data['data']['usernames']);

      // AccessoriesHomeModel accessoriesHomeModel =
      //     AccessoriesHomeModel.fromJson(response.data);

    } catch (e) {}
    // await getcarYears(carModels[0].id);
    update();
  }

  @override
  void onInit() {
    getusersData();
    speech = stt.SpeechToText();
    Future.delayed(Duration(seconds: 1), () {
      containerwidth.value = fullwidth.value * .0;
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




//get
  // void getaccessoriesHome() async {
  //   loading.value = true;

  //   try {
  //     // ServiceSparePart/Search?regionId=${regionId.toString()}&carTypeId=${cartypeId.toString()}&modelId=${modelId.toString()}&yearId=${yearId.toString()}&areaId=0&pageIndex=0&pageSize=20
  //     var response = await http.get('Mobile/GetShopHome');
  //     print(response.data);
  //     AccessoriesHomeModel accessoriesHomeModel =
  //         AccessoriesHomeModel.fromJson(response.data);
  //     topSlide = accessoriesHomeModel.topSlider;
  //     newAccessories = accessoriesHomeModel.newAccessories;
  //     usedAccessories = accessoriesHomeModel.usedAccessories;

  //     loading.value = false;
  //   } catch (e) {
  //     // // print(e.response.data);
  //     //errooor
  //     // print(e);
  //     loading.value = false;
  //   }
  //   // await getcarYears(carModels[0].id);
  //   update();
  // }