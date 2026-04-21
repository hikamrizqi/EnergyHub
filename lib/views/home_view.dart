import 'package:energy_hub/controllers/auth_controller.dart';
import 'package:energy_hub/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shipment_controller.dart';
import 'add_shipment_view.dart';

class HomeView extends StatelessWidget {
  // Panggil controllernya
  final ShipmentController controller = Get.put(ShipmentController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Logistik'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.logout, // Memanggil fungsi logout
          ),
        ],
      ),

      // Obx akan memantau perubahan variabel .obs di controller
      body: Obx(() {
        // Tampilkan loading spinner jika isLoading masih true
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Tampilkan pesan jika data kosong
        if (controller.shipmentList.isEmpty) {
          return const Center(child: Text('Tidak ada data pengiriman'));
        }

        // Tampilkan list data jika sudah berhasil diambil
        return ListView.builder(
          itemCount: controller.shipmentList.length,
          itemBuilder: (context, index) {
            // Ambil data tiap baris
            var item = controller.shipmentList[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                trailing: const Icon(Icons.local_shipping),
                title: Text(
                  item.recipientName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Resi: ${item.trackingNumber}"),
                    Text("Tujuan: ${item.destination}"),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: item.status == "delivered"
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.status == "delivered"
                            ? "Terkirim"
                            : "Dalam Perjalanan",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),

      // Tombol Plus untuk tambah pengiriman
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddShipmentView());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
