import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/onboarding_screens_controller.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class OnboardingScreensView extends GetView<OnboardingScreensController> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    controller.sethightandwidth(height, width);

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      //talk to text
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => Theme(
          data: Theme.of(context)
              .copyWith(highlightColor: Color.fromRGBO(215, 70, 239, 1)),
          child: AvatarGlow(
            animate: controller.isListening.value,
            glowColor: Color.fromRGBO(215, 70, 239, 1),
            endRadius: 75.0,
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: FloatingActionButton(
              backgroundColor: Color.fromRGBO(215, 70, 239, 1),
              onPressed: () =>
                  controller.show_create_room(context, width, height),
              child: Icon(
                  controller.isListening.value ? Icons.mic : Icons.mic_none),
            ),
          ),
        ),
      ),
      //talk to text

      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: Text(
                  'Rumpel',
                  style: TextStyle(
                      //    color: Colors.yellow[700],
                      color: Color.fromRGBO(239, 201, 0, 1),
                      //   color: Theme.of(context).primaryColor,
                      fontSize: 61,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'BerkshireSwash'),
                ),
              ),
              SizedBox(
                height: height * .032,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    Obx(
                      () => AnimatedContainer(
                        // Use the properties stored in the State class.
                        width: controller.page.value == 1
                            ? width * .0
                            : controller.page.value == 2
                                ? width * .33
                                : controller.page.value == 3
                                    ? width * .66
                                    : width,
                        height: controller.containerheight.value,
                        decoration: BoxDecoration(
                          color: controller.color.value,
                          borderRadius: controller.borderRadius,
                        ),
                        // Define how long the animation should take.
                        duration: Duration(seconds: 1),
                        // Provide an optional curve to make the animation feel smoother.
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/images/leftImage.png',
                  ),
                  Text(
                      controller.page.value == 1
                          ? 'Gender'
                          : controller.page.value == 2
                              ? 'AGE'
                              : 'Username',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'NunitoSans')),
                  Image.asset(
                    'assets/images/rightImage.png',
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              //page 1 and 2 only
              SingleChildScrollView(
                child: Container(
                  height: height * .4,
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Obx(() => InkWell(
                              onTap: () {
                                // controller.submit();
                                // Navigator.pushNamed(context, '/home');
                                controller.setdata(controller.page.value == 1
                                    ? controller.genderList[index]
                                    : controller.page.value == 2
                                        ? controller.ageList[index]
                                        : controller.usernames[index]);
                                controller.containerwidth.value = width * .33;
                              },
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 15),
                                  height: 56,
                                  width: width * .85,
                                  child: Center(
                                    child: Text(
                                        controller.page.value == 1
                                            ? controller.genderList[index]
                                            : controller.page.value == 2
                                                ? controller.ageList[index]
                                                : controller.usernames[index],
                                        style: TextStyle(
                                            color: controller.page.value == 2
                                                ? Color.fromRGBO(
                                                    16, 182, 182, 1)
                                                : controller.page.value == 3 ||
                                                        controller.page.value ==
                                                            4
                                                    ? Color.fromRGBO(
                                                        255, 139, 3, 1)
                                                    : Colors.pink,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'NunitoSans')),
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: controller.page.value == 3 &&
                                                  controller.slectedusername
                                                          .value ==
                                                      ''
                                              ? Colors.white
                                              : controller.page.value == 4 &&
                                                      controller.slectedusername
                                                              .value ==
                                                          controller
                                                              .usernames[index]
                                                  ? Color.fromRGBO(
                                                      198, 190, 209, 1)
                                                  : controller.page.value ==
                                                              4 &&
                                                          controller
                                                                  .slectedusername
                                                                  .value !=
                                                              controller
                                                                      .usernames[
                                                                  index]
                                                      ? Colors.white
                                                      : Color.fromRGBO(
                                                          198, 190, 209, 1),
                                          width: 2),
                                      // color: Color.fromRGBO(198, 190, 209, 1),
                                      borderRadius: BorderRadius.circular(24)),
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  controller.getusersData();
                },
                child: AnimatedContainer(
                  height:
                      controller.page.value != 3 && controller.page.value != 4
                          ? 0
                          : 90,
                  width:
                      controller.page.value != 3 && controller.page.value != 4
                          ? 0
                          : 80,
                  duration: Duration(milliseconds: 500),
                  child: SvgPicture.asset('assets/images/rerollBox.svg',
                      placeholderBuilder: (BuildContext context) => Obx(
                            () => AnimatedContainer(
                                height: controller.page.value != 3 &&
                                        controller.page.value != 4
                                    ? 0
                                    : 150,
                                width: controller.page.value != 3 &&
                                        controller.page.value != 4
                                    ? 0
                                    : 80,
                                duration: Duration(milliseconds: 500),
                                padding: const EdgeInsets.all(30.0),
                                child: const CircularProgressIndicator()),
                          )),
                ),
              ),
              AnimatedContainer(
                height: controller.page.value != 3 && controller.page.value != 4
                    ? 0
                    : 30,
                width: controller.page.value != 3 && controller.page.value != 4
                    ? 0
                    : width,
                duration: Duration(milliseconds: 500),
                child: Center(
                  child: Text('tap here to generate another',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'NunitoSans')),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  controller.page.value == 4
                      ? controller.submit(context)
                      : null;
                },
                child: AnimatedContainer(
                  height:
                      controller.page.value != 3 && controller.page.value != 4
                          ? 0
                          : 48,
                  width:
                      controller.page.value != 3 && controller.page.value != 4
                          ? 0
                          : 180,
                  duration: Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(215, 70, 239,
                          controller.slectedusername != '' ? 1 : .5),
                      borderRadius: BorderRadius.circular(24)),
                  child: Center(
                    child: Text('GO!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'NunitoSans')),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              //talk to text
              Obx(
                () => Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                      child: TextHighlight(
                        text: controller.text.value,
                        words: controller.highlights,
                        textStyle: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
