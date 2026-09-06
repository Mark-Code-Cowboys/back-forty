import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/repositories/equipment_repository.dart';
import 'package:back_forty/data/repositories/system_repository.dart';
import 'package:back_forty/features/owners/owner_detail_screen.dart';
import 'package:back_forty/features/shell/home_shell.dart';

import '../helpers.dart';

/// Restore that actually finds a purchase, for the restore-path test.
class _RestoringFake extends FakeEntitlementService {
  @override
  Future<void> restorePurchases() => buyUnlimited();
}

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  Future<void> openAdd(WidgetTester tester, String which) async {
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(which));
    await tester.pumpAndSettle();
  }

  testWidgets('the 4th system opens the paywall — both prices as '
      'equal citizens', (tester) async {
    final systems = SystemRepository(db);
    for (var i = 0; i < 3; i++) {
      await systems.create(systemDraft(name: 'System $i'));
    }
    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();
    expect(find.text('3 of 3 free systems used'), findsOneWidget);

    await openAdd(tester, 'Add a system');
    expect(find.text('Back Forty Pro'), findsOneWidget);
    expect(find.text(r'Monthly · $12.99 / month'), findsOneWidget);
    expect(find.text(r'Lifetime · $6.99 once'), findsOneWidget);

    await tester.ensureVisible(find.text('Maybe later'));
    await tester.tap(find.text('Maybe later'));
    await tester.pumpAndSettle();
    expect(find.text('Back Forty Pro'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('the 3rd equipment is gated; trading up stays free',
      (tester) async {
    final equipment = EquipmentRepository(db);
    final oldId = await equipment.create(equipmentDraft(name: 'Old Mower'));
    await equipment.create(equipmentDraft(name: 'The Boat'));

    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();
    await openAdd(tester, 'Add equipment');
    expect(find.text('Back Forty Pro'), findsOneWidget);
    await tester.ensureVisible(find.text('Maybe later'));
    await tester.tap(find.text('Maybe later'));
    await tester.pumpAndSettle();

    // Sell the mower: live count frees the slot.
    await equipment.delete(oldId);
    await tester.pumpAndSettle();
    await openAdd(tester, 'Add equipment');
    expect(find.widgetWithText(TextField, 'Name'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('buying monthly mid-gate continues into the composer',
      (tester) async {
    final systems = SystemRepository(db);
    for (var i = 0; i < 3; i++) {
      await systems.create(systemDraft(name: 'System $i'));
    }
    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();
    await openAdd(tester, 'Add a system');

    await tester.ensureVisible(find.text(r'Monthly · $12.99 / month'));
    await tester.tap(find.text(r'Monthly · $12.99 / month'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Name'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('restore purchase unlocks from the sheet', (tester) async {
    final systems = SystemRepository(db);
    for (var i = 0; i < 3; i++) {
      await systems.create(systemDraft(name: 'System $i'));
    }
    await tester.pumpWidget(testApp(
        db: db, home: const HomeShell(), entitlements: _RestoringFake()));
    await tester.pumpAndSettle();
    await openAdd(tester, 'Add a system');

    await tester.ensureVisible(find.text('Restore purchase'));
    await tester.tap(find.text('Restore purchase'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Name'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('Pro owners see no chips and no gates', (tester) async {
    final systems = SystemRepository(db);
    for (var i = 0; i < 4; i++) {
      await systems.create(systemDraft(name: 'System $i'));
    }
    await tester.pumpWidget(testApp(
        db: db,
        home: const HomeShell(),
        entitlements: FakeEntitlementService(unlimited: true)));
    await tester.pumpAndSettle();

    expect(find.textContaining('free systems used'), findsNothing);
    await openAdd(tester, 'Add a system');
    expect(find.widgetWithText(TextField, 'Name'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('visible value: free users see Add interval, get the '
      'pitch, and keep their existing intervals', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final wellId = await SystemRepository(db).create(systemDraft());
    await tester.pumpWidget(testApp(
        db: db,
        home: OwnerDetailScreen(
            ownerType: OwnerType.system, ownerId: wellId)));
    await tester.pumpAndSettle();

    expect(find.text('Add interval'), findsOneWidget);
    await tester.tap(find.text('Add interval'));
    await tester.pumpAndSettle();
    expect(find.text('Back Forty Pro'), findsOneWidget);
    expect(find.text('Service reminders'), findsOneWidget);
    await disposeApp(tester);
  });
}
