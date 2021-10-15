import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

class RecordAudio {
  static RxInt recordNum = RxInt(0);
  static RxString recordTime = RxString("");
  static RxString recordfilePath = RxString("");
  static final StopWatchTimer stopWatchTimer = StopWatchTimer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();

  static Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

   startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
      recordfilePath.value = await getFilePath();
      print("This is Path: ${recordfilePath.value}");
      await _mRecorder.startRecorder(
        toFile: recordfilePath.value,
        codec: Codec.aacMP4,
        audioSource: AudioSource.microphone, // by default
        bitRate: 128000,
      );
    } else {
      // print("No microphone permission");
    }
  }

   Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/rumble_${recordNum.value++}.mp3";
  }

   Future stopRecord(RxBool recording) async {
     _mRecorder.startRecorder();
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    recording(false);
    return true;
  }
}
