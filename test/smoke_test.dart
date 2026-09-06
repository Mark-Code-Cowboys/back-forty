import 'package:flutter_test/flutter_test.dart';

import 'package:back_forty/app.dart';

import 'helpers.dart';

void main() {
  testWidgets(
      'scaffold boots: onboarding -> home, and the free-tier gate '
      'fires at the cap', (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const AppRoot()));
    await tester.pumpAndSettle();

    // First run lands on onboarding with the privacy promise.
    expect(find.textContaining('scaffold is alive'), findsOneWidget);
    await tester.tap(find.text('Just look around'));
    await tester.pumpAndSettle();

    // The shell, with the placeholder empty state.
    expect(find.text('Back Forty'), findsOneWidget);

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.text('Add entry'));
      await tester.pump();
    }
    expect(find.text('5 of 5 free entries used'), findsOneWidget);

    // The sixth add hits the gate and opens the paywall stub.
    await tester.tap(find.text('Add entry'));
    await tester.pumpAndSettle();
    expect(find.text('Back Forty Pro'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
