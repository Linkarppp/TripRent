import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_rent/data/mock_database.dart';
import 'package:trip_rent/models/car.dart';
import 'package:trip_rent/models/driver.dart';
import 'package:trip_rent/models/user.dart';
import 'package:trip_rent/screens/admin_screen.dart';

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
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('AdminScreen displays cars and drivers tabs', (tester) async {
    TripRentStore.instance.login(identifier: 'robby', password: 'password123');
    await tester.pumpWidget(
      const MaterialApp(
        home: AdminScreen(bypassAuthForTesting: true),
      ),
    );
    await tester.pump();

    expect(find.text('Panel Admin TripRent'), findsOneWidget);
    expect(find.text('Data Mobil'), findsOneWidget);
    expect(find.text('Data Sopir'), findsOneWidget);
    expect(find.text('Data User'), findsOneWidget);
    expect(find.text('Pesanan'), findsOneWidget);
    expect(find.text('Laporan Penjualan'), findsOneWidget);
    expect(find.text('Tambah Mobil'), findsOneWidget);
  });

  test('TripRentStore car and driver CRUD operations', () {
    final store = TripRentStore.instance;

    final initialCarCount = store.cars.length;
    final testCar = Car(
      id: 9999,
      nama: 'Toyota Fortuner GR Sport',
      namaSeo: 'toyota-fortuner-gr-sport',
      hargaSewa: 750000,
      hargaSopir: 200000,
      durasi: 1,
      termasuk: 'Mobil Saja',
      mesin: '2800 cc Diesel',
      tahun: '2024',
      kapasitas: '7 Orang',
      stok: 4,
      keterangan: 'SUV tangguh untuk segala medan',
      gambarUtama: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341',
      category: 'SUV',
    );

    // Add car
    store.addCar(testCar);
    expect(store.cars.length, equals(initialCarCount + 1));
    expect(store.cars.first.nama, equals('Toyota Fortuner GR Sport'));

    // Update car
    final updatedCar = testCar.copyWith(hargaSewa: 800000);
    store.updateCar(updatedCar);
    expect(store.cars.firstWhere((c) => c.id == 9999).hargaSewa, equals(800000));

    // Delete car
    store.deleteCar(9999);
    expect(store.cars.length, equals(initialCarCount));

    // Driver CRUD
    final initialDriverCount = store.drivers.length;
    final testDriver = Driver(
      id: 8888,
      nama: 'Hendra Saputra',
      jenisKelamin: 'Laki-laki',
      tempatLahir: 'Bukittinggi',
      tanggalLahir: '1991-03-20',
      alamat: 'Jl. Sudirman No. 12',
      keterangan: 'Driver ramah dan paham rute wisata',
      foto: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      noHp: '0812-9999-8888',
    );

    // Add driver
    store.addDriver(testDriver);
    expect(store.drivers.length, equals(initialDriverCount + 1));
    expect(store.drivers.first.nama, equals('Hendra Saputra'));

    // Update driver
    final updatedDriver = testDriver.copyWith(nama: 'Hendra Saputra Senior');
    store.updateDriver(updatedDriver);
    expect(store.drivers.firstWhere((d) => d.id == 8888).nama, equals('Hendra Saputra Senior'));

    // Delete driver
    store.deleteDriver(8888);
    expect(store.drivers.length, equals(initialDriverCount));

    // User CRUD
    final initialUserCount = store.users.length;
    const testUser = User(
      id: 'test_user_777',
      username: 'johndoe',
      email: 'johndoe@example.com',
      namaLengkap: 'John Doe',
      noTelp: '08123456789',
      password: 'pass',
      role: 'admin',
    );

    store.addUser(testUser);
    expect(store.users.length, equals(initialUserCount + 1));
    expect(store.users.first.email, equals('johndoe@example.com'));

    final updatedUser = testUser.copyWith(namaLengkap: 'John Doe Updated');
    store.updateUser(updatedUser);
    expect(store.users.firstWhere((u) => u.id == 'test_user_777').namaLengkap, equals('John Doe Updated'));

    store.deleteUser('test_user_777');
    expect(store.users.length, equals(initialUserCount));

    // Order status update
    if (store.orders.isNotEmpty) {
      final firstCode = store.orders.first.kodeOrders;
      store.updateOrderStatus(firstCode, 'Selesai');
      expect(store.orders.firstWhere((o) => o.kodeOrders == firstCode).status, equals('Selesai'));
    }
  });
}
