import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_fake_receipt/app/modules/BluetoothSetting/controllers/bluetooth_setting_controller.dart';

import '../controllers/mandiri_controller.dart';

class MandiriView extends StatefulWidget {
  @override
  _MandiriViewState createState() => _MandiriViewState();
}

class _MandiriViewState extends State<MandiriView> {
  final MandiriController controller = Get.put(MandiriController());
  final BluetoothSettingController bluetoothController = Get.put(BluetoothSettingController());


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c8d31),
      appBar: AppBar(
        backgroundColor: Color(0xff065a1e),
        title: Text(
          "Receipt Mandiri TopUp",
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
              _buildTextField("Alamat 1", (value) => controller.alamat1.value = value),
              _buildTextField("Alamat 2", (value) => controller.alamat2.value = value),
              _buildTextField("Alamat 3", (value) => controller.alamat3.value = value),
              _buildTextField("Alamat 4", (value) => controller.alamat4.value = value),
              _buildTextField("TID", (value) => controller.tid.value = value),
              _buildTextField("MID", (value) => controller.mid.value = value),
              _buildTextField("Card Type", (value) => controller.cardType.value = value),
              _buildTextField("Kode", (value) => controller.kode.value = value),
              _buildTextField("Tanggal", (value) => controller.tanggal.value = value),
              _buildTextField("Waktu", (value) => controller.waktu.value = value),
              _buildTextField("Batch", (value) => controller.batch.value = value),
              _buildTextField("Trace", (value) => controller.trace.value = value),
              _buildTextField("RREF#", (value) => controller.rref.value = value),
              _buildTextField("APPR", (value) => controller.appr.value = value),
              _buildTextField("Prepaid Card", (value) => controller.prepaid.value = value),
              _buildTextField("Denom", (value) => controller.denom.value = value),
              _buildTextField("Charge", (value) => controller.charge.value = value),
              _buildTextField("Total", (value) => controller.total.value = value),
              _buildTextField("Saldo Awal", (value) => controller.saldoAwal.value = value),
              _buildTextField("Saldo Akhir", (value) => controller.saldoAkhir.value = value),
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
