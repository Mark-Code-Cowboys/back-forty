import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/repositories/service_event_repository.dart';
import 'package:back_forty/data/repositories/system_repository.dart';
import 'package:back_forty/features/trends/trends_screen.dart';

import '../helpers.dart';

void main() {
  testWidgets('free users get the pitch — and the ungated restore',
      (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const TrendsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('What the land actually costs.'), findsOneWidget);
    expect(find.text('Restore a backup'), findsOneWidget);
    expect(find.text('Total cost of ownership'), findsNothing);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('Pro sees spend, frequency, TCO, and the export buttons',
      (tester) async {
    tester.view.physicalSize = const Size(800, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    final wellId = await SystemRepository(db).create(systemDraft());
    await ServiceEventRepository(db).create(OwnerType.system, wellId,
        eventDraft(costCents: 42500, date: DateTime(2025, 9, 12)));

    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      home: const TrendsScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('1 system · 1 service event'), findsOneWidget);
    expect(find.text(r'Service spend by year ($)'), findsOneWidget);
    expect(find.text('Service events by year'), findsOneWidget);
    expect(find.text('Total cost of ownership'), findsOneWidget);
    expect(find.textContaining(r'$425.00'), findsOneWidget);
    expect(find.text('Share service records as CSV'), findsOneWidget);
    expect(find.text('Back up the whole log'), findsOneWidget);
    expect(find.text('Restore a backup'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
