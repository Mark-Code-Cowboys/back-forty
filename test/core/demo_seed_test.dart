import 'package:flutter_test/flutter_test.dart';

import 'package:back_forty/data/database/seed.dart';

import '../helpers.dart';

void main() {
  test('DEMO_SEED plants the cast with three years of history',
      () async {
    final db = makeTestDb();
    addTearDown(db.close);

    await seedDemoData(db);

    final systems = await db.select(db.systems).get();
    final equipment = await db.select(db.equipment).get();
    final events = await db.select(db.serviceEvents).get();
    final intervals = await db.select(db.intervals).get();
    expect(systems, hasLength(3)); // well, septic, generator
    expect(equipment, hasLength(2)); // snowblower, boat
    expect(events, hasLength(20));
    expect(intervals, hasLength(6));

    // Three years of history for the spend chart.
    expect(events.map((e) => e.date.year).toSet(),
        containsAll([2023, 2024, 2025, 2026]));

    // Every item has a spec sheet — the composer's showcase.
    expect(systems.every((s) => s.specs.isNotEmpty), isTrue);
    expect(equipment.every((e) => e.specs.isNotEmpty), isTrue);

    // The boat checklist carries wisdom.
    final lists = await db.select(db.checklists).get();
    expect(lists.single.steps.where((s) => s.note != null),
        isNotEmpty);

    // Stories on the memorable events.
    final entries = await db.select(db.appJournalEntries).get();
    expect(entries.where((e) => e.notes != null).length,
        greaterThanOrEqualTo(8));
  });

  test('seeding is a no-op on a log with data', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    await seedDemoData(db);
    await seedDemoData(db);
    expect(await db.select(db.systems).get(), hasLength(3));
    expect(await db.select(db.serviceEvents).get(), hasLength(20));
  });
}
