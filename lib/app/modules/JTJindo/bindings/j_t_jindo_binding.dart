import 'package:get/get.dart';

import '../controllers/j_t_jindo_controller.dart';

class JTJindoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JtjindoController>(
      () => JtjindoController(),
    );
  }
}
