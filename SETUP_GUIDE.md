# ENERGYHUB LOGISTICS - SETUP GUIDE

## 📋 Daftar Isi
1. [Database Setup](#1-database-setup)
2. [Laravel API Setup](#2-laravel-api-setup)
3. [Flutter App Integration](#3-flutter-app-integration)
4. [Testing API](#4-testing-api)
5. [Troubleshooting](#5-troubleshooting)

---

## 1. DATABASE SETUP

### 1.1 Create Database
```sql
CREATE DATABASE energyhub_db;
USE energyhub_db;
```

### 1.2 Import SQL Schema
Gunakan file `database_schema.sql` untuk membuat semua tabel:
```bash
mysql -u root -p energyhub_db < database_schema.sql
```

### 1.3 Verify Tables
```sql
SHOW TABLES;
-- Harus ada: users, categories, shipments, items, shipment_history, notifications
```

---

## 2. LARAVEL API SETUP

### 2.1 Create Laravel Project
```bash
composer create-project laravel/laravel energyhub-api
cd energyhub-api
```

### 2.2 Install Required Packages
```bash
composer require tymon/jwt-auth
composer require laravel/sanctum
```

### 2.3 Configure .env
Update file `.env`:
```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=energyhub_db
DB_USERNAME=root
DB_PASSWORD=
```

### 2.4 Setup JWT Authentication
```bash
php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"
php artisan jwt:secret
```

### 2.5 Copy Controller Files
Copy file-file controller dari folder `laravel_api/`:
- `AuthController.php` → `app/Http/Controllers/Api/AuthController.php`
- `ShipmentController.php` → `app/Http/Controllers/Api/ShipmentController.php`
- `ItemController.php` → `app/Http/Controllers/Api/ItemController.php`

### 2.6 Setup Routes
Copy isi dari `laravel_api/api_routes.php` ke `routes/api.php`

### 2.7 Create Models
```bash
php artisan make:model User
php artisan make:model Category
php artisan make:model Shipment
php artisan make:model Item
php artisan make:model ShipmentHistory
php artisan make:model Notification
```

### 2.8 Update config/auth.php
```php
'guards' => [
    'api' => [
        'driver' => 'jwt',
        'provider' => 'users',
    ],
],
```

### 2.9 Start Server
```bash
php artisan serve
```

API akan berjalan di: **http://127.0.0.1:8000/api**

---

## 3. FLUTTER APP INTEGRATION

### 3.1 Update pubspec.yaml
Pastikan sudah ada:
```yaml
http: ^1.6.0
shared_preferences: ^2.5.5
get: ^4.7.3
```

### 3.2 Copy Files
- `lib/services/api_service.dart` - Service untuk API calls
- `lib/views/add_shipment_view.dart` - Form untuk tambah pengiriman/item
- Update `lib/views/home_view.dart` - Tambah FAB (Floating Action Button)

### 3.3 Update auth_controller.dart
Tambahkan token saving pada login:
```dart
// Setelah login berhasil
final prefs = await SharedPreferences.getInstance();
await prefs.setString('authToken', token);
```

### 3.4 Run Flutter App
```bash
flutter run
```

---

## 4. TESTING API

### 4.1 Test dengan Postman/Insomnia

#### Register
```
POST http://127.0.0.1:8000/api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "password_confirmation": "password123",
  "name": "John Doe",
  "phone": "081234567890",
  "address": "Jl. Jalan No. 123",
  "city": "Jakarta"
}
```

#### Login
```
POST http://127.0.0.1:8000/api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login berhasil",
  "data": {
    "user": { ... },
    "token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
  }
}
```

#### Create Shipment (Perlu Authorization)
```
POST http://127.0.0.1:8000/api/shipments
Content-Type: application/json
Authorization: Bearer {TOKEN}

{
  "recipient_name": "Budi",
  "recipient_phone": "081987654321",
  "destination": "Jl. Raya Gatot Subroto No. 1",
  "city_destination": "Bandung"
}
```

#### Get Shipments (Perlu Authorization)
```
GET http://127.0.0.1:8000/api/shipments
Authorization: Bearer {TOKEN}
```

#### Create Item (Perlu Authorization)
```
POST http://127.0.0.1:8000/api/items
Content-Type: application/json
Authorization: Bearer {TOKEN}

{
  "shipment_id": 1,
  "category_id": 1,
  "name": "Laptop",
  "quantity": 2,
  "weight": 5.5,
  "value": 10000000
}
```

---

## 5. TROUBLESHOOTING

### ❌ Error: CORS
**Solusi:**
```bash
composer require fruitcake/laravel-cors
```

Update `config/cors.php`:
```php
'allowed_origins' => ['*'],
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
```

### ❌ Error: Token Invalid
**Penyebab:** Token expired atau tidak di-pass dengan benar
**Solusi:**
- Pastikan header Authorization: `Bearer {TOKEN}`
- Login ulang untuk dapat token baru

### ❌ Error: 404 pada API endpoint
**Penyebab:** Route tidak terdaftar dengan benar
**Solusi:**
```bash
php artisan route:list
```
Verifikasi endpoint terdaftar.

### ❌ Error: Database Connection
**Solusi:**
1. Verifikasi `.env` database credentials
2. Test koneksi:
   ```bash
   php artisan tinker
   DB::connection()->getPDO();
   ```

### ❌ Flutter App Error: Connection Refused
**Penyebab:** API tidak berjalan atau URL salah
**Solusi:**
- Verifikasi `ApiService.baseUrl` di Flutter
- Pastikan API server berjalan: `php artisan serve`

---

## 📱 API ENDPOINTS SUMMARY

### Authentication
- `POST /api/auth/register` - Register user baru
- `POST /api/auth/login` - Login
- `GET /api/auth/me` - Get current user (Protected)
- `POST /api/auth/logout` - Logout (Protected)

### Shipments
- `GET /api/shipments` - Get all shipments (Protected)
- `POST /api/shipments` - Create shipment (Protected)
- `GET /api/shipments/{id}` - Get single shipment (Protected)
- `PUT /api/shipments/{id}` - Update shipment (Protected)
- `DELETE /api/shipments/{id}` - Delete shipment (Protected)

### Items
- `GET /api/items/shipment/{shipmentId}` - Get items by shipment (Protected)
- `POST /api/items` - Create item (Protected)
- `GET /api/items/{id}` - Get single item (Protected)
- `PUT /api/items/{id}` - Update item (Protected)
- `DELETE /api/items/{id}` - Delete item (Protected)

---

## ✅ Next Steps

1. ✅ Setup database dengan SQL schema
2. ✅ Create Laravel API project & controllers
3. ✅ Integrate Flutter dengan API
4. ✅ Test semua endpoints
5. 🚀 Deploy ke production

---

**Created:** April 21, 2026  
**Project:** EnergyHub Logistics
