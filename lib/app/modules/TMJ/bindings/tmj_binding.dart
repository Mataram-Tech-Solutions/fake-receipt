import 'package:get/get.dart';

import '../controllers/tmj_controller.dart';

class TmjBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TmjController>(
      () => TmjController(),
    );
  }
}
