import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:pandora/app/modules/home/controllers/roomModel.dart';
import 'package:pandora/app/modules/room_screen/views/room_screen_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../dio_api.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

class RoomScreenController extends GetxController {
  //TODO: Implement RoomScreenController
  final http = Get.find<HttpService>();
  var roomid;
  ScrollController scrollController = new ScrollController();

  final count = 0.obs;
  final roomname = ''.obs;
  static RxInt recordNum = RxInt(0);
  static RxString recordTime = RxString("");
  final StopWatchTimer stopWatchTimer = StopWatchTimer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();

  Future<bool> checkPermission() async {
    bool hasPermissionMicrophone = await Permission.microphone.isGranted;
    print("this is the permission of microphone ${!hasPermissionMicrophone}");
    if (!hasPermissionMicrophone) {
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
    bool hasPermission = await Permission.storage.isGranted;
    print("permission of storage$hasPermission");
    if (!hasPermission) {
      Permission.storage.request();
    }
    Directory storageDirectory = await getTemporaryDirectory();
    String sdPath = storageDirectory.path;
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/rumble_${recordNum.value++}.mp4";
  }

  //start  String _mPath = 'tau_file.mp4';
  startRecord() async {
    print('test');
    bool hasPermissionMicrophone = await checkPermission();

    print('test');
    if (!hasPermissionMicrophone) {
      recordFilePath.value = "";
      avaToPlayRecord.value = false;
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
      recordFilePath.value = await getFilePath();
      // print("This is Path: ${recordFilePath.value}");
      _mRecorder
          .startRecorder(
            toFile: recordFilePath.value,
            codec: Codec.aacMP4,
            audioSource: AudioSource.microphone,
          )
          .then((value) {})
          .catchError((onError) {
        print("this is error  $onError");
      });
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
    recordFilePath.value = await _mRecorder.stopRecorder();
    print(" here is the path after finish recording ${recordFilePath.value}");

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
    roomname.value = Get.arguments['room_name'].toString();
    print(roomid);
    try {
      var response =
          await http.postUrl('room/users', {"room_id": roomid, "in": 1});
      print(response.data);

      //    SignUpRequest userdata = SignUpRequest.fromJson(response.data);

      scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      print(e.response.data);
    }

    // FirebaseMessaging.onMessageOpenedApp.listen(
    //   (notification) {
    //     print('addadadadadadadadadadadadadadad');
    //     print(notification);
    //     Rx<Duration> _musicLength = (Duration()).obs;
    //     assetsAudioPlayerlist.insert(0, AssetsAudioPlayer());
    //     paths.insert(0, notification.data['data']['url'].toString());
    //     durationList.insert(0, _musicLength.value);
    //     // sendaudio(_musicLength.value);
    //     data.data.chats.insert(
    //         0,
    //         Chat(
    //             username: notification.data['data']['username'].toString(),
    //             createdAt: DateTime.parse(
    //                 notification.data['data']['created_at'].toString())));
    //     // data.data.chats.add(Chat(
    //     //     username: notification['data']['username'].toString(),
    //     //     createdAt:
    //     //         DateTime.parse(notification['data']['created_at'].toString())));
    //     // print('22222222222');
    //     // print(notification['data']['created_at'].toString());
    //     // print(paths.length);
    //     // print('22222222222');

    //     return null;
    //   }, //onLaunch
    // );

    FirebaseMessaging.onMessage.listen(
      (notification) {
        print('addadadadadadadadadadadadadadad');
        print(notification);
        Rx<Duration> _musicLength = (Duration()).obs;
        assetsAudioPlayerlist.insert(0, AssetsAudioPlayer());
        paths.insert(0, notification.data['data']['url'].toString());
        durationList.insert(0, _musicLength.value);
        // sendaudio(_musicLength.value);
        data.data.chats.insert(
            0,
            Chat(
                username: notification.data['data']['username'].toString(),
                createdAt: DateTime.parse(
                    notification.data['data']['created_at'].toString())));
        // data.data.chats.add(Chat(
        //     username: notification['data']['username'].toString(),
        //     createdAt:
        //         DateTime.parse(notification['data']['created_at'].toString())));
        // print('22222222222');
        // print(notification['data']['created_at'].toString());
        // print(paths.length);
        // print('22222222222');

        return null;
      }, //onLaunch
    );
  }

  double uploading;
  var isuploading = false.obs;

  progressFn(int rec, int total) {
    uploading = (rec / total);
  }

  RoomData data;
  var loading = false.obs;
  var username = ''.obs;

  void getroomData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username');
    loading.value = true;
    try {
      var response = await http.postUrl('show/room', {'id': roomid});
      print('111111111');
      print(response.data);
      print('111111111');
      data = RoomData.fromJson(response.data);
      data.data.chats.forEach((element) {
        Rx<Duration> _musicLength = (Duration()).obs;
        assetsAudioPlayerlist.add(AssetsAudioPlayer());
        paths.add(element.message.toString());
        durationList.add(_musicLength.value);
      });
      // data.data.chats.reversed.toList();
      loading.value = false;
    } catch (e) {
      print(e.response);
    }
    // await getcarYears(carModels[0].id);
    update();
  }

  var favorite = false.obs;
  var favoriteList = List().obs;

  likeAudio(id, index) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String pushtoken = prefs.getString("token");
    // print(pushtoken);
    try {
      // isuploading.value = true;

      // // print(uploadList.map((key, value) => value));
      var save = await http.postUrl(
        'favourite/message',
        {'room_chat_id': id},
      );
      print(save.data);
      print("here is sound object ${data.data.chats[index]}");
      data.data.chats[index].isFavourite = !data.data.chats[index].isFavourite;
      if (data.data.chats[index].isFavourite) {
        favoriteList.add(id);
      } else {
        favoriteList.remove(id);
      }
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

  var isreverse = true.obs;

  sendaudio(_musicLength) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String pushtoken = prefs.getString("token");
    // print(pushtoken);
    try {
      isuploading.value = true;
      String fileName1 = recordFilePath.value.split('/').last;

      // print(int.parse(_musicLength.toString()));

      print('11111111111111');
      print(recordFilePath.value);
      print(fileName1);
      print(roomid);
      print('11111111111111');
      dio.FormData formData = dio.FormData.fromMap({
        'room_id': roomid,
        'duration': 2,
      });
      print("before add file");
      formData.files.add(MapEntry(
        'message',
        await dio.MultipartFile.fromFile(recordFilePath.value,
            filename: fileName1),
      ));

      print("here before upload");
      // // print(uploadList.map((key, value) => value));
      var save = await http.postUrlUpload('send/message', formData,
          onSendProgress: progressFn, onRecieveProgress: progressFn);
      print(save.data);
      isuploading.value = false;

      recordFilePath.value = '';
      isreverse.value = false;
    } catch (e) {
      print("error from upload $e");
      // sendaudio(_musicLength);
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
    getroomData();
    initroom();
    _mRecorder.openAudioSession();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _mRecorder.closeAudioSession();
  }

  void increment() => count.value++;
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
