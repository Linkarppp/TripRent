import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_rent/data/mock_database.dart';
import 'package:trip_rent/main.dart';
import 'package:trip_rent/screens/login_screen.dart';
import 'package:trip_rent/screens/register_screen.dart';

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

  testWidgets('App opens on Beranda by default and user is not logged in', (tester) async {
    await tester.pumpWidget(const TripRentApp());
    await tester.pump(const Duration(milliseconds: 500));

    // Must show Beranda and TripRent Luxury
    expect(find.text('TripRent Luxury'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget); // Guest login button on top bar
    expect(TripRentStore.instance.isLoggedIn, isFalse);
  });

  testWidgets('LoginScreen shows option to Register and can navigate to RegisterScreen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Masuk ke TripRent'), findsOneWidget);
    expect(find.text('Belum punya akun TripRent?'), findsOneWidget);
    expect(find.text('Daftar Akun Baru (Register)'), findsOneWidget);

    // Tap Daftar Akun Baru
    await tester.ensureVisible(find.text('Daftar Akun Baru (Register)'));
    await tester.tap(find.text('Daftar Akun Baru (Register)'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text('Buat Akun TripRent'), findsOneWidget);
    expect(find.text('Sudah punya akun? '), findsOneWidget);
  });

  test('TripRentStore authentication logic (register, login, logout)', () {
    final store = TripRentStore.instance;

    // Initially logged out
    store.logout();
    expect(store.isLoggedIn, isFalse);

    // Register a new user
    final regResult = store.register(
      namaLengkap: 'Budi Santoso',
      email: 'budi.santoso@gmail.com',
      noTelp: '081299887766',
      password: 'password123',
    );

    expect(regResult.success, isTrue);
    expect(store.isLoggedIn, isTrue);
    expect(store.currentUser?.namaLengkap, equals('Budi Santoso'));

    // Logout
    store.logout();
    expect(store.isLoggedIn, isFalse);

    // Login with registered user
    final loginResult = store.login(
      identifier: 'budi.santoso@gmail.com',
      password: 'password123',
    );
    expect(loginResult.success, isTrue);
    expect(store.isLoggedIn, isTrue);
    expect(store.currentUser?.email, equals('budi.santoso@gmail.com'));

    // Wrong password test
    store.logout();
    final failResult = store.login(
      identifier: 'budi.santoso@gmail.com',
      password: 'wrongpassword',
    );
    expect(failResult.success, isFalse);
    expect(store.isLoggedIn, isFalse);
  });
}
