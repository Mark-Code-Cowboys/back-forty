import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/repositories/equipment_repository.dart';
import 'package:back_forty/data/repositories/interval_repository.dart';
import 'package:back_forty/data/repositories/service_event_repository.dart';
import 'package:back_forty/data/repositories/system_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late SystemRepository systems;
  late EquipmentRepository equipment;
  late ServiceEventRepository events;
  late IntervalRepository intervals;

  setUp(() {
    db = makeTestDb();
    events = ServiceEventRepository(db);
    intervals = IntervalRepository(db);
    systems =
        SystemRepository(db, events: events, intervals: intervals);
    equipment =
        EquipmentRepository(db, events: events, intervals: intervals);
  });

  tearDown(() => db.close());

  test('the spec sheet round-trips in entry order', () async {
    final id = await systems.create(systemDraft(
        specs: {'GPM': '12', 'Depth': '180 ft', 'Filter': 'FXHTC'}));
    final well = (await systems.watchOne(id).first)!;
    expect(well.specs.keys.toList(), ['GPM', 'Depth', 'Filter']);
    expect(well.specs['Filter'], 'FXHTC');
  });

  test('service history reads the same over systems and equipment',
      () async {
    final wellId = await systems.create(systemDraft());
    final blowerId = await equipment.create(equipmentDraft());
    await events.create(OwnerType.system, wellId,
        eventDraft(kind: ServiceKind.filterChange, costCents: 4500));
    await events.create(OwnerType.equipment, blowerId,
        eventDraft(kind: ServiceKind.oilChange, notes: '5W-30, half quart.'));

    final wellHistory =
        await events.watchForOwner(OwnerType.system, wellId).first;
    expect(wellHistory.single.event.kind, ServiceKind.filterChange);
    final blowerHistory =
        await events.watchForOwner(OwnerType.equipment, blowerId).first;
    expect(blowerHistory.single.notes, '5W-30, half quart.');
  });

  test('deleting a system takes its events, entries, and intervals — '
      'and nothing belonging to the same-id equipment', () async {
    final wellId = await systems.create(systemDraft());
    final blowerId = await equipment.create(equipmentDraft());
    // The polymorphic trap: same numeric id on both sides.
    expect(wellId, blowerId);

    await events.create(OwnerType.system, wellId,
        eventDraft(notes: 'well story',
            photos: const [JournalPhotoDraft(path: 'receipt.jpg')]));
    await events.create(OwnerType.equipment, blowerId,
        eventDraft(notes: 'blower story'));
    await intervals.create(OwnerType.system, wellId,
        const IntervalDraft(label: 'Filter', everyDays: 90));
    await intervals.create(OwnerType.equipment, blowerId,
        const IntervalDraft(label: 'Winterize', season: IntervalSeason.fall));

    await systems.delete(wellId);

    expect(await db.select(db.systems).get(), isEmpty);
    // The equipment's world is untouched.
    final survivors = await db.select(db.serviceEvents).get();
    expect(survivors.single.ownerType, OwnerType.equipment);
    final keptIntervals = await db.select(db.intervals).get();
    expect(keptIntervals.single.label, 'Winterize');
    // The well's journal entry (and photo row) went with it.
    final entries = await db.select(db.appJournalEntries).get();
    expect(entries.single.notes, 'blower story');
    expect(await db.select(db.appJournalPhotos).get(), isEmpty);
  });

  test('event update grows a story; delete cleans the entry', () async {
    final wellId = await systems.create(systemDraft());
    final eventId = await events.create(
        OwnerType.system, wellId, eventDraft(costCents: 30000));
    await events.update(
        eventId,
        eventDraft(
            kind: ServiceKind.pumpOut,
            costCents: 30000,
            notes: 'Pumped. Baffle looked fine.'));
    final history =
        await events.watchForOwner(OwnerType.system, wellId).first;
    expect(history.single.notes, 'Pumped. Baffle looked fine.');

    await events.delete(eventId);
    expect(await db.select(db.appJournalEntries).get(), isEmpty);
  });

  test('interval drafts enforce the XOR; markDone stamps lastDone',
      () async {
    expect(() => IntervalDraft(label: 'bad', everyDays: 90,
            season: IntervalSeason.fall),
        throwsA(isA<AssertionError>()));
    expect(() => IntervalDraft(label: 'bad'),
        throwsA(isA<AssertionError>()));

    final wellId = await systems.create(systemDraft());
    final id = await intervals.create(OwnerType.system, wellId,
        const IntervalDraft(label: 'Filter', everyDays: 90));
    await intervals.markDone(id, when: DateTime(2026, 9, 1));
    final row = (await intervals
            .watchForOwner(OwnerType.system, wellId)
            .first)
        .single;
    expect(row.lastDone, DateTime(2026, 9, 1));
  });
}
