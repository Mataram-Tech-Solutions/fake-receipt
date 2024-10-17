import 'package:get/get.dart';

import '../controllers/jsb_controller.dart';

class JsbBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JsbController>(
      () => JsbController(),
    );
  }
}
