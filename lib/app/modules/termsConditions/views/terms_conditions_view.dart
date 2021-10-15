import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/terms_conditions_controller.dart';

class TermsConditionsView extends GetView<TermsConditionsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(215, 70, 239, 1),
        centerTitle: true,
        title: Text('TermsConditions'),
      ),
      body: Obx(
        () => controller.loading.value == true
            ? Container()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        controller.data.value,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
