import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:arpuro/main.dart';

void main() {
  testWidgets('ArPuro smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ArPuroApp()));

    expect(find.text('ArPuro'), findsOneWidget);
  });
}
