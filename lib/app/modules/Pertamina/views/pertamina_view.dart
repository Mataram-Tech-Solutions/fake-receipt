import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_fake_receipt/app/modules/BluetoothSetting/controllers/bluetooth_setting_controller.dart';
import '../controllers/pertamina_controller.dart';

class PertaminaView extends StatefulWidget {
  @override
  _PertaminaViewState createState() => _PertaminaViewState();
}

class _PertaminaViewState extends State<PertaminaView> {
  final PertaminaController controller = Get.put(PertaminaController());
  final BluetoothSettingController bluetoothController = Get.put(BluetoothSettingController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c8d31),
      appBar: AppBar(
        backgroundColor: Color(0xff065a1e),
        title: Text(
          "Receipt Pertamina",
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
              _buildTextField("ID Nota", (value) => controller.idNota.value = value),
              _buildTextField("Alamat 1", (value) => controller.alamat1.value = value),
              _buildTextField("Alamat 2", (value) => controller.alamat2.value = value),
              _buildTextField("Shift", (value) => controller.shift.value = value),
              _buildTextField("No. Transaksi", (value) => controller.noTransaksi.value = value),
              _buildTextField("Tanggal", (value) => controller.tanggal.value = value),
              _buildTextField("Waktu", (value) => controller.waktu.value = value),
              _buildTextField("Pompa", (value) => controller.pompa.value = value),
              _buildTextField("Nama Produk", (value) => controller.namaProduk.value = value),
              _buildTextField("Harga/Liter", (value) => controller.hargaLiter.value = value),
              _buildTextField("Volume", (value) => controller.volume.value = value),
              _buildTextField("Total Harga", (value) => controller.totalHarga.value = value),
              _buildTextField("Operator", (value) => controller.operatorName.value = value),
              _buildTextField("Cash", (value) => controller.cash.value = value),
              _buildTextField("No. Plat", (value) => controller.noPlat.value = value),
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
