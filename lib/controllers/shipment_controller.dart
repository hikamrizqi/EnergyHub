import 'package:energy_hub/models/shipment_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShipmentController extends GetxController {
  //variabel untuk loading state
  var isLoading = true.obs;

  //variabel penampung data (sementara pakai tipe dinamis)
  var shipmentList = <ShipmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchShipments();
  }

  void fetchShipments() async {
    try {
      isLoading(true);
      //Hit endpoint MockAPI untuk mendapatkan data pengiriman
      var response = await http.get(
        Uri.parse(
          'https://69cf2caaa4647a9fc6752532.mockapi.io/api/v1/:endpoint',
        ),
      );

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        //Mapping json ke list model
        shipmentList.value = data
            .map((e) => ShipmentModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print('Terjadi Error: $e');
    } finally {
      isLoading(false); //Set loading selesai
    }
  }
}
