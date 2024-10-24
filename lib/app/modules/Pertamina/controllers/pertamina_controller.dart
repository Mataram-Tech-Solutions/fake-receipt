import 'dart:typed_data'; // Pastikan ini diimpor
import 'dart:io'; // Pastikan ini diimpor
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img; // Perbaiki menjadi yang benar
import 'package:path_provider/path_provider.dart';
import 'package:project_fake_receipt/app/modules/BluetoothSetting/controllers/bluetooth_setting_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PertaminaController extends GetxController {
 var idNota = TextEditingController();
  var alamat1 = TextEditingController();
  var alamat2 = TextEditingController();
  var shift = TextEditingController();
  var noTransaksi = TextEditingController();
  var tanggal = TextEditingController();
  var waktu = TextEditingController();
  var pompa = TextEditingController();
  var namaProduk = TextEditingController();
  var hargaLiter = TextEditingController();
  var volume = TextEditingController();
  var totalHarga = TextEditingController();
  var operatorName = TextEditingController();
  var cash = TextEditingController();
  var noPlat = TextEditingController();

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
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    try {
      if (connectionStatus) {
        List<int> bytesToPrint = [];
        final profile = await CapabilityProfile.load();
        final generator = Generator(PaperSize.mm58, profile);
        bytesToPrint += generator.reset();

        final ByteData data = await rootBundle.load('assets/pertamina_print.png');
        final Uint8List bytes = data.buffer.asUint8List();

        // Decode image
        img.Image? originalImage = img.decodeImage(bytes);
        img.Image resizedImage = img.copyResize(originalImage!, height: 60, width: 174);

        // Convert to PNG
        final Uint8List resizedBytes = img.encodePng(resizedImage);
        final directory = await getTemporaryDirectory();
        final String tempPath = '${directory.path}/resized_image.png';
        final File file = File(tempPath);
        await file.writeAsBytes(resizedBytes); // Pastikan Anda menggunakan File dari 'dart:io'

        // Print image
        await bluetoothController.printer.printImage(file.path);

        bytesToPrint += generator.text(
          idNota.text, // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          alamat1.text, // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          alamat2.text, // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'Shift : ${shift.text}    No. Trans : ${noTransaksi.text}', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'Waktu : ${tanggal.text}  ${waktu.text}   ', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          '------------------------------', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        String pompaText = pompa.text.length == 1
            ? 'Pulau/Pompa : ${pompa.text}                '  // Tambahkan 1 spasi ekstra untuk 1 digit
            : 'Pulau/Pompa : ${pompa.text}               ';  // Jika 2 digit, gunakan jumlah spasi biasa

        bytesToPrint += generator.text(
          pompaText, // Teks yang disesuaikan dengan panjang nilai pompa
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        int totalLength = 31; // Misal total panjang karakter yang diinginkan adalah 40

        // Hitung jumlah karakter yang ada setelah "Nama Produk : "
        String baseText = 'Nama Produk : ';
        int spaceLength = totalLength - (baseText.length + namaProduk.text.length);

        // Jika jumlah spasi negatif (karena namaProduk.text terlalu panjang), setel ke 0
        spaceLength = spaceLength > 0 ? spaceLength : 0;

        // Buat string spasi dengan panjang yang dihitung
        String spaces = ' ' * spaceLength;

        // Gabungkan teks akhir dengan spasi
        String finalText = 'Nama Produk : ${namaProduk.text}$spaces';

        bytesToPrint += generator.text(
          finalText, // Teks dengan spasi yang disesuaikan
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        String hargaLiterText = hargaLiter.text.length == 5
            ? 'Harga/Liter : Rp. ${hargaLiter.text}        '  // Tambahkan 1 spasi ekstra untuk 5 digit
            : 'Harga/Liter : Rp. ${hargaLiter.text}       ';  // Jika 6 digit, gunakan jumlah spasi biasa

        bytesToPrint += generator.text(
          hargaLiterText, // Teks yang disesuaikan dengan panjang nilai pompa
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        int totalvolLength = 30; // Misal total panjang karakter yang diinginkan adalah 40
        String basevolText = 'Volume      : (L)';
        int spacevolLength = totalvolLength - (basevolText.length + volume.text.length);

        // Jika jumlah spasi negatif (karena namaProduk.text terlalu panjang), setel ke 0
        spacevolLength = spacevolLength > 0 ? spacevolLength : 0;

        // Buat string spasi dengan panjang yang dihitung
        String spacesvol = ' ' * spacevolLength;

        // Gabungkan teks akhir dengan spasi
        String finalvolText = 'Volume      : (L) ${volume.text}$spacesvol';

        bytesToPrint += generator.text(
          finalvolText, // Teks dengan spasi yang disesuaikan
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        int totalharLength = 30; // Misal total panjang karakter yang diinginkan adalah 40
        String baseharText = 'Total Harga : Rp.';
        int spaceharLength = totalharLength - (baseharText.length + totalHarga.text.length);

        // Jika jumlah spasi negatif (karena namaProduk.text terlalu panjang), setel ke 0
        spaceharLength = spaceharLength > 0 ? spaceharLength : 0;

        // Buat string spasi dengan panjang yang dihitung
        String spaceshar = ' ' * spaceharLength;

        // Gabungkan teks akhir dengan spasi
        String finalharText = 'Total harga : Rp. ${totalHarga.text}$spaceshar';

        bytesToPrint += generator.text(
          finalharText, // Teks dengan spasi yang disesuaikan
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        int totalopLength = 31; // Misal total panjang karakter yang diinginkan adalah 40
        String baseopText = 'Operator    : ';
        int spaceopLength = totalopLength - (baseopText.length + operatorName.text.length);

        // Jika jumlah spasi negatif (karena namaProduk.text terlalu panjang), setel ke 0
        spaceopLength = spaceopLength > 0 ? spaceopLength : 0;

        // Buat string spasi dengan panjang yang dihitung
        String spacesop = ' ' * spaceopLength;

        // Gabungkan teks akhir dengan spasi
        String finalopText = 'Operator    : ${operatorName.text}$spacesop';

        bytesToPrint += generator.text(
          finalopText, // Teks dengan spasi yang disesuaikan
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          '------------------------------', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'CASH                           ', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        int totalcashLength = 29; // Total panjang yang diinginkan untuk teks

// Hitung jumlah digit dari cash.text
        int cashLength = cash.text.length;

// Hitung jumlah spasi yang diperlukan
        int spacecashLength = totalcashLength - cashLength;

// Buat string spasi dengan panjang yang dihitung
        String spacescash = ' ' * spacecashLength;

// Gabungkan spasi dengan nilai cash
        String finalcashText = '$spacescash${cash.text}';

        bytesToPrint += generator.text(
          finalcashText, // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          '------------------------------', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        int totalplLength = 31; // Misal total panjang karakter yang diinginkan adalah 40
        String baseplText = 'Operator    : ';
        int spaceplLength = totalplLength - (baseplText.length + noPlat.text.length);

        // Jika jumlah spasi negatif (karena namaProduk.text terlalu panjang), setel ke 0
        spaceplLength = spaceplLength > 0 ? spaceplLength : 0;

        // Buat string spasi dengan panjang yang dihitung
        String spacespl = ' ' * spaceplLength;

        // Gabungkan teks akhir dengan spasi
        String finalplText = 'No. Plat    : ${noPlat.text}$spacespl';

        bytesToPrint += generator.text(
          finalplText, // Teks dengan spasi yang disesuaikan
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          '------------------------------', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'Anda Menggunakan Subsidi BBM dar', // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'i Negara : Bio Solar Rp 5.952/li', // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'ter dan Pertalite Rp 2.339/Liter', // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'Untuk tidak di salah gunakan. Mar', // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'i gunakan Pertamax series dan De', // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'x series                       ', // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'subsidi hanya untuk yang berhak ', // Teks yang sudah digabung dengan spasi
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'menerimanya.Terima Kasih        ', // Teks yang sudah digabung dengan spasi
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
        Get.snackbar('Error', 'Printer tidak terhubung');
      }
    } catch (e) {
      print("Error saat mencetak: $e");
      Get.snackbar('Error', '$e');
    }
  }
}
