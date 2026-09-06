import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/repositories/equipment_repository.dart';
import 'package:back_forty/data/repositories/interval_repository.dart';
import 'package:back_forty/data/repositories/system_repository.dart';
import 'package:back_forty/features/home/home_screen.dart';
import 'package:back_forty/features/shell/home_shell.dart';

import '../helpers.dart';

void main() {
  test('worstObligation: overdue beats upcoming, sooner beats later', () {
    Interval mk(int id, {int? everyDays, DateTime? lastDone}) => Interval(
        id: id,
        ownerType: OwnerType.system,
        ownerId: 1,
        label: 'i$id',
        everyDays: everyDays,
        season: null,
        lastDone: lastDone);
    final now = DateTime(2026, 9, 5);
    final worst = worstObligation([
      mk(1, everyDays: 365, lastDone: DateTime(2026, 6, 1)), // upcoming
      mk(2, everyDays: 30, lastDone: DateTime(2026, 7, 1)), // overdue
    ], OwnerType.system, 1, now: now);
    expect(worst!.overdue, isTrue);
    expect(worst.due, DateTime(2026, 7, 31));
  });

  testWidgets('two sections, free chips, and the overdue badge',
      (tester) async {
    final db = makeTestDb();
    final wellId = await SystemRepository(db).create(systemDraft());
    await EquipmentRepository(db).create(equipmentDraft());
    await IntervalRepository(db).create(OwnerType.system, wellId,
        const IntervalDraft(label: 'Filter', everyDays: 90));

    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();

    expect(find.text('Systems'), findsOneWidget);
    expect(find.text('Equipment'), findsOneWidget);
    expect(find.text('1 of 3 free systems used'), findsOneWidget);
    expect(find.text('1 of 2 free equipment used'), findsOneWidget);
    // Never-done interval: the well owes.
    expect(find.text('Overdue'), findsOneWidget);

    await tester.tap(find.text('The Well'));
    await tester.pumpAndSettle();
    expect(find.text('Obligations'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('empty state names the fear', (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();
    expect(find.text('Service records for everything on your land.'),
        findsOneWidget);
    await disposeApp(tester);
    await db.close();
  });
}
