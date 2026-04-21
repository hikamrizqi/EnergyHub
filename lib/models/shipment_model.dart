class ShipmentModel {
  final int id;
  final int userId;
  final String trackingNumber;
  final String recipientName;
  final String? recipientPhone;
  final String destination;
  final String? cityDestination;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ItemModel>? items;

  ShipmentModel({
    required this.id,
    required this.userId,
    required this.trackingNumber,
    required this.recipientName,
    this.recipientPhone,
    required this.destination,
    this.cityDestination,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      trackingNumber: json['tracking_number'] ?? '',
      recipientName: json['recipient_name'] ?? '',
      recipientPhone: json['recipient_phone'],
      destination: json['destination'] ?? '',
      cityDestination: json['city_destination'],
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      items: json['items'] != null
          ? (json['items'] as List)
                .map((item) => ItemModel.fromJson(item))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tracking_number': trackingNumber,
      'recipient_name': recipientName,
      'recipient_phone': recipientPhone,
      'destination': destination,
      'city_destination': cityDestination,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class ItemModel {
  final int id;
  final int shipmentId;
  final String itemCode;
  final String itemName;
  final int maxStok;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ItemModel({
    required this.id,
    required this.shipmentId,
    required this.itemCode,
    required this.itemName,
    required this.maxStok,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] ?? 0,
      shipmentId: json['shipment_id'] ?? 0,
      itemCode: json['item_code'] ?? '',
      itemName: json['item_name'] ?? '',
      maxStok: json['max_stok'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shipment_id': shipmentId,
      'item_code': itemCode,
      'item_name': itemName,
      'max_stok': maxStok,
    };
  }
}
