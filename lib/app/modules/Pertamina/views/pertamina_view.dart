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
final BluetoothSettingController bluetoothController = Get.find<BluetoothSettingController>();
  @override
  void initState() {
    super.initState();
    // controller.loadData(); // Muat data saat view diinisialisasi
  }

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
              _buildTextField("ID Nota", controller.idNota),
              _buildTextField("Alamat 1", controller.alamat1),
              _buildTextField("Alamat 2", controller.alamat2),
              _buildTextField("Shift", controller.shift),
              _buildTextField("No. Transaksi", controller.noTransaksi),
              _buildTextField("Tanggal", controller.tanggal),
              _buildTextField("Waktu", controller.waktu),
              _buildTextField("Pompa", controller.pompa),
              _buildTextField("Nama Produk", controller.namaProduk),
              _buildTextField("Harga/Liter", controller.hargaLiter),
              _buildTextField("Volume", controller.volume),
              _buildTextField("Total Harga", controller.totalHarga),
              _buildTextField("Operator", controller.operatorName),
              _buildTextField("Cash", controller.cash),
              _buildTextField("No. Plat", controller.noPlat),
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
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller, // Menggunakan controller untuk setiap field
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
      ),
    );
  }
}
