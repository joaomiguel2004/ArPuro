import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart' show XFile;
import 'package:arpuro/features/home/presentation/home_screen.dart';
import 'package:arpuro/features/camera/domain/captured_photo.dart';

void main() {
  testWidgets('Navigates to Mapa tab, filters occurrences, and opens report detail',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Tap Mapa in bottom navigation bar
    await tester.tap(find.text('Mapa'));
    await tester.pumpAndSettle();

    expect(find.text('Buscar região ou bairro...'), findsOneWidget);
    expect(find.text('Todos'), findsOneWidget);
    expect(find.text('🔥 Queimadas'), findsOneWidget);
    expect(find.text('💧 Água/Esgoto'), findsOneWidget);
    expect(find.text('12 km/h'), findsOneWidget);
    expect(find.text('VENTO NE'), findsOneWidget);
    expect(find.text('Atenção na Região'), findsOneWidget);
    expect(find.text('Foco de fumaça a 800m à frente.'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);

    // Filter by Água/Esgoto
    await tester.tap(find.text('💧 Água/Esgoto'));
    await tester.pumpAndSettle();
    expect(find.text('12'), findsNothing);
    expect(find.text('1 ocorrência(s) ativa(s) na região.'), findsOneWidget);

    // Return to Todos
    await tester.tap(find.text('Todos'));
    await tester.pumpAndSettle();
    expect(find.text('Foco de fumaça a 800m à frente.'), findsOneWidget);

    // Tap RegionAlertCard to open detail sheet
    await tester.tap(find.text('Atenção na Região'));
    await tester.pumpAndSettle();
    expect(find.text('Foco de fumaça intensa'), findsOneWidget);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
  });

  testWidgets('Opens camera via FAB, receives photo, selects category, toggles anonymous, and submits',
      (WidgetTester tester) async {
    var cameraOpenCount = 0;
    final fakePhoto = CapturedPhoto(
      file: XFile('fake/photo.jpg'),
      capturedAt: DateTime.now(),
      latitude: -10.9472,
      longitude: -37.0731,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          openCamera: (_) async {
            cameraOpenCount++;
            return fakePhoto;
          },
        ),
      ),
    );

    // Tap camera FAB -> camera returns the photo -> Nova Denúncia
    await tester.tap(find.byIcon(Icons.camera_alt_outlined));
    await tester.pumpAndSettle();
    expect(cameraOpenCount, 1);

    expect(find.text('Localização Anexada'), findsOneWidget);
    expect(find.text('Nova Denúncia'), findsOneWidget);
    expect(find.text('Revise a foto e envie para a rede.'), findsOneWidget);
    expect(find.text('10.9472° S, 37.0731° W'), findsOneWidget);
    expect(find.text('O que você fotografou?'), findsOneWidget);
    expect(find.text('Denúncia Anônima'), findsOneWidget);
    expect(find.text('Sua identidade está oculta'), findsOneWidget);

    // Refazer reopens the camera
    await tester.tap(find.text('Refazer'));
    await tester.pumpAndSettle();
    expect(cameraOpenCount, 2);
    expect(find.text('Nova Denúncia'), findsOneWidget);

    // Select Lixo / Entulho
    await tester.tap(find.text('Lixo / Entulho'));
    await tester.pump();

    // Toggle Denúncia Anônima off
    await tester.ensureVisible(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(find.text('Seu nome ficará visível na rede'), findsOneWidget);

    // Submit report
    await tester.ensureVisible(find.text('Enviar para a Comunidade'));
    await tester.tap(find.text('Enviar para a Comunidade'));
    await tester.pumpAndSettle();

    // Confirmation snackbar and navigated to Mapa
    expect(
      find.text('Denúncia de Lixo / Entulho enviada para a comunidade!'),
      findsOneWidget,
    );
    expect(find.text('Buscar região ou bairro...'), findsOneWidget);
  });
}
