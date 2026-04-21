import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.137.1/api';

  // Mendapatkan token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Mendapatkan headers dengan authorization
  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ===== HEALTH CHECK =====
  /// Test koneksi API
  static Future<bool> healthCheck() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Health check failed: $e');
      return false;
    }
  }

  // ===== SHIPMENT API CALLS =====

  /// Get all shipments
  static Future<http.Response> getShipments() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/shipments'))
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('Error fetching shipments: ${e.toString()}');
    }
  }

  /// Create new shipment
  static Future<http.Response> createShipment({
    required String recipientName,
    required String recipientPhone,
    required String destination,
    required String cityDestination,
  }) async {
    try {
      final body = jsonEncode({
        'recipient_name': recipientName,
        'recipient_phone': recipientPhone,
        'destination': destination,
        'city_destination': cityDestination,
      });

      final response = await http
          .post(
            Uri.parse('$baseUrl/shipments'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('Error creating shipment: ${e.toString()}');
    }
  }

  /// Get single shipment
  static Future<http.Response> getShipment(int id) async {
    try {
      final headers = await getHeaders();
      final response = await http
          .get(Uri.parse('$baseUrl/shipments/$id'), headers: headers)
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('Error fetching shipment: ${e.toString()}');
    }
  }

  /// Update shipment
  static Future<http.Response> updateShipment({
    required int id,
    required String status,
  }) async {
    try {
      final body = jsonEncode({'status': status});

      final response = await http
          .put(
            Uri.parse('$baseUrl/shipments/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('Error updating shipment: ${e.toString()}');
    }
  }

  /// Delete shipment
  static Future<http.Response> deleteShipment(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/shipments/$id'))
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('Error deleting shipment: ${e.toString()}');
    }
  }

  // ===== ITEM API CALLS =====

  /// Get items by shipment
  static Future<http.Response> getItemsByShipment(int shipmentId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/items/shipment/$shipmentId'))
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('Error fetching items: ${e.toString()}');
    }
  }

  /// Create item
  static Future<http.Response> createItem({
    required int shipmentId,
    required String itemCode,
    required String itemName,
    required int maxStok,
  }) async {
    try {
      final body = jsonEncode({
        'shipment_id': shipmentId,
        'item_code': itemCode,
        'item_name': itemName,
        'max_stok': maxStok,
      });

      final response = await http
          .post(
            Uri.parse('$baseUrl/items'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('Error creating item: ${e.toString()}');
    }
  }

  /// Get single item
  static Future<http.Response> getItem(int id) async {
    try {
      final headers = await getHeaders();
      final response = await http
          .get(Uri.parse('$baseUrl/items/$id'), headers: headers)
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('Error fetching item: ${e.toString()}');
    }
  }

  /// Update item
  static Future<http.Response> updateItem({
    required int id,
    required int? categoryId,
    required String? name,
    required int? quantity,
  }) async {
    try {
      final headers = await getHeaders();
      final Map<String, dynamic> body = {};

      if (categoryId != null) body['category_id'] = categoryId;
      if (name != null) body['name'] = name;
      if (quantity != null) body['quantity'] = quantity;

      final response = await http
          .put(
            Uri.parse('$baseUrl/items/$id'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('Error updating item: ${e.toString()}');
    }
  }

  /// Delete item
  static Future<http.Response> deleteItem(int id) async {
    try {
      final headers = await getHeaders();
      final response = await http
          .delete(Uri.parse('$baseUrl/items/$id'), headers: headers)
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('Error deleting item: ${e.toString()}');
    }
  }
}
