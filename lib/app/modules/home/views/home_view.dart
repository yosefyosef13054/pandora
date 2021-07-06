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

      body: Column(
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
                Obx(
                  () => InkWell(
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
                ),
                Obx(
                  () => InkWell(
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
                ),
                Obx(
                  () => InkWell(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
