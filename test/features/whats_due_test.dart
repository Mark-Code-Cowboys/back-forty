import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/repositories/equipment_repository.dart';
import 'package:back_forty/data/repositories/interval_repository.dart';
import 'package:back_forty/data/repositories/system_repository.dart';
import 'package:back_forty/features/intervals/whats_due_screen.dart';
import 'package:back_forty/features/shell/home_shell.dart';

import '../helpers.dart';

void main() {
  test('dueRows: never-done first, then overdue by age, then upcoming',
      () {
    Interval mk(int id, {int? everyDays, DateTime? lastDone}) => Interval(
        id: id,
        ownerType: OwnerType.system,
        ownerId: 1,
        label: 'i$id',
        everyDays: everyDays ?? 90,
        season: null,
        lastDone: lastDone);
    final systems = [
      System(id: 1, name: 'Well', kind: SystemKind.well, kindLabel: null,
          installDate: null, specs: const {}, notes: null),
    ];
    final now = DateTime(2026, 9, 5);
    final rows = dueRows([
      mk(1, lastDone: DateTime(2026, 8, 1)), // upcoming (Oct 30)
      mk(2, lastDone: DateTime(2026, 5, 1)), // overdue (Jul 30)
      mk(3), // never done
    ], systems, const [], now: now);
    expect([for (final r in rows) r.interval.id], [3, 2, 1]);

    // Orphans (owner gone) are dropped.
    final orphaned = dueRows([mk(4)..toString()], const [], const []);
    expect(orphaned, isEmpty);
  });

  testWidgets('the season\'s to-do list, and Done clears the debt',
      (tester) async {
    final db = makeTestDb();
    final wellId = await SystemRepository(db).create(systemDraft());
    await EquipmentRepository(db)
        .create(equipmentDraft(name: 'The Boat', kind: EquipmentKind.boat));
    final intervals = IntervalRepository(db);
    await intervals.create(OwnerType.system, wellId,
        const IntervalDraft(label: 'Change the filter', everyDays: 90));

    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();
    await tester.tap(find.text("What's due"));
    await tester.pumpAndSettle();

    expect(find.text('Change the filter'), findsOneWidget);
    expect(find.textContaining('never done'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    final row = (await db.select(db.intervals).get()).single;
    expect(row.lastDone, isNotNull);
    expect(find.textContaining('due '), findsOneWidget);
    expect(find.textContaining('never done'), findsNothing);

    await disposeApp(tester);
    await db.close();
  });
}
