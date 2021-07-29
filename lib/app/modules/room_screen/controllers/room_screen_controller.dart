import 'package:get/get.dart';
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:pandora/app/modules/room_screen/views/room_screen_view.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class RoomScreenController extends GetxController {
  //TODO: Implement RoomScreenController

  final count = 0.obs;

  static RxInt recordNum = RxInt(0);
  static RxString recordTime = RxString("");
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
    if (hasPermission) {
      recordFilePath.value = "";
      avaToPlayRecord(false);
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
      recordFilePath.value = await getFilePath();
      // print("This is Path: ${recordFilePath.value}");
      await Record.start(
        path: recordFilePath.value, // required
        encoder: AudioEncoder.AAC, // by default
        bitRate: 128000,
      );
      isRecording.value = true;
    } else {
      // print("No microphone permission");
    }
  }

  //stop
  // var locationIds = List<CarYears>().obs;
  var assetsAudioPlayer = AssetsAudioPlayer().obs;

  stopRecord() async {
    Record.stop();
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

  @override
  void onInit() {
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
    Toast.show("audio-error-tittle".tr, context);
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
