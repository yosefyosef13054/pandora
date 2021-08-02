import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('HomeView'),
      //   centerTitle: true,
      // ),

      body: Obx(
        () => controller.loading.value == true
            ? Center(child: CircularProgressIndicator())
            : Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(253, 252, 255, 1),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: height * .23,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed('/sittings');
                              },
                              child: Container(
                                height: 70,
                                width: width,
                                color: Color.fromRGBO(255, 248, 243, 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/smallFaceIcon.svg',
                                            placeholderBuilder: (BuildContext
                                                    context) =>
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30.0),
                                                    child:
                                                        const CircularProgressIndicator()),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'remy08',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/star.svg',
                                            placeholderBuilder: (BuildContext
                                                    context) =>
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30.0),
                                                    child:
                                                        const CircularProgressIndicator()),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            '100',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.selectTap(1);
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'TRENDS',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'NunitoSans'),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        controller.selected.value == 1
                                            ? Container(
                                                width: 56,
                                                height: 2,
                                                color: Color.fromRGBO(
                                                    215, 70, 239, 1),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.selectTap(2);
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'DISCOVER',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'NunitoSans'),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        controller.selected.value == 2
                                            ? Container(
                                                width: 56,
                                                height: 2,
                                                color: Color.fromRGBO(
                                                    215, 70, 239, 1),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.selectTap(3);
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'MY ROOMS',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'NunitoSans'),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        controller.selected.value == 3
                                            ? Container(
                                                width: 56,
                                                height: 2,
                                                color: Color.fromRGBO(
                                                    215, 70, 239, 1),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: height * .75,
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: controller.selected.value == 1
                                  ? controller.data.data.trendRooms.length
                                  : controller.selected.value == 2
                                      ? controller
                                          .data.data.discoverRooms.length
                                      : controller.data.data.myRooms.length,
                              itemBuilder: (context, index) {
                                var data = controller.selected.value == 1
                                    ? controller.data.data.trendRooms[index]
                                    : controller.selected.value == 2
                                        ? controller
                                            .data.data.discoverRooms[index]
                                        : controller.data.data.myRooms[index];

                                return InkWell(
                                  onTap: () {
                                    // Get.to(UsedAccessoriesDetailsView(
                                    //     url: controller.http.baseUrlForImages,
                                    //     item: controller.usedAccessories[index]));
                                    Get.toNamed('/room-screen',
                                        arguments: {'room_id': data.id});
                                  },
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      height: 128,
                                      width: 328,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                44, 39, 124, 0.1),
                                            blurRadius: 15,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 48,
                                                width: 48,
                                                child: Center(
                                                    child: Text(
                                                  data.name[0] + data.name[2],
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'NunitoSans'),
                                                )),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  color: Color.fromRGBO(
                                                      214, 223, 67, 1),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data.name,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            'NunitoSans'),
                                                  ),
                                                  SizedBox(
                                                    height: 9,
                                                  ),
                                                  Text(
                                                    'Live',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(
                                                            150, 143, 160, 1),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            'NunitoSans'),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  // Get.back();
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/images/playIcon.svg',
                                                  placeholderBuilder: (BuildContext
                                                          context) =>
                                                      Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(30.0),
                                                          child:
                                                              const CircularProgressIndicator()),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Container(
                                            width: width,
                                            height: 1,
                                            color: Color.fromRGBO(
                                                227, 227, 227, 1),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              // Container(
                                              //   width: 45,
                                              //   height: 30,
                                              //   child: Stack(
                                              //     children: [
                                              //       Positioned(
                                              //         left: 0,
                                              //         height: 24,
                                              //         width: 24,
                                              //         child: Image.asset(
                                              //             'assets/images/smallcircle1.png'),
                                              //       ),
                                              //       Positioned(
                                              //         top: 5,
                                              //         left: 15,
                                              //         height: 24,
                                              //         width: 24,
                                              //         child: Image.asset(
                                              //             'assets/images/smallcircle2.png'),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              Text(
                                                data.members.toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        150, 143, 160, 1),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'NunitoSans'),
                                              ),
                                              Spacer(),
                                              Text(
                                                '302',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        150, 143, 160, 1),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'NunitoSans'),
                                              ),
                                              SizedBox(width: 2),
                                              Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size: 20,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: true,
        glowColor: Color.fromRGBO(215, 70, 239, 1),
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          backgroundColor: Color.fromRGBO(215, 70, 239, 1),
          onPressed: () {
            controller.show_create_room(context, width, height);
            // controller.submit(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
