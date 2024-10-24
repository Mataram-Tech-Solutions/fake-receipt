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

class BluetoothSettingPage extends StatelessWidget {
  final BluetoothSettingController controller = Get.put(BluetoothSettingController());

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
              child: controller.devices.isNotEmpty
                  ? ListView.builder(
                itemCount: controller.devices.length,
                itemBuilder: (context, index) {
                  final device = controller.devices[index];
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
                      trailing: controller.isLoading.value
                          ? CircularProgressIndicator()
                          : Obx(() {
                            // Kondisi ketika perangkat terhubung
                            if (controller.isConnected.value && controller.connectedDevice?.address == device.address) {
                              return Column(
                                children: [
                                  ElevatedButton(
                                    key: ValueKey('TestPrintButton'),
                                    onPressed: controller.testPrint,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text('Test Print'),
                                  ),
                                  ElevatedButton(
                                    key: ValueKey('DisconnectButton'),
                                    onPressed: controller.disconnectFromDevice,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text('Disconnect'),
                                  ),
                                ],
                              );
                            } else {
                              // Tombol untuk menghubungkan perangkat
                              return ElevatedButton(
                                key: ValueKey('ConnectButton'),
                                onPressed: () async {
                                  await controller.connectToDevice(device);
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
