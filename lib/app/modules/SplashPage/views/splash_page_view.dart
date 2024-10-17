import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_page_controller.dart'; // Pastikan untuk mengimpor SplashController

class SplashScreenPage extends StatelessWidget {
  final SplashPageController controller = Get.put(SplashPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Pastikan file gambar berada di folder 'assets'
          width: 200, // Atur ukuran gambar sesuai kebutuhan
        ),
      ),
    );
  }
}