import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/repositories/interval_repository.dart';
import 'package:back_forty/data/repositories/service_event_repository.dart';
import 'package:back_forty/data/repositories/system_repository.dart';
import 'package:back_forty/features/owners/owner_detail_screen.dart';

import '../helpers.dart';

void main() {
  testWidgets('spec sheet, overdue banner, and the timeline',
      (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    final wellId = await SystemRepository(db).create(systemDraft(
        notes: 'Shutoff is behind the pressure tank.'));
    await IntervalRepository(db).create(OwnerType.system, wellId,
        const IntervalDraft(label: 'Change the filter', everyDays: 90));
    await ServiceEventRepository(db).create(OwnerType.system, wellId,
        eventDraft(kind: ServiceKind.filterChange, costCents: 4500,
            partsUsed: 'FXHTC', notes: 'Sediment heavier than spring.'));

    await tester.pumpWidget(testApp(
        db: db,
        home: OwnerDetailScreen(
            ownerType: OwnerType.system, ownerId: wellId)));
    await tester.pumpAndSettle();

    // Spec sheet rows.
    expect(find.text('GPM'), findsOneWidget);
    expect(find.text('180 ft'), findsOneWidget);
    // Never-done interval -> the banner.
    expect(find.text('Overdue: Change the filter'), findsOneWidget);
    // The timeline.
    expect(find.text('Filter change'), findsOneWidget);
    expect(find.textContaining('FXHTC'), findsOneWidget);
    expect(find.textContaining('Sediment heavier'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('kind-aware quick-fill: the septic opens at Pump-out',
      (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    final septicId = await SystemRepository(db).create(
        systemDraft(name: 'Septic', kind: SystemKind.septic, specs: {}));

    await tester.pumpWidget(testApp(
        db: db,
        home: OwnerDetailScreen(
            ownerType: OwnerType.system, ownerId: septicId)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log service'));
    await tester.pumpAndSettle();
    // The dropdown's selected value is the septic default.
    expect(find.text('Pump-out'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
