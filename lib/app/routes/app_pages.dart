import 'package:get/get.dart';

import '../modules/BluetoothSetting/bindings/bluetooth_setting_binding.dart';
import '../modules/BluetoothSetting/views/bluetooth_setting_view.dart';
import '../modules/JSB/bindings/jsb_binding.dart';
import '../modules/JSB/views/jsb_view.dart';
import '../modules/JSN/bindings/jsn_binding.dart';
import '../modules/JSN/views/jsn_view.dart';
import '../modules/JTJ/bindings/jtj_binding.dart';
import '../modules/JTJ/views/jtj_view.dart';
import '../modules/JTJindo/bindings/j_t_jindo_binding.dart';
import '../modules/JTJindo/views/j_t_jindo_view.dart';
import '../modules/Pertamina/bindings/pertamina_binding.dart';
import '../modules/Pertamina/views/pertamina_view.dart';
import '../modules/SplashPage/bindings/splash_page_binding.dart';
import '../modules/SplashPage/views/splash_page_view.dart';
import '../modules/TMJ/bindings/tmj_binding.dart';
import '../modules/TMJ/views/tmj_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/mandiri/bindings/mandiri_binding.dart';
import '../modules/mandiri/views/mandiri_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.BLUETOOTH_SETTING,
      page: () => BluetoothSettingPage(),
      binding: BluetoothSettingBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_PAGE,
      page: () => SplashScreenPage(),
      binding: SplashPageBinding(),
    ),
    GetPage(
      name: _Paths.PERTAMINA,
      page: () => PertaminaView(),
      binding: PertaminaBinding(),
    ),
    GetPage(
      name: _Paths.JSN,
      page: () => JSNView(),
      binding: JsnBinding(),
    ),
    GetPage(
      name: _Paths.TMJ,
      page: () => TMJView(),
      binding: TmjBinding(),
    ),
    GetPage(
      name: _Paths.JSB,
      page: () => JSBView(),
      binding: JsbBinding(),
    ),
    GetPage(
      name: _Paths.JTJ,
      page: () => JTJView(),
      binding: JtjBinding(),
    ),
    GetPage(
      name: _Paths.MANDIRI,
      page: () => MandiriView(),
      binding: MandiriBinding(),
    ),
    GetPage(
      name: _Paths.J_T_JINDO,
      page: () => JTJindoView(),
      binding: JTJindoBinding(),
    ),
  ];
}
