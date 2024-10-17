import 'package:get/get.dart';

import '../controllers/jsn_controller.dart';

class JsnBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JsnController>(
      () => JsnController(),
    );
  }
}
