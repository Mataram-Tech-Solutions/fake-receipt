import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_page_controller.dart'; // Pastikan untuk mengimpor SplashController

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final SplashPageController controller = Get.put(SplashPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                height: 250,
                width: 250,
                child: Image.asset(
                  'assets/logo2.png',
                  fit: BoxFit.cover,
                ))));
  }
}