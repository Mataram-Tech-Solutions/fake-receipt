import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class BluetoothSettingController extends GetxController {
  var isConnected = false.obs;
  BluetoothDevice? connectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<BluetoothDevice> devices = [];
  var isLoading = false.obs;
  RxString connectedAddress = ''.obs; // Observable String

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getDevices();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }
  
  void increment() => count.value++;

  Future<void> getDevices() async {
    try {
      var bondedDevices = await printer.getBondedDevices();
      devices.assignAll(bondedDevices);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mendapatkan perangkat');
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      isLoading.value = true;
      await printer.connect(device); // Connect using BlueThermalPrinter
      connectedAddress.value = device.address!;
      isConnected.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal terhubung');
    } finally {
      isLoading.value = false;
    }
  }

 Future<void> disconnectFromDevice() async {
    try {
      isLoading.value = true; // Set status loading menjadi true
      await printer.disconnect(); // Memutuskan koneksi
      connectedAddress.value = ''; // Mengosongkan alamat perangkat
      isConnected.value = false; // Set status connected menjadi false
      Get.snackbar('Success', 'Berhasil memutuskan koneksi'); // Tampilkan notifikasi sukses
    } catch (e) {
      Get.snackbar('Error', 'Gagal memutuskan koneksi');
    } finally {
      isLoading.value = false; // Set status loading menjadi false setelah selesai
    }
  }

  Future<void> testPrint() async {
    try {
      if (await printer.isConnected ?? false) {
        await printer.printCustom('Printer Test By MATARAMTECH', 1, 1);

        // Load image from assets
        final ByteData data = await rootBundle.load('assets/logo.png');
        final Uint8List bytes = data.buffer.asUint8List();

        // Decode image
        img.Image? originalImage = img.decodeImage(bytes);
        img.Image resizedImage = img.copyResize(originalImage!, height: 250, width: 250);

        // Convert to PNG
        final Uint8List resizedBytes = img.encodePng(resizedImage);
        final directory = await getTemporaryDirectory();
        final String tempPath = '${directory.path}/resized_image.png';
        final File file = File(tempPath);
        await file.writeAsBytes(resizedBytes);

        // Print image
        await printer.printImage(tempPath);
        for (int i = 0; i < 10; i++) {
          await printer.printNewLine();
        }

        Get.snackbar('Success', 'Print test completed');
      } else {
        Get.snackbar('Error', 'Printer not connected');
      }
    } catch (e) {
      Get.snackbar('Error', 'Print failed: ${e.toString()}');
    }
  }
}
