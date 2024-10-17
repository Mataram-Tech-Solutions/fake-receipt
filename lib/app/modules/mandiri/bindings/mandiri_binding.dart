import 'package:get/get.dart';

import '../controllers/mandiri_controller.dart';

class MandiriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MandiriController>(
      () => MandiriController(),
    );
  }
}
