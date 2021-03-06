import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'home_controller.dart';

class RecordTime extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<int>(
        stream: controller.stopWatchTimer.rawTime,
        initialData: controller.stopWatchTimer.rawTime.value,
        builder: (context, snap) {
          if (snap.data == null) return CircularProgressIndicator();
          final value = snap.data;
          final displayTime = StopWatchTimer.getDisplayTime(value,
              hours: false, milliSecond: false);

          // RecordAudio.recordTime(displayTime);

          // if (RecordAudio.maxRecordTime.value == "02:00") {
          // RecordAudio.stopRecord();
          // Timer(Duration(seconds: 1), () {
          //   // print(RecordAudio.recordFilePath.value);
          //   RecordAudio.maxRecordTime("02:00");
          //   RecordAudio
          //       .sendAudio(
          //       RecordAudio.chatId.value,
          //       RecordAudio.recordFilePath.value,
          //       RecordAudio.replyMessageModal.value)
          //       .then((value) {
          //     RecordAudio.stopRecordInSocket();
          //   });
          // });
          // }
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recording",
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        displayTime.toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Image.asset(
                        'assets/images/voice.gif',
                        color: Colors.red,
                        width: 30,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
