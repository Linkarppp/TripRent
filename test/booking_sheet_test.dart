import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_rent/models/car.dart';
import 'package:trip_rent/screens/booking_sheet.dart';
import 'package:trip_rent/theme/app_theme.dart';

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
    HttpOverrides.global = _TestHttpOverrides();
    SharedPreferences.setMockInitialValues({});
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  final carMobilSaja = Car(
    id: 1,
    nama: 'Toyota All New Avanza',
    namaSeo: 'toyota-all-new-avanza',
    hargaSewa: 350000,
    hargaSopir: 150000,
    durasi: 1,
    termasuk: 'Mobil Saja',
    mesin: '1500cc',
    tahun: '2023',
    kapasitas: '7 Penumpang',
    stok: 5,
    keterangan: 'Mobil nyaman',
    gambarUtama: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=500',
    category: 'MPV',
  );

  final carMobilSopir = Car(
    id: 2,
    nama: 'Toyota Alphard VIP',
    namaSeo: 'toyota-alphard-vip',
    hargaSewa: 1500000,
    hargaSopir: 250000,
    durasi: 1,
    termasuk: 'Mobil + Sopir',
    mesin: '2500cc',
    tahun: '2024',
    kapasitas: '6 Penumpang',
    stok: 2,
    keterangan: 'Luxury car',
    gambarUtama: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=500',
    category: 'Luxury',
  );

  testWidgets('Car with "Mobil Saja" defaults to no driver (lepas kunci) and updates dynamically when toggled', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: BookingSheet(car: carMobilSaja),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify car title
    expect(find.text('Toyota All New Avanza'), findsOneWidget);

    // Verify header text matches "Mobil Saja (Lepas Kunci)"
    expect(find.textContaining('Mobil Saja (Lepas Kunci)'), findsOneWidget);
    expect(find.text('Lepas Kunci'), findsOneWidget);

    // Verify Switch is OFF (false)
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    Switch switchWidget = tester.widget(switchFinder);
    expect(switchWidget.value, isFalse);

    // Toggle the switch ON
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // Verify header updates to Mobil + Sopir
    expect(find.textContaining('Mobil + Sopir'), findsOneWidget);
    expect(find.text('Aktif'), findsOneWidget);

    switchWidget = tester.widget(switchFinder);
    expect(switchWidget.value, isTrue);

    // Toggle the switch back OFF
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(find.textContaining('Mobil Saja (Lepas Kunci)'), findsOneWidget);
    expect(find.text('Lepas Kunci'), findsOneWidget);
  });

  testWidgets('Car with "Mobil + Sopir" defaults to driver enabled (true)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: BookingSheet(car: carMobilSopir),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Toyota Alphard VIP'), findsOneWidget);
    expect(find.textContaining('Mobil + Sopir'), findsOneWidget);
    expect(find.text('Aktif'), findsOneWidget);

    final switchFinder = find.byType(Switch);
    final Switch switchWidget = tester.widget(switchFinder);
    expect(switchWidget.value, isTrue);
  });
}
