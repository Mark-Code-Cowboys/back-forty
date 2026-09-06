import 'package:flutter_test/flutter_test.dart';

import 'package:back_forty/app.dart';

import 'helpers.dart';

void main() {
  testWidgets('boots: onboarding once, then the shell', (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const AppRoot()));
    await tester.pumpAndSettle();

    expect(find.textContaining('scaffold is alive'), findsOneWidget);
    await tester.ensureVisible(find.text('Just look around'));
    await tester.tap(find.text('Just look around'));
    await tester.pumpAndSettle();

    expect(find.text('Back Forty'), findsOneWidget);
    expect(find.text('Service records for everything on your land.'),
        findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
