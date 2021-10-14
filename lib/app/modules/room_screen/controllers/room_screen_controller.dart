import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:pandora/app/modules/room_screen/views/room_screen_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../dio_api.dart';
import 'package:dio/dio.dart' as dio;

class RoomScreenController extends GetxController {
  //TODO: Implement RoomScreenController
  final http = Get.find<HttpService>();
  var roomid;

  final count = 0.obs;

  static RxInt recordNum = RxInt(0);
  static RxString recordTime = RxString("");
  final StopWatchTimer stopWatchTimer = StopWatchTimer();
  Record _audioRecorder = Record();

  Future<bool> checkPermission() async {
    print("this is permaion ${!(await Permission.microphone.isGranted)}");
    bool hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      PermissionStatus status =
          await Permission.microphone.request().catchError((onError) {
        print("error from get permission$onError");
      });
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
    Directory storageDirectory = await getApplicationDocumentsDirectory();
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
    print("we have Permission $hasPermission");

    if (hasPermission) {
      print("we have Permission $hasPermission");
      recordFilePath.value = "";
      avaToPlayRecord.value = false;
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
      recordFilePath.value = await getFilePath();
      // print("This is Path: ${recordFilePath.value}");
      await _audioRecorder
          .start(
      )
          .catchError((error) {
        print("this is  $error");
      });
      isRecording.value = true;
    } else {
      // print("No microphone permission");
    }
  }

  //stop
  // var locationIds = List<CarYears>().obs;
  var assetsAudioPlayer = AssetsAudioPlayer().obs;

  stopRecord() async {
    _audioRecorder.stop();
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    // recording(false);
    // assetsAudioPlayer.value.open(
    //   Audio.file(recordFilePath.value),
    // );
    isRecording.value = false;
    avaToPlayRecord.value = true;
  }

  // List<AssetsAudioPlayer> audoioChatList = [];
  // List<String> paths = [];

  //for chate
  var paths = List<String>().obs;
  var assetsAudioPlayerlist = List<AssetsAudioPlayer>().obs;
  var durationList = List<Duration>().obs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initroom() async {
    roomid = Get.arguments['room_id'].toString();
    print(roomid);
    try {
      var response = await http.postUrl('room/users', {"room_id": roomid});
      print(response.data);

      //    SignUpRequest userdata = SignUpRequest.fromJson(response.data);

    } catch (e) {
      print(e);
    }

    FirebaseMessaging.onMessage.listen(
      (data) {
        print('onmassage');
        print('111111111111111');
        print(data.data['data']['url']);
        print('111111111111111');
        assetsAudioPlayerlist.add(AssetsAudioPlayer());
        paths.add(data.data['data']['url']);
        // durationList.add(_musicLength.value);
        return null;
      }, //onLaunch
    );
    // _firebaseMessaging.configure(onMessage: (data) {
    //   print('onmassage');
    //   print('111111111111111');
    //   print(data['data']['url']);
    //   print('111111111111111');
    //   assetsAudioPlayerlist.add(AssetsAudioPlayer());
    //   paths.add(data['data']['url']);
    //   // durationList.add(_musicLength.value);
    //   return null;
    // }, //onLaunch
    //     onLaunch: (data) {
    //   print(data);
    //   print('onLaunch');
    //   return null;
    // }, //onResume
    //     onResume: (data) {
    //   print(data);
    //   print('data');
    //   return null;
    // });
  }

  double uploading;
  var isuploading = false.obs;

  progressFn(int rec, int total) {
    uploading = (rec / total);
  }

  sendaudio(_musicLength) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String pushtoken = prefs.getString("token");
    // print(pushtoken);
    try {
      // isuploading.value = true;
      String fileName1 = recordFilePath.value.split('/').last;

      // print(int.parse(_musicLength.toString()));

      print('11111111111111');
      print(recordFilePath.value);
      print(fileName1);
      print(roomid);
      print('11111111111111');
      dio.FormData formData = await dio.FormData.fromMap({
        'room_id': roomid,
        'duration': 2,
        'message': await dio.MultipartFile.fromFile(recordFilePath.value,
            filename: fileName1),
      });

      // // print(uploadList.map((key, value) => value));
      var save = await http.postUrlUpload('send/message', formData,
          onSendProgress: progressFn, onRecieveProgress: progressFn);
      print(save.data);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error'.tr,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 0,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // isuploading.value = false;
      // print(e.response.data);
    }
    update();
  }

  @override
  void onInit() {
    initroom();
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

class AudioMessageComponents {
  static checkAudioPath(String message, AssetsAudioPlayer myPlayer,
      Rx<Duration> position, Rx<Duration> musicLength) async {
    if (message.contains('rumble')) {
      myPlayer.stop();
      myPlayer.open(
        Audio.file(message),
        showNotification: true,
      );
    } else {
      myPlayer.stop();
      await myPlayer.open(
        Audio.network(message, cached: true),
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
    if (path.contains('rumble')) {
      myPlayer[index].stop();
      myPlayer[index].open(
        Audio.file(path),
        showNotification: true,
      );
    } else {
      myPlayer[index].stop();
      await myPlayer[index].open(
        Audio.network(path, cached: true),
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

  static buildAudioButtonList(onTap, icon, index) => InkWell(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: Color.fromRGBO(215, 70, 239, 1),
          child: Icon(icon),
        ),
      );
}
