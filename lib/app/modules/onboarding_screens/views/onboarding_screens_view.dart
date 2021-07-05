import 'package:flutter/material.dart';

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => AvatarGlow(
          animate: controller.isListening.value,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: controller.listen,
            child:
                Icon(controller.isListening.value ? Icons.mic : Icons.mic_none),
          ),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: Text(
                  'Pandora',
                  style: TextStyle(
                      color: controller.maincolor,
                      fontSize: 61,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Chewy'),
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
                    AnimatedContainer(
                      // Use the properties stored in the State class.
                      width: controller.containerwidth.value,
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
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/images/leftImage.png',
                  ),
                  Text('Gender',
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
                height: 60,
              ),
              Center(
                child: Container(
                  height: 56,
                  width: 240,
                  child: Center(
                    child: Text('Male',
                        style: TextStyle(
                            color: Colors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'NunitoSans')),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(198, 190, 209, 1), width: 2),
                      // color: Color.fromRGBO(198, 190, 209, 1),
                      borderRadius: BorderRadius.circular(24)),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Center(
                child: Container(
                  height: 56,
                  width: 240,
                  child: Center(
                    child: Text('Female',
                        style: TextStyle(
                            color: Colors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'NunitoSans')),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(198, 190, 209, 1), width: 2),
                      // color: Color.fromRGBO(198, 190, 209, 1),
                      borderRadius: BorderRadius.circular(24)),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Center(
                child: Container(
                  height: 56,
                  width: 240,
                  child: Center(
                    child: Text('Prefer not to say',
                        style: TextStyle(
                            color: Colors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'NunitoSans')),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(198, 190, 209, 1), width: 2),
                      // color: Color.fromRGBO(198, 190, 209, 1),
                      borderRadius: BorderRadius.circular(24)),
                ),
              ),
              SizedBox(
                height: 32,
              ),
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
