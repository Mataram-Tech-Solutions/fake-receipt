import 'dart:typed_data'; // Pastikan ini diimpor
import 'dart:io'; // Pastikan ini diimpor
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img; // Perbaiki menjadi yang benar
import 'package:path_provider/path_provider.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart'; // Pastikan Anda menggunakan library ESC/POS yang mendukung
import 'package:project_fake_receipt/app/modules/BluetoothSetting/controllers/bluetooth_setting_controller.dart';

class MandiriController extends GetxController {
  var alamat1 = ''.obs;
  var alamat2 = ''.obs;
  var alamat3 = ''.obs;
  var alamat4 = ''.obs;
  var tid = ''.obs;
  var mid = ''.obs;
  var cardType = ''.obs;
  var kode = ''.obs;
  var tanggal = ''.obs;
  var waktu = ''.obs;
  var batch = ''.obs;
  var trace = ''.obs;
  var rref = ''.obs;
  var appr = ''.obs;
  var prepaid = ''.obs;
  var denom = ''.obs;
  var charge = ''.obs;
  var total = ''.obs;
  var saldoAwal = ''.obs; // Mengganti nama dari operator menjadi operatorName
  var saldoAkhir = ''.obs;
  final BluetoothSettingController bluetoothController = Get.put(BluetoothSettingController());

  final count = 0.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> saveData() async {
    // Gunakan ukuran kertas 58mm
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    print("Status Koneksi: $connectionStatus");
    // print("ID Nota: ${idNota.value}");
    // print("Alamat 1: ${alamat1.value}");
    // print("Alamat 2: ${alamat2.value}");
    // print("Shift: ${shift.value}");
    // print("No. Transaksi: ${noTransaksi.value}");
    // print("Tanggal: ${tanggal.value}");
    // print("Waktu: ${waktu.value}");
    // print("Pulau/Pompa: ${pompa.value}");
    // print("Nama Produk: ${namaProduk.value}");
    // print("Harga/Liter: ${hargaLiter.value}");
    // print("Volume: ${volume.value}");
    // print("Total Harga: ${totalHarga.value}");
    // print("Operator: ${operatorName.value}");
    // print("Cash: ${cash.value}");
    // print("No. Plat: ${noPlat.value}");

    try {
      if (connectionStatus) {
        List<int> bytesToPrint = [];
        final profile = await CapabilityProfile.load();
        final generator = Generator(PaperSize.mm58, profile);
        bytesToPrint += generator.reset();

        final ByteData data = await rootBundle.load('assets/mandiri_print.png');
        final Uint8List bytes = data.buffer.asUint8List();

        // Decode image
        img.Image? originalImage = img.decodeImage(bytes);
        img.Image resizedImage = img.copyResize(originalImage!, height: 90);

        // Convert to PNG
        final Uint8List resizedBytes = img.encodePng(resizedImage);
        final directory = await getTemporaryDirectory();
        final String tempPath = '${directory.path}/resized_image.png';
        final File file = File(tempPath);
        await file.writeAsBytes(resizedBytes); // Pastikan Anda menggunakan File dari 'dart:io'

        // Print image
        await bluetoothController.printer.printImage(file.path);

        bytesToPrint += generator.text(
          alamat1.value, // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            fontType: PosFontType.fontB,
          ),
        );

        bytesToPrint += generator.text(
          alamat2.value, // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            fontType: PosFontType.fontB,
          ),
        );

        bytesToPrint += generator.text(
          alamat3.value, // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            fontType: PosFontType.fontB,
          ),
        );

        bytesToPrint += generator.text(
          alamat4.value, // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            fontType: PosFontType.fontB,
          ),
        );

        bytesToPrint += generator.text(
          'TID : ${tid.value}    MID :    ${mid.value}', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'CARD TYPE : ${cardType.value}                         ', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          '**** **** *** *** ${kode.value} (Swipe)            ', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size2, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'TOP-UP PREPAID                            ', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

         bytesToPrint += generator.text(
          'DATE : ${tanggal.value}      TIME :     ${waktu.value}', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );
        
         bytesToPrint += generator.text(
          'BATCH : ${batch.value}       TRACE:        ${trace.value}', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

         bytesToPrint += generator.text(
          'RREF# : ${rref.value}  APPR :      ${appr.value}', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.feed(1);

        bytesToPrint += generator.text(
          'PREPAID CARD    : ${prepaid.value}        ', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'DENOM           : Rp.             ${denom.value}', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'CHARGE          : Rp.                   ${charge.value}', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'TOTAL           : Rp.             ${total.value}', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );


        bytesToPrint += generator.text(
          '-------------------------------------------', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

         bytesToPrint += generator.text(
          'SALDO AWAL     : Rp.           ${saldoAwal.value}', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

         bytesToPrint += generator.text(
          'SALDO AKHIR    : Rp.           ${saldoAkhir.value}', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );



        bytesToPrint += generator.text(
          '= PIN VERIVICATION SUCCES =', // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'HARAP TANDA TERIMA INI DISIMPAN', // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'SEBAGAI BUKTI PEMBAYARAN YANG SAH', // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'CUSTOMER COPY                   MDR V6.1.0', // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

       

        // bytesToPrint += generator.feed(11); // Atau gunakan printNewLine() tergantung library
       bytesToPrint += generator.cut();

        // Kirim perintah ke printer
        await PrintBluetoothThermal.writeBytes(bytesToPrint);


        print("Data berhasil dicetak di printer.");
        await PrintBluetoothThermal.disconnect;
        await PrintBluetoothThermal.connect(macPrinterAddress: '66:32:20:59:77:3F');

        Get.snackbar('Succes', 'Berhasil print');
      } else {
        print("Printer tidak terhubung.");
      }
    } catch (e) {
      print("Error saat mencetak: $e");
    }
  }
}
