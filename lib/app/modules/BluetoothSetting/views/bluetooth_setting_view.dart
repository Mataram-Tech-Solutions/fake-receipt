import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';  // Tambahkan ini untuk firstWhereOrNull
import '../controllers/bluetooth_setting_controller.dart';

class BluetoothSettingsPage extends StatefulWidget {
  @override
  _BluetoothSettingsPageState createState() => _BluetoothSettingsPageState();
}

class _BluetoothSettingsPageState extends State<BluetoothSettingsPage> {
  // Akses ke controller
  final BluetoothSettingController bluetoothController = Get.put(BluetoothSettingController());

  List<BluetoothDevice> devices = [];
  bool isLoading = false;
  String? connectedAddress;

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  Future<void> getDevices() async {
    try {
      devices = await bluetoothController.printer.getBondedDevices();
      setState(() {});
    } catch (e) {
      Get.snackbar('Error', 'Gagal mendapatkan perangkat');
    }
  }

  // Function untuk menghubungkan perangkat dan menyimpan koneksi
  Future<void> connectToDevice(BluetoothDevice device) async {
    setState(() {
      isLoading = true;
    });
    try {
      await bluetoothController.connectToDevice(device); // Gunakan controller untuk menghubungkan
      connectedAddress = device.address;
    } catch (e) {
      Get.snackbar('Error', 'Gagal terhubung');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function untuk memutuskan koneksi perangkat
  Future<void> disconnectFromDevice() async {
    setState(() {
      isLoading = true;
    });
    try {
      await bluetoothController.printer.disconnect();
      connectedAddress = null;
      Get.snackbar('Success', 'Berhasil memutuskan koneksi');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memutuskan koneksi');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function untuk mencetak test setelah koneksi berhasil
  Future<void> testPrint() async {
    try {
      if (await bluetoothController.printer.isConnected ?? false) {
        await bluetoothController.printer.printCustom('Printer Test By MATARAMTECH', 1, 1);

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
        await bluetoothController.printer.printImage(tempPath);
        for (int i = 0; i < 10; i++) {
          await bluetoothController.printer.printNewLine();
        }

        Get.snackbar('Success', 'Print test completed');
      } else {
        Get.snackbar('Error', 'Printer not connected');
      }
    } catch (e) {
      Get.snackbar('Error', 'Print failed: ${e.toString()}');
    }
  }

  // Menentukan icon berdasarkan tipe perangkat
  IconData getDeviceIcon(BluetoothDevice device) {
    if (device.name!.toLowerCase().contains('printer')) {
      return Icons.print; // Gunakan icon printer
    } else if (device.name!.toLowerCase().contains('phone')) {
      return Icons.phone_android; // Gunakan icon telepon
    }
    return Icons.device_unknown; // Gunakan icon generic untuk lainnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c8d31),
      appBar: AppBar(
        backgroundColor: Color(0xff065a1e),
        title: Text(
          "Bluetooth Connection Setting",
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: devices.isNotEmpty
                  ? ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: Color(0xff065a1e),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Icon(
                        getDeviceIcon(device),
                        color: Colors.white,
                        size: 40,
                      ),
                      title: Text(
                        device.name ?? "Unknown Device",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        device.address ?? "Unknown Address",
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                        ),
                      ),
                      trailing: isLoading
                          ? CircularProgressIndicator()
                          : Obx(() {
                            // Kondisi ketika perangkat terhubung
                            if (bluetoothController.isConnected.value && bluetoothController.connectedDevice?.address == device.address) {
                              return Column(
                                children: [
                                  ElevatedButton(
                                    key: ValueKey('TestPrintButton'),
                                    onPressed: testPrint,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text('Test Print'),
                                  ),
                                  // ElevatedButton(
                                  //   key: ValueKey('DisconnectButton'),
                                  //   onPressed: disconnectFromDevice,
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: Colors.red,
                                  //     padding: EdgeInsets.symmetric(
                                  //       horizontal: 20,
                                  //       vertical: 12,
                                  //     ),
                                  //   ),
                                  //   child: Text('Disconnect'),
                                  // ),
                                ],
                              );
                            } else {
                              // Tombol untuk menghubungkan perangkat
                              return ElevatedButton(
                                key: ValueKey('ConnectButton'),
                                onPressed: () async {
                                  await connectToDevice(device);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text('Connect'),
                              );
                            }
                          }),
                    ),
                  );
                },
              )
                  : Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
