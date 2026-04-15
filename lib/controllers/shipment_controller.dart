import 'package:energy_hub/models/shipment_model.dart';
import 'package:energy_hub/services/db_services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShipmentController extends GetxController {
  //variabel untuk loading state
  var isLoading = true.obs;

  //variabel penampung data (sementara pakai tipe dinamis)
  var shipmentList = <ShipmentModel>[].obs;

  //panggil Singleton DbServices untuk akses database
  final DbServices _dbService = DbServices();

  @override
  void onInit() {
    super.onInit();
    fetchShipments();
  }

  void fetchShipments() async {
    try {
      isLoading(true);
      //Hit endpoint MockAPI untuk mendapatkan data pengiriman
      const String apiUrl =
          'https://69cf2caaa4647a9fc6752532.mockapi.io/api/v1/shipments';

      //1. Mencoba tarik dari internet
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> jsonString = json.decode(response.body);
        List<ShipmentModel> fetchedData = jsonString
            .map((data) => ShipmentModel.fromJson(data))
            .toList();

        shipmentList.value = fetchedData;

        // 2. Simpan ke SQLite (diam-diam di latar belakang)
        await _dbService.saveShipments(fetchedData);
        print("Sukses tarik data dari API dan simpan ke SQLite");
      } else {
        //jika server menolak, pakai data lokal
        await _loadOfflineData();
      }
    } catch (e) {
      // 3. jika tidak ada internet (Masuk ke blok catch), langsung pakai data lokal
      print("Koneksi internet bermasalah, coba ambil data offline...");
      await _loadOfflineData();
    } finally {
      isLoading(false);
    }
  }

  // Fungsi khusus untuk membaca lemari arsip (SQLite) saat offline
  Future<void> _loadOfflineData() async {
    try {
      List<ShipmentModel> offlineData = await _dbService.getOfflineShipments();
      shipmentList.value = offlineData;
      // beritahu user kalau dia offline
      Get.snackbar(
        'Mode Offline',
        'Menampilkan data terakhir yang tersimpan.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      print("Gagal ambil data offline: $e");
    }
  }
}
