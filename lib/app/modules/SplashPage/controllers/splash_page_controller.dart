import 'package:get/get.dart';
import 'package:project_fake_receipt/app/modules/home/views/home_view.dart';

class SplashPageController extends GetxController {
 //TODO: Implement SplahsScreenController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    _navigateToNextPage();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _navigateToNextPage() {
    Future.delayed(const Duration(seconds: 5), () {
      print("Navigating to HomeView");
       Get.offAll(
        () => HomeView(),
        transition: Transition.upToDown, // Menambahkan animasi geser
        duration: const Duration(milliseconds: 1200), // Durasi animasi
      );
    });
  }
}

