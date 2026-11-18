import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart' show XFile;
import 'package:arpuro/features/camera/data/location_service.dart';
import 'package:arpuro/features/camera/domain/captured_photo.dart';
import 'package:arpuro/features/camera/presentation/camera_screen.dart';

class _FakeLocationService extends LocationService {
  final GeoPoint? result;

  const _FakeLocationService(this.result);

  @override
  Future<GeoPoint?> getCurrentLocation() async => result;
}

void main() {
  group('CapturedPhoto', () {
    test('formats southern/western coordinates', () {
      final photo = CapturedPhoto(
        file: XFile('x.jpg'),
        capturedAt: DateTime(2026, 11, 17, 9, 32),
        latitude: -10.94721,
        longitude: -37.07309,
      );
      expect(photo.coordinatesLabel, '10.9472° S, 37.0731° W');
    });

    test('formats northern/eastern coordinates', () {
      final photo = CapturedPhoto(
        file: XFile('x.jpg'),
        capturedAt: DateTime(2026, 11, 17, 9, 32),
        latitude: 48.8566,
        longitude: 2.3522,
      );
      expect(photo.coordinatesLabel, '48.8566° N, 2.3522° E');
    });

    test('handles missing location', () {
      final photo = CapturedPhoto(
        file: XFile('x.jpg'),
        capturedAt: DateTime(2026, 11, 17, 9, 32),
      );
      expect(photo.hasLocation, isFalse);
      expect(photo.coordinatesLabel, 'Localização indisponível');
    });

    test('time label marks recent photos as "Agora"', () {
      final photo = CapturedPhoto(
        file: XFile('x.jpg'),
        capturedAt: DateTime(2026, 11, 17, 9, 32),
      );
      expect(photo.timeLabel(DateTime(2026, 11, 17, 9, 33)), '09:32 (Agora)');
      expect(photo.timeLabel(DateTime(2026, 11, 17, 10, 0)), '09:32');
    });
  });

  group('CameraScreen', () {
    testWidgets('shows viewfinder UI and active GPS', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CameraScreen(
            locationService: _FakeLocationService(
              (latitude: -10.9472, longitude: -37.0731),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('GPS Ativo'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
      expect(find.bySemanticsLabel('Tirar foto'), findsOneWidget);
      expect(find.text('Enquadre o foco de poluição'), findsOneWidget);
    });

    testWidgets('shows GPS unavailable when location fails', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CameraScreen(locationService: _FakeLocationService(null)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('GPS Indisponível'), findsOneWidget);
    });

    testWidgets('close button pops without a photo', (tester) async {
      CapturedPhoto? result;
      var popped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await Navigator.of(context).push<CapturedPhoto>(
                      MaterialPageRoute(
                        builder: (_) => const CameraScreen(
                          locationService: _FakeLocationService(null),
                        ),
                      ),
                    );
                    popped = true;
                  },
                  child: const Text('Abrir'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();
      expect(find.text('GPS Indisponível'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(popped, isTrue);
      expect(result, isNull);
      expect(find.text('Abrir'), findsOneWidget);
    });
  });
}
