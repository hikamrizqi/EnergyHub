import 'package:energy_hub/views/home_view.dart';
import 'package:energy_hub/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  //untuk hubungkan ke Login base
  void login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // Simpan status login

    //Memunculkan notifikasi bahwa login berhasil
    Get.snackbar(
      'Login Berhasil',
      'Selamat datang di Energy Hub Logistics!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.offAll(() => HomeView()); // Navigasi ke HomeView setelah login
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Hapus status login

    Get.offAll(() => const LoginView()); // Navigasi ke LoginView setelah logout
  }
}
