import 'package:get/get.dart';

import '../controllers/pertamina_controller.dart';

class PertaminaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PertaminaController>(
      () => PertaminaController(),
    );
  }
}
