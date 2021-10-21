import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:pandora/app/modules/room_screen/views/position_seek_widget.dart';
import 'package:pandora/app/modules/room_screen/views/record.dart';

import '../controllers/room_screen_controller.dart';
import 'package:toast/toast.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoomScreenView extends GetView<RoomScreenController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Rx<IconData> playBtn = Icons.play_arrow.obs;
  Rx<Duration> _position = (Duration()).obs;
  Rx<Duration> _musicLength = (Duration()).obs;
  var format = DateFormat('HH:mm');

  //with pm and am
  //var format = DateFormat('HH:mm a');

  String recordTime = '';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        var response = await controller.http
            .postUrl('room/users', {"room_id": controller.roomid, "in": 0});

        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(240, 240, 248, 1),

        body: Obx(
          () => controller.loading.value == true
              ? Center(
                  child: SpinKitPulse(
                  color: Color.fromRGBO(215, 70, 239, 1),
                  size: 50.0,
                ))
              : Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(240, 240, 248, 1),
                  ),
                  child: SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Column(
                      children: [
                        Container(
                          height: height * .25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              InkWell(
                                onTap: () {
                                  // Get.toNamed('/sittings');
                                },
                                child: Container(
                                  height: 80,
                                  width: width,
                                  color: Color.fromRGBO(255, 248, 243, 1),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 25,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.arrow_back_ios)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 45,
                                            width: width * .6,
                                            child: Center(
                                              child: Text(
                                                controller.roomname.value,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'NunitoSans'),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'member',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    150, 143, 160, 1),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'NunitoSans'),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 48,
                                        width: 48,
                                        child: Center(
                                            child: Text(
                                          controller.roomname.value[0] +
                                              controller.roomname.value[2],
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'NunitoSans'),
                                        )),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          color:
                                              Color.fromRGBO(214, 223, 67, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: height * .64,
                          child: Obx(
                            () => ListView.builder(
                              controller: controller.scrollController,
                              shrinkWrap: true,
                              reverse: true,
                              // physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: controller.paths.length,
                              itemBuilder: (context, index) {
                                Rx<IconData> playBtn = Icons.play_arrow.obs;
                                Rx<Duration> _position = (Duration()).obs;
                                Rx<Duration> _musicLength = (Duration()).obs;
                                String recordTime = '';
                                var isfavorite = false.obs;
                                isfavorite.value = controller
                                    .data.data.chats[index].isFavourite;
                                return InkWell(
                                  onDoubleTap: () async {
                                    await controller.likeAudio(
                                        controller.data.data.chats[index].id,
                                        index);
                                    isfavorite.value = !isfavorite.value;
                                  },
                                  child: Container(
                                    width: width * .8,
                                    height: 75,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 14),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              135, 135, 135, 0.05),
                                          blurRadius: 10,
                                          offset: Offset(0, 7),
                                        ),
                                      ],
                                      borderRadius: controller.username.value ==
                                              controller.data.data.chats[index]
                                                  .username
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15))
                                          : BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomRight: Radius.circular(15)),
                                      color: controller.username.value ==
                                              controller.data.data.chats[index]
                                                  .username
                                          ? Color.fromRGBO(255, 139, 3, 1)
                                          : Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                    child: Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            // InkWell(
                                            //   onTap: () {
                                            //     controller.recordFilePath.value = "";
                                            //     controller.avaToPlayRecord(false);
                                            //   },
                                            //   child: CircleAvatar(
                                            //     child: Icon(
                                            //       Icons.close,
                                            //       size: 12,
                                            //     ),
                                            //     backgroundColor: Colors.red,
                                            //     radius: 10,
                                            //   ),
                                            // ),
                                            // SizedBox(
                                            //   width: 6,
                                            // ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  controller.username.value ==
                                                          controller
                                                              .data
                                                              .data
                                                              .chats[index]
                                                              .username
                                                      ? 'You'
                                                      : controller
                                                          .data
                                                          .data
                                                          .chats[index]
                                                          .username,
                                                  style: TextStyle(
                                                      color: controller.username
                                                                  .value ==
                                                              controller
                                                                  .data
                                                                  .data
                                                                  .chats[index]
                                                                  .username
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'NunitoSans'),
                                                ),
                                                SizedBox(
                                                  height: 3,
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
                                                              Icons
                                                                  .play_arrow) {
                                                            try {
                                                              playBtn.value = Icons
                                                                  .pause_outlined;
                                                              controller
                                                                  .assetsAudioPlayerlist[
                                                                      index]
                                                                  .stop();
                                                              await AudioMessageComponents
                                                                  .checkAudioPathList(
                                                                      controller
                                                                              .paths[
                                                                          index],
                                                                      controller
                                                                          .assetsAudioPlayerlist,
                                                                      _position,
                                                                      _musicLength,
                                                                      index);
                                                            } catch (e) {
                                                              AudioMessageComponents
                                                                  .onPlayRecordError(
                                                                      context);
                                                            }
                                                          } else {
                                                            playBtn.value =
                                                                Icons
                                                                    .play_arrow;
                                                            controller
                                                                .assetsAudioPlayerlist[
                                                                    index]
                                                                .stop();
                                                            // print("here2");
                                                          }

                                                          controller
                                                              .assetsAudioPlayerlist[
                                                                  index]
                                                              .playlistAudioFinished
                                                              .listen((event) {
                                                            playBtn.value =
                                                                Icons
                                                                    .play_arrow;
                                                            _position =
                                                                Duration().obs;
                                                            controller.durationList[
                                                                    index] =
                                                                Duration();
                                                          });
                                                        }, playBtn.value)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Obx(
                                              () =>
                                                  // controller.avaToPlayRecord.value == false
                                                  //     ? SizedBox()
                                                  //     :
                                                  Column(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  AudioMessageComponents
                                                      .buildAudioSlider(
                                                    recordTime,
                                                    controller
                                                            .assetsAudioPlayerlist[
                                                        index],
                                                    _musicLength.value,
                                                    _position.value,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                            top: 9,
                                            right: 9,
                                            child: Obx(
                                              () => InkWell(
                                                onTap: () async {
                                                  await controller.likeAudio(
                                                      controller.data.data
                                                          .chats[index].id,
                                                      index);
                                                  isfavorite.value =
                                                      !isfavorite.value;
                                                },
                                                child: Icon(
                                                  Icons.favorite,
                                                  color:
                                                      isfavorite.value == true
                                                          ? Colors.red
                                                          : Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                            )),
                                        Obx(
                                          () => Positioned(
                                              bottom: 9,
                                              right: 5,
                                              child: Text(
                                                  format
                                                      .format(controller
                                                          .data
                                                          .data
                                                          .chats[index]
                                                          .createdAt)
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: controller.username
                                                                  .value ==
                                                              controller
                                                                  .data
                                                                  .data
                                                                  .chats[index]
                                                                  .username
                                                          ? Colors.white
                                                          : Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'NunitoSans'))),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(
          () => controller.recordFilePath.value != ""
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
                            color: controller.isRecording.value == false
                                ? Color.fromRGBO(253, 252, 255, 1)
                                : Color.fromRGBO(253, 252, 255, 1),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Obx(
                                  () => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      controller.isRecording.value == false
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
                      controller.avaToPlayRecord.value == false
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
                                      controller.recordFilePath.value = "";
                                      controller.avaToPlayRecord(false);
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Obx(() => AudioMessageComponents
                                              .buildAudioButton(() async {
                                            if (playBtn.value ==
                                                Icons.play_arrow) {
                                              try {
                                                playBtn.value =
                                                    Icons.pause_outlined;
                                                controller
                                                    .assetsAudioPlayer.value
                                                    .stop();
                                                await AudioMessageComponents
                                                    .checkAudioPath(
                                                  controller
                                                      .recordFilePath.value,
                                                  controller
                                                      .assetsAudioPlayer.value,
                                                  _position,
                                                  _musicLength,
                                                );
                                              } catch (e) {
                                                AudioMessageComponents
                                                    .onPlayRecordError(context);
                                              }
                                            } else {
                                              playBtn.value = Icons.play_arrow;
                                              controller.assetsAudioPlayer.value
                                                  .stop();
                                              // print("here2");
                                            }

                                            controller.assetsAudioPlayer.value
                                                .playlistAudioFinished
                                                .listen((event) {
                                              playBtn.value = Icons.play_arrow;
                                              _position = Duration().obs;
                                              _musicLength = Duration().obs;
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
                        child: controller.isRecording.value == false &&
                                controller.recordFilePath.value != ''
                            ? InkWell(
                                onTap: () =>
                                    controller.sendaudio(_musicLength.value),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(215, 70, 239, 1),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: controller.isuploading.value == true
                                      ? CircularProgressIndicator()
                                      : Container(
                                          height: 38,
                                          width: 38,
                                          margin: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.send,
                                            size: 25,
                                            color: Colors.white,
                                          )),
                                ),
                              )
                            : controller.isRecording.value == false
                                ? InkWell(
                                    onTap: () => controller.startRecord(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(215, 70, 239, 1),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Container(
                                          height: 38,
                                          width: 38,
                                          margin: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.mic,
                                            size: 25,
                                            color: Colors.white,
                                          )),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      controller.stopRecord();
                                      //add to listdads
                                      // controller.assetsAudioPlayerlist
                                      //     .add(AssetsAudioPlayer());
                                      // controller.paths
                                      //     .add(controller.recordFilePath.value);
                                      // controller.durationList
                                      //     .add(_musicLength.value);
                                      //add to list
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(215, 70, 239, 1),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Container(
                                          height: 38,
                                          width: 38,
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
                            controller.avaToPlayRecord.value == false
                                ? SizedBox()
                                : AudioMessageComponents.buildAudioSlider(
                                    recordTime,
                                    controller.assetsAudioPlayer.value,
                                    _musicLength.value,
                                    _position.value)),
                      ),
                    ],
                  ),
                )
              : AvatarGlow(
                  animate: true,
                  glowColor: Color.fromRGBO(215, 70, 239, 1),
                  endRadius: 75.0,
                  duration: const Duration(milliseconds: 2000),
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  repeat: true,
                  child: FloatingActionButton(
                    backgroundColor: Color.fromRGBO(215, 70, 239, 1),
                    onPressed: () {
                      print('add');
                    },
                    child: controller.isRecording.value == false
                        ? InkWell(
                            onTap: () => controller.startRecord(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(215, 70, 239, 1),
                                  borderRadius: BorderRadius.circular(25)),
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
                            onTap: () => controller.stopRecord(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(215, 70, 239, 1),
                                  borderRadius: BorderRadius.circular(25)),
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

        // body: Obx(
        //   () => Center(
        //     child: Column(
        //       children: [
        //         Obx(
        //           () => Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               //Recoreder Icon( working )

        //               controller.isRecording.value == false
        //                   ? SizedBox()
        //                   : RecordTime(),
        //               //Recoreder Icon( working )
        //               SizedBox(
        //                 width: 20,
        //               ),
        //               //Image ICON
        //               // Container(
        //               //   decoration: BoxDecoration(
        //               //       color: AppColors
        //               //           .primaryColor,
        //               //       borderRadius:
        //               //           BorderRadius
        //               //               .circular(25)),
        //               //   child: Container(
        //               //       margin:
        //               //           EdgeInsets.all(10),
        //               //       child: Icon(
        //               //         Icons.camera_alt,
        //               //         size: 22,
        //               //         color: Colors.white,
        //               //       )),
        //               // ),
        //             ],
        //           ),
        //         ),
        //         //Audio Player
        //         // Obx(() => PlayerBuilder.currentPosition(
        //         //     player: controller
        //         //         .assetsAudioPlayer.value,
        //         //     builder: (context, duration) {
        //         //       return Text(duration.toString());
        //         //     })

        //         // ),
        //         SizedBox(
        //           height: 15,
        //         ),
        //         controller.avaToPlayRecord.value == false
        //             ? SizedBox()
        //             : Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                 children: [
        //                   InkWell(
        //                     onTap: () {
        //                       controller.recordFilePath.value = "";
        //                       controller.avaToPlayRecord(false);
        //                     },
        //                     child: CircleAvatar(
        //                       child: Icon(
        //                         Icons.close,
        //                         size: 12,
        //                       ),
        //                       backgroundColor: Colors.red,
        //                       radius: 10,
        //                     ),
        //                   ),
        //                   SizedBox(
        //                     width: 12,
        //                   ),
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       SizedBox(
        //                         height: 5,
        //                       ),
        //                       Obx(() => AudioMessageComponents.buildAudioButton(
        //                               () async {
        //                             if (playBtn.value == Icons.play_arrow) {
        //                               try {
        //                                 playBtn.value = Icons.pause_outlined;
        //                                 controller.assetsAudioPlayer.value.stop();
        //                                 await AudioMessageComponents
        //                                     .checkAudioPath(
        //                                   controller.recordFilePath.value,
        //                                   controller.assetsAudioPlayer.value,
        //                                   _position,
        //                                   _musicLength,
        //                                 );
        //                               } catch (e) {
        //                                 AudioMessageComponents.onPlayRecordError(
        //                                     context);
        //                               }
        //                             } else {
        //                               playBtn.value = Icons.play_arrow;
        //                               controller.assetsAudioPlayer.value.stop();
        //                               // print("here2");
        //                             }

        //                             controller.assetsAudioPlayer.value
        //                                 .playlistAudioFinished
        //                                 .listen((event) {
        //                               playBtn.value = Icons.play_arrow;
        //                               _position = Duration().obs;
        //                               _musicLength = Duration().obs;
        //                             });
        //                           }, playBtn.value)),
        //                       SizedBox(
        //                         width: 6,
        //                       ),
        //                       Obx(() => AudioMessageComponents.buildAudioSlider(
        //                           recordTime,
        //                           controller.assetsAudioPlayer.value,
        //                           _musicLength.value,
        //                           _position.value)),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //         SizedBox(
        //           height: 15,
        //         ),
        //         //Audio Player
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
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
      duration: duration ,
      seekTo: (to) {
            seekTo(to);
          } ??
          (to) {},
    );
  }
}
