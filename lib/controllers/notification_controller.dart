import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    _setupNotification();
  }

  void _setupNotification() async {
    // 1. Meminta izin ke pengguna
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Izin notifikasi diberikan!');

      // 2. Mengambil token unik di hp ini
      String? token = await messaging.getToken();
      print("==============");
      print("FCM TOKEN HP INI: $token");
      print("==============");

      // 3. Menangkap notifikasi saat aplikasi sedang DIBUKA (foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Notifikasi diterima saat aplikasi di latar depan:');
        print(message.notification?.title);
        print(message.notification?.body);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          // Munculkan notifikasi pakai GetX Snackbar agar terlihat dari dalam aplikasi
          Get.snackbar(
            message.notification!.title ?? 'Notifikasi Baru',
            message.notification!.body ?? 'Ada pembaruan status logistik.',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            backgroundColor: Get.theme.primaryColor.withOpacity(0.8),
            colorText: Get.theme.colorScheme.onPrimary,
          );
        }
      });
    } else {
      print('Izin notifikasi ditolak pengguna.');
    }
  }
}
