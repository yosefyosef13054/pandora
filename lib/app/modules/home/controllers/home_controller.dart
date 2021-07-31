import 'dart:math';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pandora/app/modules/dio_api.dart';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../dio_api.dart';

class HomeController extends GetxController {
  final http = Get.find<HttpService>();
  stt.SpeechToText speech;
  var isListening = false.obs;
  var text = 'Press the button and start speaking'.obs;
  double confidence = 1.0;
  var confirmtext = false.obs;

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
        await speech.listen(
            listenFor: Duration(seconds: 10),
            onResult: (val) {
              text.value = val.recognizedWords;
              if (val.hasConfidenceRating && val.confidence > 0) {
                confidence = val.confidence;
              }
            });
        confirmtext.value = true;
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
    Future.delayed(Duration(seconds: 8), () {
      print(text.value);
      print(text.value.toString().substring(0));
      if (text.value.substring(0) == 'm') {
        print('mele');
      }
      confirmtext.value = true;
      print('done');
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
  //TODO: Implement HomeController

  final selected = 1.obs;
  void selectTap(value) => selected.value = value;

  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = new Random();

  var index = 0.obs;

  void changeIndex() {
    index.value = random.nextInt(5);
  }

  void submit(context) async {
    changeIndex();
    print(colors[index.value]);
    try {
      var response = await http.postUrl(
          'create/room', {"name": text.value, "color": index.value.toString()});
      print(response.data);

      //    SignUpRequest userdata = SignUpRequest.fromJson(response.data);

      Navigator.restorablePushReplacementNamed(context, '/home');
    } catch (e) {
      print(e);
    }
  }

  void show_send_voicenote_to_aroom(BuildContext ctx, width, height) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.transparent,
        context: ctx,
        builder: (ctx) => Container(
              width: 300,
              height: 200,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        child: Center(
                            child: Text(
                          'BR',
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'NunitoSans'),
                        )),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Color.fromRGBO(214, 223, 67, 1),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Barca - Real',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'NunitoSans'),
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          Text(
                            'Live',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(150, 143, 160, 1),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'NunitoSans'),
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: width,
                    height: 1,
                    color: Color.fromRGBO(227, 227, 227, 1),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        '302 Members',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(150, 143, 160, 1),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'NunitoSans'),
                      ),
                      Spacer(),
                      Text(
                        '302',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(150, 143, 160, 1),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'NunitoSans'),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.favorite,
                        color: Colors.grey,
                        size: 20,
                      )
                    ],
                  )
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

  @override
  void onInit() {
    speech = stt.SpeechToText();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void show_create_room(BuildContext ctx, width, height) {
    confirmtext.value = false;
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.transparent,
        context: ctx,
        builder: (ctx) => Container(
              height: 250,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(
                    height: 25,
                  ),
                  Obx(
                    () => confirmtext.value == false
                        ? Container(
                            height: 60,
                            width: width,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  top: 5,
                                  child: Container(
                                    height: 45,
                                    width: width * .85,
                                    decoration: BoxDecoration(
                                      // boxShadow: [
                                      //   // BoxShadow(
                                      //   //   color: Color.fromRGBO(44, 39, 124, 0.1),
                                      //   //   blurRadius: 15,
                                      //   //   offset: Offset(0, 0),
                                      //   // ),
                                      // ],
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(100),
                                          bottomRight: Radius.circular(100)),
                                      color: Color.fromRGBO(253, 252, 255, 1),
                                    ),
                                    child: Row(
                                      children: [
                                        Obx(() => Text(
                                              '${text.value}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromRGBO(
                                                      150, 143, 160, 1),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'NunitoSans'),
                                            )),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: InkWell(
                                    onTap: () => listen(),
                                    child: Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50),
                                          ),
                                          color:
                                              Color.fromRGBO(215, 70, 239, 1),
                                        ),
                                        child: Icon(
                                          isListening.value
                                              ? Icons.stop
                                              : Icons.mic,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                // Obx(
                                //   () => Positioned(
                                //     right: width * .2,
                                //     top: 0,
                                //     child: InkWell(
                                //             child: Container(
                                //                 height: 55,
                                //                 width: 55,
                                //                 decoration: BoxDecoration(
                                //                   borderRadius: BorderRadius.all(
                                //                     Radius.circular(50),
                                //                   ),
                                //                   color:
                                //                       Color.fromRGBO(215, 70, 239, 1),
                                //                 ),
                                //                 child: Icon(
                                //                   Icons.rotate_right_sharp,
                                //                   color: Colors.white,
                                //                 )),
                                //           )
                                //  ,
                                //   ),
                                // ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              InkWell(
                                onTap: () => listen(),
                                child: Container(
                                  // height: 55,
                                  // width: 150,
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.all(
                                  //     Radius.circular(50),
                                  //   ),
                                  //   color: Color.fromRGBO(215, 70, 239, 1),
                                  // ),
                                  child: Center(
                                    child: Text(
                                      '"${text.value}"',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'NunitoSans'),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      submit(ctx);
                                    },
                                    child: Container(
                                      height: 48,
                                      width: width * .35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                        color: Color.fromRGBO(215, 70, 239, 1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'CREATE',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'NunitoSans'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => listen(),
                                    child: Container(
                                      height: 48,
                                      width: width * .4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                        border: Border.all(
                                            color:
                                                Color.fromRGBO(215, 70, 239, 1),
                                            width: 2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'RECORD NEW',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromRGBO(
                                                  215, 70, 239, 1),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'NunitoSans'),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
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
