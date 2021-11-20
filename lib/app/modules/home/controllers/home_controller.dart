import 'dart:io';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pandora/app/modules/dio_api.dart';

import 'package:flutter/material.dart';

import 'package:highlight_text/highlight_text.dart';
import 'package:pandora/app/modules/home/controllers/recordtime.dart';
import 'package:pandora/app/modules/room_screen/views/position_seek_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:path_provider/path_provider.dart' as pathprovider;
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

import '../../dio_api.dart';
import 'homeModel.dart';
import 'package:dio/dio.dart' as dio;

class HomeController extends GetxController {
  final http = Get.find<HttpService>();

  stt.SpeechToText speech;
  var isListening = false.obs;
  var text = 'Record room name'.obs;
  double confidence = 1.0;
  var confirmtext = false.obs;
  HomeData data;
  var loading = false.obs;
  var autorefresh = false.obs;
  var username = ''.obs;
  Rx<IconData> playBtn = Icons.play_arrow.obs;
  Rx<Duration> _position = (Duration()).obs;
  Rx<Duration> _musicLength = (Duration()).obs;
  String recordTime = '';
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();

  getHomeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    username.value = prefs.getString('username');
    loading.value = true;
    try {
      var response = await http.get('home/rooms');
      print(response.data);
      data = HomeData.fromJson(response.data);
      loading.value = false;
      Future.delayed(Duration(seconds: 5), () {
        autoRefresh();
      });
    } catch (e) {}
    // await getcarYears(carModels[0].id);
    update();
  }

  autoRefresh() async {
    try {
      autorefresh.value = true;
      var response = await http.get('home/rooms');

      data = HomeData.fromJson(response.data);

      Future.delayed(Duration(seconds: 5), () {
        autoRefresh();
      });
      autorefresh.value = false;
    } catch (e) {}
    // await getcarYears(carModels[0].id);
    update();
  }

  Future<Null> reloadData() async {
    loading.value = true;
    try {
      var response = await http.get('home/rooms');
      print(response.data);
      data = HomeData.fromJson(response.data);
      loading.value = false;
    } catch (e) {}
    // await getcarYears(carModels[0].id);
    update();
  }

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
            listenFor: Duration(seconds: 4),
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

  List colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.pink,
    Colors.blue
  ];
  Random random = new Random();

  var index = 0.obs;

  void changeIndex() {
    index.value = random.nextInt(5);
  }

  void submit(context) async {
    changeIndex();
    // print(colors[index.value]);
    try {
      var response = await http.postUrl('create/room',
          {"name": text.value.toString(), "color": index.value.toString()});
      print(response.data);

      getHomeData();
      confirmtext.value = true;
      //    SignUpRequest userdata = SignUpRequest.fromJson(response.data);
      Navigator.pop(context);
      // Navigator.restorablePushReplacementNamed(context, '/home');
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                content: Text(
                    "sorry but there is room with this name already. ",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'NunitoSans')),
              ));

      print("e.response.data");
      print(e.response.data);
    }
  }

  void show_send_voicenote_to_aroom(
      BuildContext ctx, width, height, roomid, likes, members, name) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.transparent,
        context: ctx,
        builder: (ctx) => Obx(
              () => Container(
                width: 300,
                height: recordFilePath.value != "" ? 240 : 280,
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
                              name,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
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
                          '$members Members',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(150, 143, 160, 1),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'NunitoSans'),
                        ),
                        Spacer(),
                        Text(
                          likes.toString(),
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
                    ),
                    SizedBox(
                      height: recordFilePath.value != "" ? 40 : 10,
                    ),
                    Obx(
                      () => recordFilePath.value != ""
                          ? Container(
                              height: 60,
                              width: width * .85,
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 3,
                                    child: Container(
                                      height: 55,
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
                                        color: isRecording.value == false
                                            ? Color.fromRGBO(253, 252, 255, 1)
                                            : Color.fromRGBO(253, 252, 255, 1),
                                      ),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Obx(
                                              () => Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  isRecording.value == false
                                                      ? SizedBox()
                                                      : RecordTime(),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //Audio Player
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  avaToPlayRecord.value == false
                                      ? SizedBox()
                                      : Positioned(
                                          top: 10,
                                          width: width * .38,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  recordFilePath.value = "";
                                                  avaToPlayRecord(false);
                                                },
                                                child: CircleAvatar(
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 12,
                                                  ),
                                                  backgroundColor: Colors.red,
                                                  radius: 10,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Obx(() =>
                                                      AudioMessageComponents
                                                          .buildAudioButton(
                                                              () async {
                                                        if (playBtn.value ==
                                                            Icons.play_arrow) {
                                                          try {
                                                            playBtn.value = Icons
                                                                .pause_outlined;
                                                            assetsAudioPlayer
                                                                .value
                                                                .stop();
                                                            await AudioMessageComponents
                                                                .checkAudioPath(
                                                              recordFilePath
                                                                  .value,
                                                              assetsAudioPlayer
                                                                  .value,
                                                              _position,
                                                              _musicLength,
                                                            );
                                                          } catch (e) {
                                                            AudioMessageComponents
                                                                .onPlayRecordError(
                                                                    ctx);
                                                          }
                                                        } else {
                                                          playBtn.value =
                                                              Icons.play_arrow;
                                                          assetsAudioPlayer
                                                              .value
                                                              .stop();
                                                          // print("here2");
                                                        }

                                                        assetsAudioPlayer.value
                                                            .playlistAudioFinished
                                                            .listen((event) {
                                                          playBtn.value =
                                                              Icons.play_arrow;
                                                          _position =
                                                              Duration().obs;
                                                          _musicLength =
                                                              Duration().obs;
                                                        });
                                                      }, playBtn.value)),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                  Positioned(
                                    right: 0,
                                    bottom: 3,
                                    child: isRecording.value == false &&
                                            recordFilePath.value != ''
                                        ? InkWell(
                                            onTap: () async {
                                              try {
                                                // isuploading.value = true;
                                                String fileName1 =
                                                    recordFilePath.value
                                                        .split('/')
                                                        .last;

                                                // print(int.parse(_musicLength.toString()));

                                                double uploading;
                                                var isuploading = false.obs;
                                                progressFn(int rec, int total) {
                                                  uploading = (rec / total);
                                                }

                                                print('11111111111111');
                                                print(recordFilePath.value);
                                                print(fileName1);
                                                print(roomid);
                                                print('11111111111111');
                                                dio.FormData formData =
                                                    await dio.FormData.fromMap({
                                                  'room_id': roomid,
                                                  'duration': 2,
                                                  'message': await dio
                                                          .MultipartFile
                                                      .fromFile(
                                                          recordFilePath.value,
                                                          filename: fileName1),
                                                });

                                                // // print(uploadList.map((key, value) => value));
                                                var save =
                                                    await http.postUrlUpload(
                                                        'send/message',
                                                        formData,
                                                        onSendProgress:
                                                            progressFn,
                                                        onRecieveProgress:
                                                            progressFn);
                                                print(save.data);
                                              } catch (e) {
                                                Fluttertoast.showToast(
                                                    msg: 'Error'.tr,
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 0,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                // isuploading.value = false;
                                                // print(e.response.data);
                                              }
                                              update();
                                              Navigator.pop(ctx);
                                              recordFilePath.value = '';
                                              avaToPlayRecord(false);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      215, 70, 239, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  margin: EdgeInsets.all(8),
                                                  child: Icon(
                                                    Icons.send,
                                                    size: 25,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          )
                                        : isRecording.value == false
                                            ? InkWell(
                                                onTap: () => startRecord(),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          215, 70, 239, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      margin: EdgeInsets.all(8),
                                                      child: Icon(
                                                        Icons.mic,
                                                        size: 25,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  stopRecord();

                                                  //add to list
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          215, 70, 239, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      margin: EdgeInsets.all(8),
                                                      child: Icon(
                                                        Icons.stop,
                                                        size: 25,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                              ),
                                  ),
                                  Positioned(
                                    top: 18,
                                    left: width * .32,
                                    width: width * .35,
                                    child: Obx(() =>
                                        avaToPlayRecord.value == false
                                            ? SizedBox()
                                            : AudioMessageComponents
                                                .buildAudioSlider(
                                                    recordTime,
                                                    assetsAudioPlayer.value,
                                                    _musicLength.value,
                                                    _position.value)),
                                  ),
                                ],
                              ),
                            )
                          : AvatarGlow(
                              animate: true,
                              glowColor: Color.fromRGBO(215, 70, 239, 1),
                              endRadius: 65.0,
                              duration: const Duration(milliseconds: 2000),
                              repeatPauseDuration:
                                  const Duration(milliseconds: 100),
                              repeat: true,
                              child: FloatingActionButton(
                                backgroundColor:
                                    Color.fromRGBO(215, 70, 239, 1),
                                onPressed: () {
                                  print('add');
                                },
                                child: isRecording.value == false
                                    ? InkWell(
                                        onTap: () => startRecord(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  215, 70, 239, 1),
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Container(
                                              margin: EdgeInsets.all(10),
                                              child: Icon(
                                                Icons.mic,
                                                size: 22,
                                                color: Colors.white,
                                              )),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () => stopRecord(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  215, 70, 239, 1),
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Container(
                                              margin: EdgeInsets.all(10),
                                              child: Icon(
                                                Icons.stop,
                                                size: 22,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ),
                              ),
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
              ),
            ));
  }

  final count = 0.obs;
  final roomname = ''.obs;
  static RxInt recordNum = RxInt(0);
  final StopWatchTimer stopWatchTimer = StopWatchTimer();

  static Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  var recordFilePath = ''.obs;
  var isRecording = false.obs;
  var avaToPlayRecord = false.obs;

  static Future<String> getFilePath() async {
    Directory storageDirectory =
        await pathprovider.getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/rumble_${recordNum.value++}.mp3";
  }

  //start
  startRecord() async {
    print('test');
    bool hasPermission = await checkPermission();
    print('test');
    if (hasPermission) {
      recordFilePath.value = "";
      avaToPlayRecord(false);
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
      recordFilePath.value = await getFilePath();
      // print("This is Path: ${recordFilePath.value}");
      await _mRecorder.startRecorder(
        toFile: recordFilePath.value,
        codec: Codec.aacMP4,
        audioSource: AudioSource.microphone,
      );
      isRecording.value = true;
      Future.delayed(Duration(seconds: 30), () {
        stopRecord();
      });
    } else {
      // print("No microphone permission");
    }
  }

  //stop
  // var locationIds = List<CarYears>().obs;
  var assetsAudioPlayer = AssetsAudioPlayer().obs;

  stopRecord() async {
    await _mRecorder.startRecorder();
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    // recording(false);
    // assetsAudioPlayer.value.open(
    //   Audio.file(recordFilePath.value),
    // );
    isRecording.value = false;
    avaToPlayRecord.value = true;
  }

  @override
  void onInit() {
    speech = stt.SpeechToText();
    getHomeData();

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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'New Subject',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'NunitoSans'),
                      ),
                      SizedBox(
                        height: 20,
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
                    ],
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
                              isListening.value == true
                                  ? Image.asset(
                                      'assets/images/animatedRecord.gif',
                                      height: 50,
                                      width: 100,
                                    )
                                  : Container(
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
                                          '“${text.value}”',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'NunitoSans'),
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
                                  ),
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

class AudioMessageComponents {
  static checkAudioPath(String message, AssetsAudioPlayer myPlayer,
      Rx<Duration> position, Rx<Duration> musicLength) async {
    if (message.contains('https') == false) {
      myPlayer.stop();
      myPlayer.open(
        Audio.file(message),
        showNotification: true,
      );
    } else {
      myPlayer.stop();
      await myPlayer.open(
        Audio.network(
          message,
        ),
        showNotification: true,
      );
    }

    myPlayer.realtimePlayingInfos.listen((event) {
      // // print(event);
      position.value = event.currentPosition;
      musicLength.value = event.duration;
    });
  }

  static Widget buildAudioSlider(String recordTime, AssetsAudioPlayer myPlayer,
          Duration duration, Duration currentPosition) =>
      AudioSlider(recordTime, duration, currentPosition,
          Color.fromRGBO(215, 70, 239, 1), Get.theme.accentColor, (to) {
        myPlayer.seek(to);
      });

  static buildAudioButton(onTap, icon) => InkWell(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: Color.fromRGBO(215, 70, 239, 1),
          child: Icon(icon),
        ),
      );

  static onPlayRecordError(context) {
    Fluttertoast.showToast(
        msg: 'error',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 0,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static checkAudioPathList(String path, List<AssetsAudioPlayer> myPlayer,
      Rx<Duration> position, Rx<Duration> musicLength, index) async {
    if (path.contains('https') == false) {
      myPlayer[index].stop();
      myPlayer[index].open(
        Audio.file(path),
        showNotification: true,
      );
    } else {
      myPlayer[index].stop();
      await myPlayer[index].open(
        Audio.network(
          path,
        ),
        showNotification: true,
      );
    }

    myPlayer[index].realtimePlayingInfos.listen((event) {
      // // print(event);
      position.value = event.currentPosition;
      musicLength.value = event.duration;
    });
  }

  static Widget buildAudioSliderList(
          String recordTime,
          AssetsAudioPlayer myPlayer,
          Duration duration,
          Duration currentPosition,
          index) =>
      AudioSlider(recordTime, duration, currentPosition,
          Color.fromRGBO(215, 70, 239, 1), Get.theme.accentColor, (to) {
        myPlayer.seek(to);
      });
}

class AudioSlider extends StatelessWidget {
  AudioSlider(
      [this.recordTime,
      this.duration,
      this.currentPosition,
      this.buttonColor,
      this.sliderColor,
      this.seekTo]);

  Duration currentPosition, duration;
  Color sliderColor, buttonColor;
  String recordTime;
  Function seekTo;

  @override
  Widget build(BuildContext context) {
    return PositionSeekWidget(
      currentPosition: currentPosition ?? Duration(),
      sliderColor: sliderColor ?? Colors.grey[300],
      buttonColor: buttonColor ?? Colors.grey,
      recordTime: recordTime,
      duration: duration ?? Duration(),
      seekTo: (to) {
            seekTo(to);
          } ??
          (to) {},
    );
  }
}
