import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_fake_receipt/app/modules/BluetoothSetting/controllers/bluetooth_setting_controller.dart';

import '../controllers/j_t_jindo_controller.dart';

class JTJindoView extends StatefulWidget {
  @override
  _JTJindoViewState createState() => _JTJindoViewState();
}

class _JTJindoViewState extends State<JTJindoView> {
  final JtjindoController controller = Get.put(JtjindoController());
  final BluetoothSettingController bluetoothController = Get.put(BluetoothSettingController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c8d31),
      appBar: AppBar(
        backgroundColor: Color(0xff065a1e),
        title: Text(
          "Receipt Jasamarga Transjawa",
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField("Asal 1", (value) => controller.asal1.value = value),
              _buildTextField("Tanggal", (value) => controller.tanggal.value = value),
              _buildTextField("Waktu", (value) => controller.waktu.value = value),
              _buildTextField("Kode", (value) => controller.kode.value = value),
              _buildTextField("No. Seri", (value) => controller.noSeri.value = value),
              // _buildTextField("Asal", (value) => controller.asal2.value = value),
              _buildTextField("Type", (value) => controller.type.value = value),
              _buildTextField("Harga", (value) => controller.harga.value = value),
              _buildTextField("Serial Number", (value) => controller.serialNumber.value = value),
              _buildTextField("Sisa Saldo", (value) => controller.sisaSaldo.value = value),
              _buildTextField("Peringatan", (value) => controller.peringatan.value = value),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff065a1e),
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: IconTheme(
          data: IconThemeData(color: Colors.white),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.print, size: 30),
                onPressed: () {
                  // Kirim data ke controller
                  controller.saveData();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Fungsi untuk membangun TextFormField untuk setiap input
  Widget _buildTextField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: onChanged, // Simpan input ke controller
      ),
    );
  }
}