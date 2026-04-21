import 'package:energy_hub/models/shipment_model.dart';
import 'package:energy_hub/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class ShipmentController extends GetxController {
  //variabel untuk loading state
  var isLoading = true.obs;

  //variabel penampung data
  var shipmentList = <ShipmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchShipments();
  }

  /// Fetch shipments dari API Laravel
  Future<void> fetchShipments() async {
    try {
      isLoading(true);

      final response = await ApiService.getShipments();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          List<dynamic> shipmentsJson = data['data'];
          List<ShipmentModel> shipments = shipmentsJson
              .map((json) => ShipmentModel.fromJson(json))
              .toList();

          shipmentList.value = shipments;
          print('✅ Berhasil fetch ${shipments.length} shipments');
        } else {
          print('❌ Response tidak valid: ${data['message']}');
          Get.snackbar(
            'Error',
            data['message'] ?? 'Gagal mengambil data',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - Token expired');
        Get.snackbar(
          'Error',
          'Session expired. Silakan login ulang.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print('❌ Error ${response.statusCode}: ${response.body}');
        Get.snackbar(
          'Error',
          'Gagal mengambil data (Status: ${response.statusCode})',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Exception: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Create shipment baru
  Future<bool> createShipment({
    required String recipientName,
    required String recipientPhone,
    required String destination,
    required String cityDestination,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      isLoading(true);

      // 1. Create shipment
      final shipmentResponse = await ApiService.createShipment(
        recipientName: recipientName,
        recipientPhone: recipientPhone,
        destination: destination,
        cityDestination: cityDestination,
      );

      if (shipmentResponse.statusCode != 201) {
        final error = jsonDecode(shipmentResponse.body);
        Get.snackbar(
          'Error',
          error['message'] ?? 'Gagal membuat shipment',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final shipmentData = jsonDecode(shipmentResponse.body);
      int shipmentId = shipmentData['data']['id'];
      print('✅ Shipment created with ID: $shipmentId');

      // 2. Create items untuk shipment
      for (var item in items) {
        try {
          final itemResponse = await ApiService.createItem(
            shipmentId: shipmentId,
            itemCode: item['item_code'],
            itemName: item['item_name'],
            maxStok: item['max_stok'],
          );

          if (itemResponse.statusCode == 201) {
            print('✅ Item created: ${item['item_name']}');
          } else {
            print('⚠️ Failed to create item: ${item['item_name']}');
          }
        } catch (e) {
          print('❌ Error creating item: $e');
        }
      }

      // Refresh shipment list
      await fetchShipments();

      Get.snackbar(
        'Berhasil',
        'Pengiriman dan item berhasil dibuat',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      print('❌ Exception: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  /// Get single shipment dengan items
  Future<ShipmentModel?> getShipment(int id) async {
    try {
      final response = await ApiService.getShipment(id);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return ShipmentModel.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }

  /// Update shipment status
  Future<bool> updateShipmentStatus({
    required int id,
    required String status,
  }) async {
    try {
      isLoading(true);

      final response = await ApiService.updateShipment(id: id, status: status);

      if (response.statusCode == 200) {
        print('✅ Shipment status updated');
        await fetchShipments();
        return true;
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          error['message'] ?? 'Gagal update status',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('❌ Exception: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }

  /// Delete shipment
  Future<bool> deleteShipment(int id) async {
    try {
      isLoading(true);

      final response = await ApiService.deleteShipment(id);

      if (response.statusCode == 200) {
        print('✅ Shipment deleted');
        await fetchShipments();
        Get.snackbar(
          'Berhasil',
          'Pengiriman berhasil dihapus',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          error['message'] ?? 'Gagal delete shipment',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('❌ Exception: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }
}
