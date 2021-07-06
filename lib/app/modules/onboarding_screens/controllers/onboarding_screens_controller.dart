import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class OnboardingScreensController extends GetxController {
  ///sound to text vars

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
  var containerwidth = 20.0.obs;
  var containerheight = 4.0.obs;
  var color = Color.fromRGBO(215, 70, 239, 1).obs;
  final BorderRadiusGeometry borderRadius = BorderRadius.circular(8);
  final count = 0.obs;
  sethightandwidth(hight, width) {
    fullwidth.value = width;
    fullhight.value = hight;
  }

  @override
  void onInit() {
    speech = stt.SpeechToText();
    Future.delayed(Duration(seconds: 1), () {
      containerwidth.value = fullwidth.value * .25;
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
