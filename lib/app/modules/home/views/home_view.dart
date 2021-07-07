import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

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

      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color.fromRGBO(253, 252, 255, 1),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Container(
                height: 70,
                width: width,
                color: Color.fromRGBO(16, 182, 182, 0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Image.asset('assets/images/smallFaceIcon.png'),
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
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Image.asset('assets/images/Vector.png'),
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
              SizedBox(
                height: 32,
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  color: Color.fromRGBO(215, 70, 239, 1),
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
                                  color: Color.fromRGBO(215, 70, 239, 1),
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
                                  color: Color.fromRGBO(215, 70, 239, 1),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: height * .7,
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Get.to(UsedAccessoriesDetailsView(
                            //     url: controller.http.baseUrlForImages,
                            //     item: controller.usedAccessories[index]));
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
                                    color: Color.fromRGBO(44, 39, 124, 0.1),
                                    blurRadius: 20,
                                    offset: Offset(0, 3),
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
                                          'BR',
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
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                color: Color.fromRGBO(
                                                    150, 143, 160, 1),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'NunitoSans'),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Image.asset(
                                          'assets/images/playButton.png'),
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
                                      Container(
                                        width: 45,
                                        height: 30,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 0,
                                              height: 24,
                                              width: 24,
                                              child: Image.asset(
                                                  'assets/images/smallcircle1.png'),
                                            ),
                                            Positioned(
                                              top: 5,
                                              left: 15,
                                              height: 24,
                                              width: 24,
                                              child: Image.asset(
                                                  'assets/images/smallcircle2.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '302 Members',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromRGBO(
                                                150, 143, 160, 1),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'NunitoSans'),
                                      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: true,
        glowColor: Color.fromRGBO(239, 201, 0, 1),
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: () {
            print('add');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
