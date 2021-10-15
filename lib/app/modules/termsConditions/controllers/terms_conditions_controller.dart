import 'package:get/get.dart';
import 'package:pandora/app/modules/dio_api.dart';

class TermsConditionsController extends GetxController {
  final http = Get.find<HttpService>();
  var loading = false.obs;
  var data = ''.obs;
  //TODO: Implement TermsConditionsController
  void getData() async {
    loading.value = true;
    try {
      var response = await http.get('termsconditions');

      data.value = response.data['data']['termsConditions'].toString();
      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
    // await getcarYears(carModels[0].id);
    update();
  }

  final count = 0.obs;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
