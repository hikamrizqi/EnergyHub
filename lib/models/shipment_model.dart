class ShipmentModel {
  final String id;
  final String trackingNumber;
  final String recipientName;
  final String destination;
  final String status;

  ShipmentModel({
    required this.id,
    required this.trackingNumber,
    required this.recipientName,
    required this.destination,
    required this.status,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      id: json['id'],
      trackingNumber: json['tracking_number'], // Fallback jika field tidak ada
      recipientName: json['recipient_name'], // Fallback jika field tidak ada
      destination: json['destination'], // Fallback jika field tidak ada
      status: json['status'], // Fallback jika field tidak ada
    );
  }
}
