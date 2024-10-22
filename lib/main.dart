import 'package:flutter/material.dart';

import 'package:get/get.dart';
// import 'package:project_fake_receipt/app/modules/BluetoothSetting/controllers/bluetooth_setting_controller.dart';

import 'app/routes/app_pages.dart';

void main() {
    // Get.put(BluetoothSettingController());

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
