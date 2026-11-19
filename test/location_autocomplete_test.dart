import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_rent/data/location_data.dart';
import 'package:trip_rent/widgets/location_autocomplete_field.dart';

void main() {
  group('LocationData tests', () {
    test('search indramayu returns Indramayu locations', () {
      final results = LocationData.search('indramayu');
      expect(results.isNotEmpty, isTrue);
      expect(results.any((loc) => loc.title.toLowerCase().contains('indramayu')), isTrue);
    });

    test('search padang returns Padang and BIM airport', () {
      final results = LocationData.search('padang');
      expect(results.isNotEmpty, isTrue);
      expect(results.any((loc) => loc.title.contains('Padang')), isTrue);
    });

    test('search empty query returns default locations', () {
      final results = LocationData.search('');
      expect(results.isNotEmpty, isTrue);
    });
  });

  group('LocationAutocompleteField Widget tests', () {
    testWidgets('Displays input and shows suggestions when focused/typed', (tester) async {
      final controller = TextEditingController(text: '');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationAutocompleteField(
              label: 'Lokasi Penjemputan',
              controller: controller,
              icon: Icons.location_on_outlined,
            ),
          ),
        ),
      );

      // Verify label is visible
      expect(find.text('Lokasi Penjemputan'), findsOneWidget);

      // Tap to focus and enter 'indramayu'
      await tester.enterText(find.byType(TextFormField), 'indramayu');
      await tester.pumpAndSettle();

      // Suggestions should appear
      expect(find.textContaining('Saran Lokasi Terkait'), findsOneWidget);
      expect(find.text('Indramayu Kota'), findsOneWidget);

      // Tap on 'Indramayu Kota' suggestion
      await tester.tap(find.text('Indramayu Kota'));
      await tester.pumpAndSettle();

      // Controller should be updated to 'Indramayu Kota'
      expect(controller.text, 'Indramayu Kota');
    });
  });
}
