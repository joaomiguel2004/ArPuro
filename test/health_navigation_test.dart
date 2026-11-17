import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arpuro/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('Navigates to Saúde tab, interacts with check-in and Tendência modal, and returns to Início',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Starts on Início
    expect(find.text('Qualidade Boa'), findsOneWidget);

    // Tap Saúde in bottom navigation bar
    await tester.tap(find.text('Saúde'));
    await tester.pumpAndSettle();

    // Saúde screen content is visible
    expect(find.text('Guia de Saúde'), findsOneWidget);
    expect(find.text('Ar Limpo & Seguro'), findsOneWidget);
    expect(find.text('Como você está respirando hoje?'), findsOneWidget);
    expect(find.text('Recomendações do Dia'), findsOneWidget);
    expect(find.text('Atividades Externas'), findsOneWidget);
    expect(find.text('Atenção à Hidratação'), findsOneWidget);

    // Tap Fadiga and Tosse options
    await tester.tap(find.text('Fadiga'));
    await tester.pump();
    await tester.tap(find.text('Tosse'));
    await tester.pump();

    // Tap Tendência to open Previsão Sazonal sheet
    await tester.tap(find.text('Tendência'));
    await tester.pumpAndSettle();

    expect(find.text('Previsão Sazonal'), findsOneWidget);
    expect(find.text('Aracaju, SE • Próximos 4 meses'), findsOneWidget);
    expect(find.text('SET'), findsOneWidget);
    expect(find.text('OUT'), findsOneWidget);
    expect(find.text('NOV'), findsOneWidget);
    expect(find.text('DEZ'), findsOneWidget);
    expect(find.text('ALERTA CRÍTICO SE APROXIMA'), findsOneWidget);

    // Dismiss sheet using action button
    await tester.tap(find.text('Entendi, preparar inalador'));
    await tester.pumpAndSettle();
    expect(find.text('Previsão Sazonal'), findsNothing);

    // Navigate back to Início
    await tester.tap(find.text('Início'));
    await tester.pumpAndSettle();
    expect(find.text('Qualidade Boa'), findsOneWidget);
  });
}
