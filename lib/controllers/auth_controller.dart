import 'package:energy_hub/views/home_view.dart';
import 'package:energy_hub/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // Firebase Auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Observable variables
  var isLoading = false.obs;
  var email = ''.obs;
  var password = ''.obs;
  var currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Monitor perubahan user state
    currentUser.bindStream(_firebaseAuth.authStateChanges());
  }

  /// Login menggunakan Email dan Password
  Future<void> login(String email, String password) async {
    try {
      isLoading(true);

      // Validasi input
      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          'Error',
          'Email dan password tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Login dengan Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan status login di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', userCredential.user!.email ?? '');

      Get.snackbar(
        'Login Berhasil',
        'Selamat datang di Energy Hub Logistics!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => HomeView());
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Terjadi kesalahan';

      if (e.code == 'user-not-found') {
        errorMessage = 'Email tidak terdaftar';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password salah';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Terlalu banyak percobaan login. Coba lagi nanti.';
      }

      Get.snackbar(
        'Login Gagal',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error tidak diketahui: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Register/Daftar user baru
  Future<void> register(
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      isLoading(true);

      // Validasi input
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        Get.snackbar(
          'Error',
          'Semua field harus diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (password != confirmPassword) {
        Get.snackbar(
          'Error',
          'Password tidak cocok',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (password.length < 6) {
        Get.snackbar(
          'Error',
          'Password minimal 6 karakter',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Buat user di Firebase
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', userCredential.user!.email ?? '');

      Get.snackbar(
        'Daftar Berhasil',
        'Akun berhasil dibuat. Selamat datang!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => HomeView());
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Terjadi kesalahan';
      print('DEBUG: Firebase Error Code = ${e.code}');
      print('DEBUG: Firebase Error Message = ${e.message}');

      if (e.code == 'weak-password') {
        errorMessage = 'Password terlalu lemah';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email sudah terdaftar';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Email/Password sign up tidak diaktifkan di Firebase';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Periksa koneksi internet Anda';
      } else {
        errorMessage = '${e.code}: ${e.message}';
      }

      Get.snackbar(
        'Daftar Gagal',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      print('DEBUG: Unexpected Error = ${e.toString()}');
      Get.snackbar(
        'Error',
        'Error tidak diketahui: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      isLoading(true);
      await _firebaseAuth.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userEmail');

      Get.offAll(() => const LoginView());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal logout: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      isLoading(true);

      if (email.isEmpty) {
        Get.snackbar(
          'Error',
          'Masukkan email Anda',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      await _firebaseAuth.sendPasswordResetEmail(email: email);

      Get.snackbar(
        'Sukses',
        'Link reset password telah dikirim ke email Anda',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Terjadi kesalahan';

      if (e.code == 'user-not-found') {
        errorMessage = 'Email tidak terdaftar';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Cek apakah user sudah login
  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  /// Dapatkan email user saat ini
  String? getCurrentUserEmail() {
    return _firebaseAuth.currentUser?.email;
  }
}
