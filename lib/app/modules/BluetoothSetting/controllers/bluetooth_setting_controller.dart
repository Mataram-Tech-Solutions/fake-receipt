import 'package:get/get.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class BluetoothSettingController extends GetxController {
  // Observable untuk menyimpan status koneksi Bluetooth secara global
  var isConnected = false.obs;
  BluetoothDevice? connectedDevice; // Perangkat Bluetooth yang terhubung
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void onInit() {
    super.onInit();
  }

  // Method untuk menyimpan perangkat yang terhubung secara global
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await printer.connect(device);
      isConnected.value = true; // Update status koneksi
      connectedDevice = device; // Simpan perangkat yang terhubung
      String mac = device.address ?? 'Unknown MAC'; // Jika address null, gunakan nilai default
      print('Alamat MAC: $mac');
      final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
      update(); // Trigger UI update di semua halaman yang menggunakan controller ini
    } catch (e) {
      isConnected.value = false;
      connectedDevice = null;
      Get.snackbar('Error', 'Gagal menyambungkan perangkat');
    }
  }

  // Method untuk memutuskan koneksi
  Future<void> disconnectDevice() async {
    try {
      await printer.disconnect();
      isConnected.value = false; // Update status koneksi
      connectedDevice = null; // Hapus perangkat yang terhubung
      update();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memutuskan perangkat');
    }
  }

  @override
  void onClose() {
    // Memutuskan koneksi saat controller ditutup
    // disconnectDevice(); // Panggil metode untuk memutuskan koneksi
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
