import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:pandora/app/modules/onboarding_screens/controllers/signUpModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  void submit(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pushtoken = prefs.getString("pushtoken");
    print(pushtoken);
    try {
      var response = await http.postUrl('user/signup', {
        "username": slectedusername.value,
        "gender": slectedgender.value,
        "age": slectedage.value,
        "device_token": pushtoken
      });
      print(response.data);
      print(pushtoken);
      SignUpRequest userdata = SignUpRequest.fromJson(response.data);
      print(userdata.data.user.token);

      prefs.setString('token', userdata.data.user.token);
      Navigator.restorablePushReplacementNamed(context, '/home');
    } catch (e) {
      print(e.response.data);
    }
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

  void show_create_room(BuildContext ctx, width, height) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.transparent,
        context: ctx,
        builder: (ctx) => Container(
              width: 300,
              height: 1000,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              alignment: Alignment.center,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      listen();
                    },
                    child: Text(
                      'New Subject',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'NunitoSans'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  1 == 1
                      ? Text(
                          'Press and hold to say subject in maximum 3  words.',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(150, 143, 160, 1),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'NunitoSans'),
                        )
                      : Text(
                          'Please clarify the name of your room.',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(150, 143, 160, 1),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'NunitoSans'),
                        ),
                  Obx(
                    () => Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(
                              30.0, 30.0, 30.0, 150.0),
                          child: TextHighlight(
                            text: text.value,
                            words: highlights,
                            textStyle: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      // backgroundColor: Color.fromRGBO(215, 70, 239, 1),
                      onPressed: () => listen(),
                      icon: Container(
                          height: 200,
                          width: 200,
                          child: Icon(
                              isListening.value ? Icons.mic : Icons.mic_none)),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
                color: Color.fromRGBO(52, 51, 75, 1),
              ),
            ));
  }
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