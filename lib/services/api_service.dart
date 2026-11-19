import 'dart:convert';
import 'dart:io';
import '../data/mock_database.dart';
import '../models/car.dart';
import '../models/driver.dart';
import '../models/user.dart';

class ApiService {
  static final ApiService instance = ApiService._internal();
  ApiService._internal();
  factory ApiService() => instance;

  // Base URL backend REST API (default localhost PHP / Apache port 8000)
  String baseUrl = 'http://127.0.0.1:8000';

  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Map<String, String> _buildHeaders({String? role}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    final currentRole = role ?? TripRentStore.instance.currentUser?.role ?? 'user';
    headers['X-Role'] = currentRole;
    if (TripRentStore.instance.currentUser != null) {
      headers['X-User-Id'] = TripRentStore.instance.currentUser!.id;
    }
    return headers;
  }

  // --- 1. Autentikasi & Hak Akses Role ---
  Future<({bool success, String message, User? user})> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/auth.php');
      final request = await client.postUrl(uri);
      final headers = _buildHeaders();
      headers.forEach((k, v) => request.headers.set(k, v));
      request.write(jsonEncode({
        'identifier': identifier,
        'password': password,
      }));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body);
      if (response.statusCode == 200 && json['status'] == true) {
        final userData = json['data']['user'];
        _authToken = json['data']['token'];
        final user = User.fromJson(Map<String, dynamic>.from(userData));
        return (success: true, message: json['message'].toString(), user: user);
      } else {
        return (
          success: false,
          message: json['message']?.toString() ?? 'Gagal masuk akun.',
          user: null
        );
      }
    } catch (_) {
      // Fallback ke TripRentStore lokal
      final res = TripRentStore.instance.login(
        identifier: identifier,
        password: password,
      );
      if (res.success && res.user != null) {
        _authToken = '${res.user!.role}:${res.user!.id}';
      }
      return res;
    }
  }

  Future<({bool success, String message})> register({
    required String namaLengkap,
    required String email,
    required String noTelp,
    required String password,
    String role = 'user',
  }) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/auth.php?action=register');
      final request = await client.postUrl(uri);
      final headers = _buildHeaders(role: role);
      headers.forEach((k, v) => request.headers.set(k, v));
      request.write(jsonEncode({
        'namaLengkap': namaLengkap,
        'email': email,
        'noTelp': noTelp,
        'password': password,
        'role': role,
      }));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body);
      if (response.statusCode == 200 && json['status'] == true) {
        _authToken = json['data']['token'];
        return (success: true, message: json['message'].toString());
      } else {
        return (
          success: false,
          message: json['message']?.toString() ?? 'Gagal mendaftar.'
        );
      }
    } catch (_) {
      return TripRentStore.instance.register(
        namaLengkap: namaLengkap,
        email: email,
        noTelp: noTelp,
        password: password,
        role: role,
      );
    }
  }

  // --- 2. Statistik Dashboard Admin ---
  Future<Map<String, dynamic>> getAdminStatistics() async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/statistics.php');
      final request = await client.getUrl(uri);
      _buildHeaders(role: 'admin').forEach((k, v) => request.headers.set(k, v));
      final response = await request.close();
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final json = jsonDecode(body);
        return Map<String, dynamic>.from(json['data']);
      }
    } catch (_) {}

    // Fallback store
    final store = TripRentStore.instance;
    return {
      'totalCars': store.cars.length,
      'totalUsers': store.countUsers,
      'totalDrivers': store.countActiveDrivers,
      'totalBookings': store.countAllBookings,
      'totalRevenue': store.totalRevenue,
      'pendingPaymentRevenue': store.totalPendingPaymentRevenue,
    };
  }

  // --- 3. Kelola Mobil ---
  Future<void> addCar(Car car) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/cars.php');
      final request = await client.postUrl(uri);
      _buildHeaders(role: 'admin').forEach((k, v) => request.headers.set(k, v));
      request.write(jsonEncode({
        'nama': car.nama,
        'hargaSewa': car.hargaSewa,
        'hargaSopir': car.hargaSopir,
        'durasi': car.durasi,
        'termasuk': car.termasuk,
        'mesin': car.mesin,
        'tahun': car.tahun,
        'kapasitas': car.kapasitas,
        'stok': car.stok,
        'keterangan': car.keterangan,
        'gambarUtama': car.gambarUtama,
        'category': car.category,
        'transmisi': car.transmisi,
      }));
      await request.close();
    } catch (_) {}
    TripRentStore.instance.addCar(car);
  }

  Future<void> updateCar(Car car) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/cars.php');
      final request = await client.putUrl(uri);
      _buildHeaders(role: 'admin').forEach((k, v) => request.headers.set(k, v));
      request.write(jsonEncode({
        'id': car.id,
        'nama': car.nama,
        'hargaSewa': car.hargaSewa,
        'stok': car.stok,
        'keterangan': car.keterangan,
        'gambarUtama': car.gambarUtama,
      }));
      await request.close();
    } catch (_) {}
    TripRentStore.instance.updateCar(car);
  }

  Future<void> deleteCar(int carId) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/cars.php?id=$carId');
      final request = await client.deleteUrl(uri);
      _buildHeaders(role: 'admin').forEach((k, v) => request.headers.set(k, v));
      await request.close();
    } catch (_) {}
    TripRentStore.instance.deleteCar(carId);
  }

  Future<void> toggleCarAvailability(int carId) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/cars.php');
      final request = await client.putUrl(uri);
      _buildHeaders(role: 'admin').forEach((k, v) => request.headers.set(k, v));
      request.write(jsonEncode({'id': carId, 'toggleAktif': true}));
      await request.close();
    } catch (_) {}
    TripRentStore.instance.toggleCarAvailability(carId);
  }

  // --- 4. Kelola Supir ---
  Future<void> addDriver(Driver driver, {String? username, String? password}) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/drivers.php');
      final request = await client.postUrl(uri);
      _buildHeaders(role: 'admin').forEach((k, v) => request.headers.set(k, v));
      request.write(jsonEncode({
        'nama': driver.nama,
        'jenisKelamin': driver.jenisKelamin,
        'tempatLahir': driver.tempatLahir,
        'tanggalLahir': driver.tanggalLahir,
        'alamat': driver.alamat,
        'keterangan': driver.keterangan,
        'foto': driver.foto,
        'noHp': driver.noHp,
        'noSim': driver.noSim,
        'username': username,
        'password': password,
      }));
      await request.close();
    } catch (_) {}
    TripRentStore.instance.addDriver(driver, username: username, password: password);
  }

  Future<void> updateDriverAvailability(int driverId, String status) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/drivers.php');
      final request = await client.putUrl(uri);
      _buildHeaders().forEach((k, v) => request.headers.set(k, v));
      request.write(jsonEncode({
        'id': driverId,
        'statusKetersediaan': status,
      }));
      await request.close();
    } catch (_) {}
    TripRentStore.instance.updateDriverAvailability(driverId, status);
  }

  // --- 5. Kelola Penugasan & Tugas Supir ---
  Future<void> assignDriver(String orderCode, int driverId) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/bookings.php');
      final request = await client.putUrl(uri);
      _buildHeaders(role: 'admin').forEach((k, v) => request.headers.set(k, v));
      request.write(jsonEncode({
        'kodeOrders': orderCode,
        'assignDriverId': driverId,
      }));
      await request.close();
    } catch (_) {}
    TripRentStore.instance.assignDriverToOrder(orderCode, driverId);
  }

  Future<void> updateDriverTaskStatus(String orderCode, String newStatus) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/driver_tasks.php');
      final request = await client.putUrl(uri);
      _buildHeaders(role: 'driver').forEach((k, v) => request.headers.set(k, v));
      request.write(jsonEncode({
        'kodeOrders': orderCode,
        'driverTaskStatus': newStatus,
      }));
      await request.close();
    } catch (_) {}
    TripRentStore.instance.updateDriverTaskStatus(orderCode, newStatus);
  }

  // --- 6. Kelola Transaksi ---
  Future<void> verifyPayment(String orderCode, String status) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final uri = Uri.parse('$baseUrl/api/transactions.php');
      final request = await client.putUrl(uri);
      _buildHeaders(role: 'admin').forEach((k, v) => request.headers.set(k, v));
      request.write(jsonEncode({
        'orderCode': orderCode,
        'status': status,
      }));
      await request.close();
    } catch (_) {}
    TripRentStore.instance.verifyPayment(orderCode, status);
  }
}
