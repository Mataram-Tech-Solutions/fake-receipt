import 'package:get/get.dart';

import '../controllers/jtj_controller.dart';

class JtjBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JtjController>(
      () => JtjController(),
    );
  }
}
