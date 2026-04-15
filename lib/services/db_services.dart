import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:energy_hub/models/shipment_model.dart';

class DbServices {
  static Database? _database;
  static const String tableName = 'shipments';

  //Singleton pattern untuk memastikan hanya ada satu instance database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    //mencari lokasi aman di hp untuk menyimpan database
    String path = join(await getDatabasesPath(), 'energy_hub.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        //membuat tabel saat aplikasi pertama kali diinstal
        await db.execute('''
          CREATE TABLE $tableName (
            id TEXT PRIMARY KEY,
            tracking_number TEXT,
            recipient_name TEXT,
            destination TEXT,
            status TEXT
          )
        ''');
      },
    );
  }

  //Fungsi untuk menyimpan list data dari API ke SQLite
  Future<void> saveShipments(List<ShipmentModel> shipments) async {
    final db = await database;

    //Hapus data lama sebelum menyimpan yang baru
    await db.delete(tableName);

    //Simpan data baru
    for (var shipment in shipments) {
      await db.insert(tableName, {
        'id': shipment.id,
        'tracking_number': shipment.trackingNumber,
        'recipient_name': shipment.recipientName,
        'destination': shipment.destination,
        'status': shipment.status,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  //Fungsi untuk mengambil data dari SQLite saat offline
  Future<List<ShipmentModel>> getOfflineShipments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return ShipmentModel(
        id: maps[i]['id'],
        trackingNumber: maps[i]['tracking_number'],
        recipientName: maps[i]['recipient_name'],
        destination: maps[i]['destination'],
        status: maps[i]['status'],
      );
    });
  }
}
