import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class RecordAudio {
  static RxInt recordNum = RxInt(0);
  static RxString recordTime = RxString("");
  static RxString recordfilePath = RxString("");
  static final StopWatchTimer stopWatchTimer = StopWatchTimer();
  final _audioRecorder = Record();

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
      await _audioRecorder.start(
        path: recordfilePath.value, // required
        encoder: AudioEncoder.AAC, // by default
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
    _audioRecorder.stop();
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    recording(false);
    return true;
  }
}
