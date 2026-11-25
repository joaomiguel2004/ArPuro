import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart' show XFile;
import 'package:arpuro/features/home/presentation/home_screen.dart';
import 'package:arpuro/features/camera/domain/captured_photo.dart';
import 'package:arpuro/features/report/presentation/new_report_screen.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets(
    'Navigates to Mapa tab, filters occurrences, and opens report detail',
    (WidgetTester tester) async {
      await tester.pumpWidget(testApp(const HomeScreen()));
      await tester.pumpAndSettle();

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
    },
  );

  testWidgets(
    'Opens camera via FAB, receives photo, selects category, toggles anonymous, and submits',
    (WidgetTester tester) async {
      var cameraOpenCount = 0;
      final fakePhoto = CapturedPhoto(
        file: XFile('fake/photo.jpg'),
        capturedAt: DateTime.now(),
        latitude: -10.9472,
        longitude: -37.0731,
      );

      await tester.pumpWidget(
        testApp(
          HomeScreen(
            openCamera: (_) async {
              cameraOpenCount++;
              return fakePhoto;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

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

      // Success dialog with XP progress
      expect(find.text('Alerta Registrado!'), findsOneWidget);
      // Perfil novo: 0 XP -> +50 XP no nível 1 (0 a 100 XP)
      expect(find.text('NÍVEL 1: OBSERVADOR'), findsOneWidget);
      expect(find.text('+50 XP'), findsOneWidget);
      expect(find.text('50 / 100 XP'), findsOneWidget);

      // Back to Início tab
      await tester.tap(find.text('Voltar ao Início'));
      await tester.pumpAndSettle();
      expect(find.text('Alerta Registrado!'), findsNothing);
      expect(find.text('Qualidade Boa'), findsOneWidget);
    },
  );

  testWidgets('Nova Denúncia shows offline pill and warning when offline', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      testApp(const Scaffold(body: NewReportScreen(isOffline: true))),
    );

    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Localização Anexada'), findsNothing);
    expect(
      find.textContaining('Sem conexão de internet no momento.'),
      findsOneWidget,
    );
  });
}
