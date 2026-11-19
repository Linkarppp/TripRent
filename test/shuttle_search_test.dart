import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_rent/data/mock_database.dart';
import 'package:trip_rent/models/shuttle_schedule.dart';
import 'package:trip_rent/screens/shuttle_schedule_screen.dart';
import 'package:trip_rent/widgets/shuttle_search_card.dart';

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

  group('Shuttle & Travel Real-Life Booking System', () {
    test('1. ShuttleDataHelper returns departure schedules for input route', () {
      final schedules = ShuttleDataHelper.getSchedules(
        origin: 'Padang (Pool Tunggul Hitam)',
        destination: 'Bukittinggi (Pool Jam Gadang)',
        date: DateTime.now().add(const Duration(days: 1)),
        passengers: 2,
      );

      expect(schedules, isNotEmpty);
      expect(schedules.first.originOutlet, contains('Padang'));
      expect(schedules.first.destinationOutlet, contains('Bukittinggi'));
      expect(schedules.first.availableSeats >= 2, isTrue);
      expect(schedules.first.price, greaterThan(0));
    });

    test('2. Time of day filter categorizes morning, afternoon, evening schedules', () {
      final schedules = ShuttleDataHelper.getSchedules(
        origin: 'Padang (Pool Tunggul Hitam)',
        destination: 'Bukittinggi (Pool Jam Gadang)',
        date: DateTime.now(),
        passengers: 1,
      );

      final morning = schedules.where((s) => s.timeOfDayCategory == 'Pagi').toList();
      final afternoon = schedules.where((s) => s.timeOfDayCategory == 'Siang').toList();
      final evening = schedules.where((s) => s.timeOfDayCategory == 'Sore' || s.timeOfDayCategory == 'Malam').toList();

      expect(morning, isNotEmpty);
      expect(afternoon, isNotEmpty);
      expect(evening, isNotEmpty);
    });

    testWidgets('3. ShuttleSearchCard displays input fields and search button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ShuttleSearchCard(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pesan Tiket Shuttle TripRent'), findsOneWidget);
      expect(find.text('Keberangkatan'), findsOneWidget);
      expect(find.text('Tujuan'), findsOneWidget);
      expect(find.text('Tanggal Pergi'), findsOneWidget);
      expect(find.text('Jumlah Penumpang'), findsOneWidget);
      expect(find.text('Cari Jadwal Shuttle'), findsOneWidget);
    });

    testWidgets('4. ShuttleScheduleScreen displays list of matching schedules', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ShuttleScheduleScreen(
            initialOrigin: 'Padang (Pool Tunggul Hitam)',
            initialDestination: 'Bukittinggi (Pool Jam Gadang)',
            initialDate: DateTime.now().add(const Duration(days: 1)),
            initialPassengers: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Jadwal Keberangkatan Shuttle'), findsOneWidget);
      expect(find.text('Padang (Pool Tunggul Hitam)'), findsOneWidget);
      expect(find.text('Bukittinggi (Pool Jam Gadang)'), findsOneWidget);
      expect(find.text('Pilih Kursi'), findsWidgets);
    });
  });
}
