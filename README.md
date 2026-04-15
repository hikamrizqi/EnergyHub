# 📦 EnergyHub Logistics App

A robust, production-ready mobile application designed to streamline logistics and shipment tracking. Built with Flutter, this project demonstrates a strong understanding of modern mobile development architecture, state management, local storage, and real-time cloud messaging.

## ✨ Key Features & Technical Highlights

This application is built to fulfill standard industry requirements for a scalable mobile application:

* **⚡ Reactive State Management:** Fully powered by **GetX** (`GetxController`, `Obx`, `Get.put/Get.find`) for memory-efficient state management, dependency injection, and context-less routing.
* **🌐 REST API Integration:** Fetches real-time shipment data (tracking numbers, destinations, status) from a remote server (MockAPI) using the HTTP package.
* **💾 Offline-First Capability (Local Storage):** * **SQLite (`sqflite`):** Implements the Singleton pattern to cache network responses. If the user loses internet connection, the app seamlessly loads the last known shipment data from the local database.
    * **SharedPreferences:** Handles persistent user sessions for the Authentication flow (Login/Logout).
* **🔔 Push Notifications:** Integrated with **Firebase Cloud Messaging (FCM)** to receive real-time background and foreground notifications (e.g., "Package Delivered" alerts).
* **🎨 Clean UI/UX:** Pixel-perfect slicing based on Figma designs, featuring conditional UI rendering (e.g., dynamic badges for shipment statuses).

## 🛠️ Tech Stack

* **Framework:** Flutter
* **Language:** Dart
* **State Management & Routing:** GetX
* **Database (Local):** SQLite (`sqflite`), SharedPreferences
* **Backend/API:** MockAPI (RESTful API)
* **Cloud Services:** Firebase (Core & Cloud Messaging)

## 🏗️ Folder Architecture

The project strictly follows the **Separation of Concerns** principle to ensure the code is maintainable and scalable:

```text
lib/
│
├── controllers/       # Business logic and GetX Controllers (AuthController, ShipmentController, etc.)
├── models/            # Data structures and JSON serialization (ShipmentModel)
├── services/          # External API calls and Local Database setup (DBService)
├── views/             # UI layer / Screens (LoginView, HomeView)
└── main.dart          # Application entry point and Firebase Initialization
```
🚀 How to Run the Project
Clone this repository.

Bash
git clone [https://github.com/hikamrizqi/EnergyHub.git](https://github.com/hikamrizqi/EnergyHub.git)
Navigate to the project directory.

Bash
cd EnergyHub
Install dependencies.

Bash
flutter pub get
Run the app on your connected device or emulator.

Bash
flutter run
(Note: To test the push notification feature, ensure you run the app on a physical device or an emulator with Google Play Services enabled).

👨‍💻 Author
Hikam Rizqillah Munandar
Mobile & Game Developer

***

### Langkah Selanjutnya:
1. *Copy-paste* teks di atas ke file `README.md` di VS Code kamu.
2. Simpan (`Ctrl+S`).
3. Lakukan *Push* ke GitHub:
   ```bash
   git add .
   git commit -m "docs: Update README with project details and architecture"
   git push