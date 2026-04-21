import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:energy_hub/controllers/shipment_controller.dart';

class AddShipmentView extends StatefulWidget {
  const AddShipmentView({super.key});

  @override
  State<AddShipmentView> createState() => _AddShipmentViewState();
}

class _AddShipmentViewState extends State<AddShipmentView> {
  late TextEditingController recipientNameController;
  late TextEditingController recipientPhoneController;
  late TextEditingController destinationController;
  late TextEditingController cityController;

  // Untuk items
  List<Map<String, dynamic>> items = [];
  late TextEditingController itemCodeController;
  late TextEditingController itemNameController;
  late TextEditingController itemMaxStokController;

  @override
  void initState() {
    super.initState();
    recipientNameController = TextEditingController();
    recipientPhoneController = TextEditingController();
    destinationController = TextEditingController();
    cityController = TextEditingController();
    itemCodeController = TextEditingController();
    itemNameController = TextEditingController();
    itemMaxStokController = TextEditingController();
  }

  @override
  void dispose() {
    recipientNameController.dispose();
    recipientPhoneController.dispose();
    destinationController.dispose();
    cityController.dispose();
    itemCodeController.dispose();
    itemNameController.dispose();
    itemMaxStokController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (itemCodeController.text.isEmpty ||
        itemNameController.text.isEmpty ||
        itemMaxStokController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Kode barang, nama barang, dan max stok harus diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      items.add({
        'item_code': itemCodeController.text,
        'item_name': itemNameController.text,
        'max_stok': int.parse(itemMaxStokController.text),
      });
    });

    // Clear fields
    itemCodeController.clear();
    itemNameController.clear();
    itemMaxStokController.clear();

    Get.snackbar(
      'Berhasil',
      'Item ditambahkan',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _submitShipment() {
    if (recipientNameController.text.isEmpty ||
        recipientPhoneController.text.isEmpty ||
        destinationController.text.isEmpty ||
        cityController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field pengiriman harus diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (items.isEmpty) {
      Get.snackbar(
        'Error',
        'Tambahkan minimal 1 item',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Call ShipmentController untuk buat shipment & items
    final ShipmentController controller = Get.find<ShipmentController>();

    controller
        .createShipment(
          recipientName: recipientNameController.text.trim(),
          recipientPhone: recipientPhoneController.text.trim(),
          destination: destinationController.text.trim(),
          cityDestination: cityController.text.trim(),
          items: items,
        )
        .then((success) {
          if (success) {
            // Kembali ke home jika berhasil
            Get.back();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Pengiriman Baru'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== SECTION: DATA PENGIRIMAN =====
              const Text(
                'Data Pengiriman',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),

              /// Recipient Name
              TextField(
                controller: recipientNameController,
                decoration: InputDecoration(
                  labelText: 'Nama Penerima',
                  hintText: 'Masukkan nama penerima',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),

              /// Recipient Phone
              TextField(
                controller: recipientPhoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'No. Telepon',
                  hintText: 'Masukkan nomor telepon',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 12),

              /// Destination
              TextField(
                controller: destinationController,
                decoration: InputDecoration(
                  labelText: 'Alamat Tujuan',
                  hintText: 'Masukkan alamat tujuan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 12),

              /// City
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'Kota Tujuan',
                  hintText: 'Masukkan kota tujuan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.location_city),
                ),
              ),
              const SizedBox(height: 32),

              // ===== SECTION: TAMBAH ITEM =====
              const Text(
                'Tambah Item',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),

              /// Item Code
              TextField(
                controller: itemCodeController,
                decoration: InputDecoration(
                  labelText: 'Kode Barang',
                  hintText: 'Masukkan kode barang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.qr_code),
                ),
              ),
              const SizedBox(height: 12),

              /// Item Name
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(
                  labelText: 'Nama Barang',
                  hintText: 'Masukkan nama barang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.shopping_bag),
                ),
              ),
              const SizedBox(height: 12),

              /// Max Stok
              TextField(
                controller: itemMaxStokController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Max Stok',
                  hintText: 'Masukkan max stok',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.inventory),
                ),
              ),
              const SizedBox(height: 16),

              /// Add Item Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Item'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ===== SECTION: DAFTAR ITEM =====
              if (items.isNotEmpty) ...[
                Text(
                  'Daftar Item (${items.length})',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...List.generate(items.length, (index) {
                  var item = items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        item['item_name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kode: ${item['item_code']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Max Stok: ${item['max_stok']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeItem(index),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],

              /// Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitShipment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Buat Pengiriman',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
