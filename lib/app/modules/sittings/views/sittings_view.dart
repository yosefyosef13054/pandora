import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sittings_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SittingsView extends GetView<SittingsController> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(253, 252, 255, 1),
      // appBar: AppBar(
      //   title: Text('SittingsView'),
      //   centerTitle: true,
      // ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color.fromRGBO(253, 252, 255, 1),
        ),
        child: Column(
          children: [
            Container(
              height: height * .16,
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 70,
                    width: width,
                    color: Color.fromRGBO(255, 248, 243, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: SvgPicture.asset(
                                  'assets/images/backIcon.svg',
                                  placeholderBuilder: (BuildContext context) =>
                                      Container(
                                          padding: const EdgeInsets.all(30.0),
                                          child:
                                              const CircularProgressIndicator()),
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/images/smallFaceIcon.svg',
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                        padding: const EdgeInsets.all(30.0),
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
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/star.svg',
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                        padding: const EdgeInsets.all(30.0),
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
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              // margin: EdgeInsets.symmetric(vertical: 8),
              // height: 128,
              width: width * .87,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(44, 39, 124, 0.1),
                    blurRadius: 15,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Column(
                children: [
                  ItemListtile(
                    label: 'Notifications',
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  ItemListtile(
                    label: 'Profile Appearence',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              // margin: EdgeInsets.symmetric(vertical: 8),
              // height: 128,
              width: width * .87,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(44, 39, 124, 0.1),
                    blurRadius: 15,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Column(
                children: [
                  ItemListtile(
                    label: 'Log Out',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              // margin: EdgeInsets.symmetric(vertical: 8),
              // height: 128,
              width: width * .87,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(44, 39, 124, 0.1),
                    blurRadius: 15,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Column(
                children: [
                  ItemListtile(
                    label: 'Privacy Policy',
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  ItemListtile(
                    label: 'Terms of Conditions',
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  ItemListtile(
                    label: 'Feedback',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ItemListtile extends StatelessWidget {
  ItemListtile({
    this.label,
    Key key,
  }) : super(key: key);
  String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
              color: Color.fromRGBO(69, 55, 90, 1),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'NunitoSans'),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: SvgPicture.asset(
            label == 'Log Out'
                ? 'assets/images/logoutIcon.svg'
                : 'assets/images/rightarrow.svg',
            placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(30.0),
                child: const CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }
}
