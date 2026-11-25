import 'package:arpuro/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('Splash faz login anônimo e abre a Home', (tester) async {
    final auth = FakeAuthService();
    await tester.pumpWidget(
      testApp(const ArPuroApp(), auth: auth, wrapInMaterialApp: false),
    );

    expect(find.text('ArPuro'), findsOneWidget);
    expect(auth.calls, 1);

    // Animação da splash (2,5 s) + transição para a Home.
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    expect(find.text('Qualidade Boa'), findsOneWidget);
  });
}
