import 'package:get/get.dart';
import 'dart:typed_data'; // Pastikan ini diimpor
import 'dart:io'; // Pastikan ini diimpor
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:image/image.dart';
import 'package:thermal_printer/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:thermal_printer/thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img; // Perbaiki menjadi yang benar
import 'package:path_provider/path_provider.dart';
import 'package:project_fake_receipt/app/modules/BluetoothSetting/controllers/bluetooth_setting_controller.dart';

class TmjController extends GetxController {
  //TODO: Implement TmjController
  var asal1 = ''.obs;
  var tanggal = ''.obs;
  var waktu = ''.obs;
  var kode = ''.obs;
  var noSeri = ''.obs;
  var asal2 = ''.obs;
  var type = ''.obs;
  var harga = ''.obs;
  var serialNumber = ''.obs;
  var sisaSaldo = ''.obs;
  var peringatan = ''.obs;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  final BluetoothSettingController bluetoothController = Get.put(BluetoothSettingController());

  final count = 0.obs;
  @override
  void onInit() {
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
    print("Asal 1: ${asal1.value}");
    print("Tanggal: ${tanggal.value}");
    print("Waktu: ${waktu.value}");
    print("Kode: ${kode.value}");
    print("No. Seri: ${noSeri.value}");
    print("Asall 2: ${asal2.value}");
    print("Type: ${type.value}");
    print("Harga: ${harga.value}");
    print("Serial Number: ${serialNumber.value}");
    print("Sisa Saldo: ${sisaSaldo.value}");
    print("Peringatan: ${peringatan.value}");

    try {
      if (connectionStatus) {
        List<int> bytesToPrint = [];
        final profile = await CapabilityProfile.load();
        final generator = Generator(PaperSize.mm80, profile);
        bytesToPrint += generator.reset();


        // final ByteData data = await rootBundle.load('assets/logo.png');
        // final Uint8List bytes = data.buffer.asUint8List();
        // final Image? image = decodeImage(bytes);
        final ByteData data = await rootBundle.load('assets/tmj.png');
        final Uint8List bytes = data.buffer.asUint8List();

        // Decode image
        img.Image? originalImage = img.decodeImage(bytes);

        // Resize the image
        img.Image resizedImage = img.copyResize(originalImage!, height: 90);

        // Save resized image to a file (optional, if needed)
        final Uint8List resizedBytes = img.encodePng(resizedImage);
        final directory = await getTemporaryDirectory();
        final String tempPath = '${directory.path}/resized_image.png';
        final File file = File(tempPath);
        final imgFile = await file.writeAsBytes(resizedBytes); // Save the resized image
        img.Image? image = img.decodeImage(File(file.path).readAsBytesSync());

        // Print image using generator.imageRaster
        // bytesToPrint += generator.imageRaster(File(file.path), align: PosAlign.left);

        await bluetoothController.printer.printImage(file.path);

        bytesToPrint += generator.text(
          'Info Tol 14080', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          asal1.value, // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );


        bytesToPrint += generator.feed(1);

        bytesToPrint += generator.text(
          '${tanggal.value} ${waktu.value}  ${kode.value}     ', // Teks normal
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        // Panjang ideal untuk No Seri (misal: 20 digit)
        const int idealLength = 20;

        // Dapatkan panjang dari noSeri
        int noSeriLength = noSeri.value.length;

        // Hitung jumlah spasi yang dibutuhkan
        // Jika panjang NoSeri lebih dari idealLength, spasi berkurang.
        // Jika panjang NoSeri kurang dari idealLength, spasi bertambah.
        int extraSpaces = (idealLength + 5 - noSeriLength).clamp(0, 10); // Spasi minimal 0, maksimal 10

        // Buat string spasi sesuai perhitungan
        String spaces = ' ' * extraSpaces; // Membuat spasi sebanyak extraSpaces

        // Tambahkan teks dan spasi
        bytesToPrint += generator.text(
          'No Seri: ${noSeri.value}$spaces', // Teks dengan spasi tambahan
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

       // Panjang ideal untuk keseluruhan teks (termasuk spasi)
        const int idealLengthas = 34;

        // Dapatkan panjang dari teks 'ASAL: ${asal2.value}'
        int textLengthas = 'ASAL: ${asal2.value}'.length;

        // Hitung jumlah spasi yang dibutuhkan
        int extraSpacesas = (idealLengthas - textLengthas).clamp(0, 20); // Minimal 0 spasi, maksimal 20 spasi

        // Buat string spasi sesuai perhitungan
        String spacesas = ' ' * extraSpacesas; // Membuat spasi sebanyak extraSpaces

        // Tambahkan teks dan spasi
        bytesToPrint += generator.text(
          'ASAL: ${asal2.value}$spacesas', // Teks dengan spasi tambahan
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );


       // Panjang ideal untuk teks yang mencakup 'type' dan 'harga' (misal: 34 karakter)
        const int idealLengthty = 34;

        // Dapatkan panjang dari type.value dan harga.value
        int textLengthty = '${type.value} Rp. ${harga.value}'.length;

        // Hitung jumlah spasi yang dibutuhkan
        // Jika panjang teks lebih dari idealLength, spasi berkurang.
        // Jika panjang teks kurang dari idealLength, spasi bertambah.
        int extraSpacesty = (idealLengthty - textLengthty).clamp(0, 10); // Minimal 0, maksimal 10 spasi

        // Buat string spasi sesuai perhitungan
        String spacesty = ' ' * extraSpacesty; // Membuat spasi sebanyak extraSpaces

        // Tambahkan teks dan spasi
        bytesToPrint += generator.text(
          '${type.value} Rp. ${harga.value}$spacesty', // Teks dengan spasi tambahan
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size2, // Mengatur tinggi teks menjadi dua kali lipat
            width: PosTextSize.size1, // Lebar teks tetap normal
          ),
        );

        // Panjang ideal untuk teks yang mencakup serialNumber dan sisaSaldo (misal: 34 karakter)
        const int idealLengthsn = 34;

        // Dapatkan panjang dari serialNumber.value dan sisaSaldo.value
        int textLengthsn = 'SN:${serialNumber.value} Rp. ${sisaSaldo.value}'.length;

        // Hitung jumlah spasi yang dibutuhkan
        // Jika panjang teks lebih dari idealLength, spasi berkurang.
        // Jika panjang teks kurang dari idealLength, spasi bertambah.
        int extraSpacessn = (idealLengthsn - textLengthsn).clamp(0, 10); // Minimal 0, maksimal 10 spasi

        // Buat string spasi sesuai perhitungan
        String spacessn = ' ' * extraSpacessn; // Membuat spasi sebanyak extraSpaces

        // Tambahkan teks dan spasi
        bytesToPrint += generator.text(
          'SN:${serialNumber.value} Rp. ${sisaSaldo.value}$spacessn', // Teks dengan spasi tambahan
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );

        bytesToPrint += generator.text(
          '${peringatan.value}           ', // Teks dengan spasi tambahan
          styles: PosStyles(
            align: PosAlign.center,
            bold: false,
            height: PosTextSize.size1, // Ukuran paling kecil
            width: PosTextSize.size1,
          ),
        );







        bytesToPrint += generator.cut();

        // Kirim perintah ke printer
        await PrintBluetoothThermal.writeBytes(bytesToPrint);


        print("Data berhasil dicetak di printer.");
        await PrintBluetoothThermal.disconnect;
        await PrintBluetoothThermal.connect(macPrinterAddress: '66:32:20:59:77:3F');
      } else {
        print("Printer tidak terhubung.");
      }
    } catch (e) {
      print("Error saat mencetak: $e");
    }
  }
  }
