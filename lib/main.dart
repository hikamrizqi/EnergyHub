import 'package:energy_hub/views/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan binding sudah siap sebelum akses SharedPreferences

  await Firebase.initializeApp(); // Inisialisasi Firebase sebelum runApp
  
  runApp(const EnergyHubApp());
}

class EnergyHubApp extends StatelessWidget {
  const EnergyHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Energy Hub Logistics',
      debugShowCheckedModeBanner:
          false, // Menghilangkan pita "DEBUG" di pojok kanan atas
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Mengatur font default aplikasi
      ),
      home: const LoginView(),
    );
  }
}
