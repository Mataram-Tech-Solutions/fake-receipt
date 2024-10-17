import 'dart:typed_data'; // Pastikan ini diimpor
import 'dart:io'; // Pastikan ini diimpor
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img; // Perbaiki menjadi yang benar
import 'package:path_provider/path_provider.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart'; // Pastikan Anda menggunakan library ESC/POS yang mendukung
import 'package:project_fake_receipt/app/modules/BluetoothSetting/controllers/bluetooth_setting_controller.dart';

class PertaminaController extends GetxController {
  var idNota = ''.obs;
  var alamat1 = ''.obs;
  var alamat2 = ''.obs;
  var shift = ''.obs;
  var noTransaksi = ''.obs;
  var tanggal = ''.obs;
  var waktu = ''.obs;
  var pompa = ''.obs;
  var namaProduk = ''.obs;
  var hargaLiter = ''.obs;
  var volume = ''.obs;
  var totalHarga = ''.obs;
  var operatorName = ''.obs; // Mengganti nama dari operator menjadi operatorName
  var cash = ''.obs;
  var noPlat = ''.obs;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
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
    print("ID Nota: ${idNota.value}");
    print("Alamat 1: ${alamat1.value}");
    print("Alamat 2: ${alamat2.value}");
    print("Shift: ${shift.value}");
    print("No. Transaksi: ${noTransaksi.value}");
    print("Tanggal: ${tanggal.value}");
    print("Waktu: ${waktu.value}");
    print("Pulau/Pompa: ${pompa.value}");
    print("Nama Produk: ${namaProduk.value}");
    print("Harga/Liter: ${hargaLiter.value}");
    print("Volume: ${volume.value}");
    print("Total Harga: ${totalHarga.value}");
    print("Operator: ${operatorName.value}");
    print("Cash: ${cash.value}");
    print("No. Plat: ${noPlat.value}");

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
          idNota.value, // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          alamat1.value, // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          alamat2.value, // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'Shift : ${shift.value}    No. Trans : ${noTransaksi.value}', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          'Waktu : ${tanggal.value}  ${waktu.value}   ', // Teks normal
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

        String pompaText = pompa.value.length == 1
            ? 'Pulau/Pompa : ${pompa.value}                '  // Tambahkan 1 spasi ekstra untuk 1 digit
            : 'Pulau/Pompa : ${pompa.value}               ';  // Jika 2 digit, gunakan jumlah spasi biasa

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
        int spaceLength = totalLength - (baseText.length + namaProduk.value.length);

        // Jika jumlah spasi negatif (karena namaProduk.value terlalu panjang), setel ke 0
        spaceLength = spaceLength > 0 ? spaceLength : 0;

        // Buat string spasi dengan panjang yang dihitung
        String spaces = ' ' * spaceLength;

        // Gabungkan teks akhir dengan spasi
        String finalText = 'Nama Produk : ${namaProduk.value}$spaces';

        bytesToPrint += generator.text(
          finalText, // Teks dengan spasi yang disesuaikan
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        String hargaLiterText = hargaLiter.value.length == 5
            ? 'Harga/Liter : Rp. ${hargaLiter.value}        '  // Tambahkan 1 spasi ekstra untuk 5 digit
            : 'Harga/Liter : Rp. ${hargaLiter.value}       ';  // Jika 6 digit, gunakan jumlah spasi biasa

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
        int spacevolLength = totalvolLength - (basevolText.length + volume.value.length);

        // Jika jumlah spasi negatif (karena namaProduk.value terlalu panjang), setel ke 0
        spacevolLength = spacevolLength > 0 ? spacevolLength : 0;

        // Buat string spasi dengan panjang yang dihitung
        String spacesvol = ' ' * spacevolLength;

        // Gabungkan teks akhir dengan spasi
        String finalvolText = 'Volume      : (L) ${volume.value}$spacesvol';

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
        int spaceharLength = totalharLength - (baseharText.length + totalHarga.value.length);

        // Jika jumlah spasi negatif (karena namaProduk.value terlalu panjang), setel ke 0
        spaceharLength = spaceharLength > 0 ? spaceharLength : 0;

        // Buat string spasi dengan panjang yang dihitung
        String spaceshar = ' ' * spaceharLength;

        // Gabungkan teks akhir dengan spasi
        String finalharText = 'Total harga : Rp. ${totalHarga.value}$spaceshar';

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
        int spaceopLength = totalopLength - (baseopText.length + operatorName.value.length);

        // Jika jumlah spasi negatif (karena namaProduk.value terlalu panjang), setel ke 0
        spaceopLength = spaceopLength > 0 ? spaceopLength : 0;

        // Buat string spasi dengan panjang yang dihitung
        String spacesop = ' ' * spaceopLength;

        // Gabungkan teks akhir dengan spasi
        String finalopText = 'Operator    : ${operatorName.value}$spacesop';

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

// Hitung jumlah digit dari cash.value
        int cashLength = cash.value.length;

// Hitung jumlah spasi yang diperlukan
        int spacecashLength = totalcashLength - cashLength;

// Buat string spasi dengan panjang yang dihitung
        String spacescash = ' ' * spacecashLength;

// Gabungkan spasi dengan nilai cash
        String finalcashText = '$spacescash${cash.value}';

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
        int spaceplLength = totalplLength - (baseplText.length + noPlat.value.length);

        // Jika jumlah spasi negatif (karena namaProduk.value terlalu panjang), setel ke 0
        spaceplLength = spaceplLength > 0 ? spaceplLength : 0;

        // Buat string spasi dengan panjang yang dihitung
        String spacespl = ' ' * spaceplLength;

        // Gabungkan teks akhir dengan spasi
        String finalplText = 'No. Plat    : ${noPlat.value}$spacespl';

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
      } else {
        print("Printer tidak terhubung.");
      }
    } catch (e) {
      print("Error saat mencetak: $e");
    }
  }

}
