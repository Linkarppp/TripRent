import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_rent/data/mock_database.dart';
import 'package:trip_rent/main.dart';
import 'package:trip_rent/screens/admin_screen.dart';
import 'package:trip_rent/screens/admin/admin_dashboard.dart';
import 'package:trip_rent/screens/user/user_dashboard.dart';
import 'package:trip_rent/screens/driver/driver_dashboard.dart';
import 'package:trip_rent/screens/profile_screen.dart';
import 'package:trip_rent/models/driver.dart';

final Uint8List _transparentPng = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
}

class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_transparentPng).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    HttpOverrides.global = _TestHttpOverrides();
  });

  setUp(() {
    TripRentStore.instance.logout();
  });

  group('TripRent 3-Role Authentication & Access Control', () {
    test('1. Admin login successfully identifies role admin and grants full access', () {
      final res = TripRentStore.instance.login(
        identifier: 'admin@triprent.com',
        password: 'admin123',
      );

      expect(res.success, isTrue);
      expect(res.user, isNotNull);
      expect(res.user!.role, equals('admin'));
      expect(res.user!.isAdmin, isTrue);
      expect(TripRentStore.instance.isLoggedIn, isTrue);
      expect(TripRentStore.instance.currentUser?.role, equals('admin'));
    });

    test('2. Customer/User login successfully identifies role user', () {
      final res = TripRentStore.instance.login(
        identifier: 'user@triprent.com',
        password: 'password123',
      );

      expect(res.success, isTrue);
      expect(res.user, isNotNull);
      expect(res.user!.role, equals('user'));
      expect(res.user!.isUser, isTrue);
      expect(res.user!.isAdmin, isFalse);
    });

    test('3. Driver/Supir login successfully identifies role driver and resolves driver profile', () {
      final res = TripRentStore.instance.login(
        identifier: 'driver@triprent.com',
        password: 'driver123',
      );

      expect(res.success, isTrue);
      expect(res.user, isNotNull);
      expect(res.user!.role, equals('driver'));
      expect(res.user!.isDriver, isTrue);

      final currentDriver = TripRentStore.instance.currentDriver;
      expect(currentDriver, isNotNull);
      expect(currentDriver!.nama, equals('Robby Prihandaya'));
    });

    test('4. Supir can only view orders assigned to them', () {
      TripRentStore.instance.login(
        identifier: 'driver@triprent.com',
        password: 'driver123',
      );

      final tasks = TripRentStore.instance.driverTasks;
      expect(tasks, isNotEmpty);
      for (final task in tasks) {
        expect(
          task.driverId == 1 || (task.driver != null && task.driver!.id == 1) || task.driver?.nama == 'Robby Prihandaya',
          isTrue,
        );
      }
    });

    test('5. Admin can create driver account and new driver can login', () {
      final newDriver = Driver(
        id: 999,
        nama: 'Budi Santoso',
        jenisKelamin: 'Laki-laki',
        tempatLahir: 'Bukittinggi',
        tanggalLahir: '1992-08-17',
        alamat: 'Jl. Sudirman No. 12, Padang',
        keterangan: 'Driver Berpengalaman Rute Wisata',
        foto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        noHp: '081299887766',
        rating: 5.0,
        totalPerjalanan: 10,
        tersedia: true,
      );

      TripRentStore.instance.addDriver(
        newDriver,
        username: 'budidriver',
        password: 'passwordbudi',
      );

      // Verify driver added
      expect(TripRentStore.instance.drivers.any((d) => d.id == 999), isTrue);

      // Verify login with new driver credentials
      TripRentStore.instance.logout();
      final loginRes = TripRentStore.instance.login(
        identifier: 'budidriver',
        password: 'passwordbudi',
      );

      expect(loginRes.success, isTrue);
      expect(loginRes.user?.role, equals('driver'));
      expect(loginRes.user?.namaLengkap, equals('Budi Santoso'));
    });

    test('6. Driver can update status ketersediaan and task progress', () {
      TripRentStore.instance.login(
        identifier: 'driver@triprent.com',
        password: 'driver123',
      );

      final driver = TripRentStore.instance.currentDriver!;
      TripRentStore.instance.updateDriverAvailability(driver.id, 'Dalam Perjalanan');
      expect(TripRentStore.instance.currentDriver?.statusKetersediaan, equals('Dalam Perjalanan'));

      // Update task status
      final tasks = TripRentStore.instance.driverTasks;
      if (tasks.isNotEmpty) {
        final orderCode = tasks.first.kodeOrders;
        TripRentStore.instance.updateDriverTaskStatus(orderCode, 'Dalam Perjalanan');
        final updatedOrder = TripRentStore.instance.orders.firstWhere((o) => o.kodeOrders == orderCode);
        expect(updatedOrder.driverTaskStatus, equals('Dalam Perjalanan'));
      }
    });

    test('7. Admin can assign driver to booking and verify transaction', () {
      final order = TripRentStore.instance.orders.first;
      final driver = TripRentStore.instance.drivers.first;

      TripRentStore.instance.assignDriverToOrder(order.kodeOrders, driver.id);
      final assignedOrder = TripRentStore.instance.orders.firstWhere((o) => o.kodeOrders == order.kodeOrders);
      expect(assignedOrder.driver?.id, equals(driver.id));
      expect(assignedOrder.pakaiSopir, isTrue);

      // Verify transaction payment
      if (TripRentStore.instance.transactions.isNotEmpty) {
        final trx = TripRentStore.instance.transactions.first;
        TripRentStore.instance.verifyPayment(trx.orderCode, 'Lunas');
        final updatedOrder = TripRentStore.instance.orders.firstWhere((o) => o.kodeOrders == trx.orderCode);
        expect(updatedOrder.paymentStatus, equals('Lunas'));
      }
    });
  });

  group('TripRent UI Role-Based Routing (AuthGate)', () {
    testWidgets('Guest / Not logged in routes to UserDashboard', (tester) async {
      await tester.pumpWidget(const TripRentApp());
      await tester.pumpAndSettle();

      expect(find.byType(UserDashboard), findsOneWidget);
      expect(find.byType(AdminDashboard), findsNothing);
      expect(find.byType(DriverDashboard), findsNothing);
    });

    testWidgets('Admin user routes to AdminDashboard with 5 nav items', (tester) async {
      TripRentStore.instance.login(
        identifier: 'admin@triprent.com',
        password: 'admin123',
      );

      await tester.pumpWidget(const TripRentApp());
      await tester.pumpAndSettle();

      expect(find.byType(AdminDashboard), findsOneWidget);
      expect(find.byType(AdminScreen), findsOneWidget);
      expect(find.text('Panel Admin TripRent'), findsOneWidget);

      // Verify 5 Bottom Navigation Bar items for Admin
      expect(find.text('Armada'), findsOneWidget);
      expect(find.text('Pesanan'), findsWidgets);
      expect(find.text('Supir'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
    });

    testWidgets('Customer user routes to UserDashboard with 4 nav items', (tester) async {
      TripRentStore.instance.login(
        identifier: 'user@triprent.com',
        password: 'password123',
      );

      await tester.pumpWidget(const TripRentApp());
      await tester.pumpAndSettle();

      expect(find.byType(UserDashboard), findsOneWidget);
      expect(find.byType(AdminDashboard), findsNothing);
      expect(find.byType(DriverDashboard), findsNothing);

      // Verify 4 Bottom Navigation Bar items for User: Beranda, Armada, Pesanan, Profil
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Armada'), findsOneWidget);
      expect(find.text('Pesanan'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
      expect(find.text('Sopir'), findsNothing);
    });

    testWidgets('Driver user routes to DriverDashboard with 4 nav items', (tester) async {
      TripRentStore.instance.login(
        identifier: 'driver@triprent.com',
        password: 'driver123',
      );

      await tester.pumpWidget(const TripRentApp());
      await tester.pumpAndSettle();

      expect(find.byType(DriverDashboard), findsOneWidget);
      expect(find.text('PORTAL SUPIR'), findsOneWidget);
      expect(find.byType(AdminDashboard), findsNothing);

      // Verify 4 Bottom Navigation Bar items for Driver: Beranda, Tugas, Riwayat, Profil
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Tugas'), findsOneWidget);
      expect(find.text('Riwayat'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
    });
  });

  group('TripRent Dynamic Profile Screen per Role', () {
    testWidgets('User Profile shows user menus and HIDES Panel Admin and Supir menus', (tester) async {
      TripRentStore.instance.login(
        identifier: 'user@triprent.com',
        password: 'password123',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Allowed User Menus
      expect(find.text('Pesanan Saya'), findsOneWidget);
      expect(find.text('Favorit'), findsOneWidget);
      expect(find.text('Metode Pembayaran'), findsOneWidget);
      expect(find.text('Bantuan & FAQ'), findsOneWidget);
      expect(find.text('Tentang TripRent'), findsOneWidget);

      // Hidden from User
      expect(find.text('Panel Admin TripRent'), findsNothing);
      expect(find.text('Status Ketersediaan Supir'), findsNothing);
      expect(find.text('Tugas Perjalanan Saya'), findsNothing);
      expect(find.text('Lisensi & SIM Driver'), findsNothing);
      expect(find.text('SOP & Panduan Pengemudi'), findsNothing);
    });

    testWidgets('Admin Profile shows Panel Admin TripRent and admin menus', (tester) async {
      TripRentStore.instance.login(
        identifier: 'admin@triprent.com',
        password: 'admin123',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Admin Menus
      expect(find.text('Panel Admin TripRent'), findsOneWidget);
      expect(find.text('ADMIN AKTIF'), findsOneWidget);
      expect(find.text('Kelola Akun Pengguna'), findsOneWidget);
      expect(find.text('Verifikasi Transaksi Pembayaran'), findsOneWidget);
      expect(find.text('Laporan Penjualan'), findsOneWidget);
      expect(find.text('Rekening Resmi Perusahaan'), findsOneWidget);
      expect(find.text('Bantuan & FAQ'), findsOneWidget);
      expect(find.text('Tentang TripRent'), findsOneWidget);

      // Hidden from Admin
      expect(find.text('Status Ketersediaan Supir'), findsNothing);
      expect(find.text('Tugas Perjalanan Saya'), findsNothing);
    });

    testWidgets('Driver Profile shows supir menus and HIDES Panel Admin', (tester) async {
      TripRentStore.instance.login(
        identifier: 'driver@triprent.com',
        password: 'driver123',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Driver Menus
      expect(find.text('Status Ketersediaan Supir'), findsOneWidget);
      expect(find.text('Tugas Perjalanan Saya'), findsOneWidget);
      expect(find.text('Riwayat Perjalanan Selesai'), findsOneWidget);
      expect(find.text('Lisensi & SIM Driver'), findsOneWidget);
      expect(find.text('SOP & Panduan Pengemudi'), findsOneWidget);
      expect(find.text('Dispatcher / CS TripRent'), findsOneWidget);
      expect(find.text('Tentang TripRent'), findsOneWidget);

      // Hidden from Driver
      expect(find.text('Panel Admin TripRent'), findsNothing);
      expect(find.text('Favorit'), findsNothing);
    });
  });
}
