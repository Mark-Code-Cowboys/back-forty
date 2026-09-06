import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import 'app_database.dart';
import 'converters.dart';

/// Demo log for screenshots and store listing shots:
/// `flutter run --dart-define=DEMO_SEED=true`
///
/// The prompt's cast — well, septic, generator, snowblower, boat —
/// with three years of history, live intervals (one overdue, for the
/// badge shot), and a boat checklist with carried notes. No-op unless
/// the log is empty, so a real log is never polluted.
Future<void> seedDemoData(AppDatabase db) async {
  final existing = await db.select(db.systems).get();
  if (existing.isNotEmpty) return;
  final journal = db.journal();

  Future<int> system(String name, SystemKind kind,
          {DateTime? installed, Map<String, String> specs = const {},
          String? notes}) =>
      db.into(db.systems).insert(SystemsCompanion.insert(
          name: name,
          kind: kind,
          installDate: Value(installed),
          specs: Value(specs),
          notes: Value(notes)));

  Future<int> gear(String name, EquipmentKind kind,
          {int? year, String? model, Map<String, String> specs = const {},
          String? notes}) =>
      db.into(db.equipment).insert(EquipmentCompanion.insert(
          name: name,
          kind: kind,
          year: Value(year),
          model: Value(model),
          specs: Value(specs),
          notes: Value(notes)));

  Future<void> event(OwnerType type, int ownerId, DateTime date,
      ServiceKind kind,
      {int? costCents, String? parts, String? notes}) async {
    int? entryId;
    if (notes != null) {
      entryId = await journal.createEntry(JournalEntryDraft(notes: notes));
    }
    await db.into(db.serviceEvents).insert(ServiceEventsCompanion.insert(
        ownerType: type,
        ownerId: ownerId,
        date: date,
        kind: kind,
        costCents: Value(costCents),
        partsUsed: Value(parts),
        journalEntryId: Value(entryId)));
  }

  Future<void> interval(OwnerType type, int ownerId, String label,
          {int? everyDays, IntervalSeason? season, DateTime? lastDone}) =>
      db.into(db.intervals).insert(IntervalsCompanion.insert(
          ownerType: type,
          ownerId: ownerId,
          label: label,
          everyDays: Value(everyDays),
          season: Value(season),
          lastDone: Value(lastDone)));

  // --- The systems ---
  final well = await system('The Well', SystemKind.well,
      installed: DateTime(2014, 5, 1),
      specs: {'GPM': '12', 'Depth': '180 ft', 'Filter': 'FXHTC',
          'Pressure': '40-60 psi'},
      notes: 'Shutoff behind the pressure tank. Filter wrench hangs on '
          'the pegboard.');
  final septic = await system('Septic', SystemKind.septic,
      installed: DateTime(2009, 8, 1),
      specs: {'Tank': '1000 gal', 'Field lines': '4'},
      notes: 'Lid is 6 paces east of the maple. Riser added 2024.');
  final generator = await system('Standby Generator', SystemKind.generator,
      installed: DateTime(2021, 10, 1),
      specs: {'kW': '22', 'Fuel': 'Propane', 'Oil': '5W-30 synthetic'},
      notes: 'Exercises Mondays 10am. Transfer switch in the basement.');

  // --- The equipment ---
  final blower = await gear('The Snowblower', EquipmentKind.snowblower,
      year: 2021, model: 'Ariens Deluxe 28',
      specs: {'Oil': '5W-30', 'Spark plug': 'CJ8Y', 'Belt': '07200021'},
      notes: 'Shear pins in the coffee can on the shelf.');
  final boat = await gear('The Boat', EquipmentKind.boat,
      year: 2018, model: 'Lund Impact 1775',
      specs: {'Outboard': 'Mercury 115', 'Prop': '13.25x17',
          'Oil': '25W-40 marine'},
      notes: 'Trailer bearings repacked with the fall storage.');

  // --- Three years of history ---
  // The well: filters plus the one scare.
  await event(OwnerType.system, well, DateTime(2023, 4, 12),
      ServiceKind.filterChange, costCents: 4200, parts: 'FXHTC');
  await event(OwnerType.system, well, DateTime(2023, 11, 2),
      ServiceKind.filterChange, costCents: 4400, parts: 'FXHTC');
  await event(OwnerType.system, well, DateTime(2024, 6, 8),
      ServiceKind.repair, costCents: 68500,
      notes: 'Pressure switch died Friday night, of course. Plumber '
          'Saturday rates. Spare switch now lives in the shop.');
  await event(OwnerType.system, well, DateTime(2024, 12, 1),
      ServiceKind.filterChange, costCents: 4600, parts: 'FXHTC');
  await event(OwnerType.system, well, DateTime(2025, 8, 20),
      ServiceKind.filterChange, costCents: 4800, parts: 'FXHTC');
  await event(OwnerType.system, well, DateTime(2026, 5, 14),
      ServiceKind.filterChange, costCents: 4800, parts: 'FXHTC',
      notes: 'Sediment noticeably lighter since the new foot valve.');

  // The septic: the big pump-outs.
  await event(OwnerType.system, septic, DateTime(2023, 9, 12),
      ServiceKind.pumpOut, costCents: 42500,
      notes: "Dale says baffle looks good for another cycle.");
  await event(OwnerType.system, septic, DateTime(2026, 8, 30),
      ServiceKind.pumpOut, costCents: 47500,
      notes: 'Price went up \$50. Still cheaper than a new field.');

  // The generator: annual service.
  await event(OwnerType.system, generator, DateTime(2023, 10, 5),
      ServiceKind.service, costCents: 24900);
  await event(OwnerType.system, generator, DateTime(2024, 10, 8),
      ServiceKind.service, costCents: 26500, parts: 'Oil, filter, plug');
  await event(OwnerType.system, generator, DateTime(2025, 10, 6),
      ServiceKind.service, costCents: 26500,
      notes: 'Ran 31 hours this year — the ice storm week.');

  // The snowblower: the seasonal rhythm.
  await event(OwnerType.equipment, blower, DateTime(2023, 11, 10),
      ServiceKind.oilChange, costCents: 1200, parts: '5W-30');
  await event(OwnerType.equipment, blower, DateTime(2024, 4, 2),
      ServiceKind.winterize,
      notes: 'Fuel off, ran dry, fogged. Ready for the shelf.');
  await event(OwnerType.equipment, blower, DateTime(2024, 11, 12),
      ServiceKind.oilChange, costCents: 1400, parts: '5W-30');
  await event(OwnerType.equipment, blower, DateTime(2025, 11, 8),
      ServiceKind.oilChange, costCents: 1400, parts: '5W-30, plug CJ8Y');

  // The boat: oil, impeller, bearings.
  await event(OwnerType.equipment, boat, DateTime(2024, 5, 18),
      ServiceKind.springStart, costCents: 8900,
      notes: 'Impeller changed — three seasons on the old one was '
          'pushing it.');
  await event(OwnerType.equipment, boat, DateTime(2024, 10, 14),
      ServiceKind.winterize, costCents: 12500);
  await event(OwnerType.equipment, boat, DateTime(2025, 5, 20),
      ServiceKind.springStart, costCents: 4200);
  await event(OwnerType.equipment, boat, DateTime(2025, 10, 12),
      ServiceKind.winterize, costCents: 13500,
      notes: 'Marina rates again. Next year: DIY with the checklist.');
  await event(OwnerType.equipment, boat, DateTime(2026, 5, 16),
      ServiceKind.springStart, costCents: 3800,
      notes: 'First DIY spring start. The checklist earned its keep.');

  // --- Intervals: one overdue on purpose (the badge shot) ---
  await interval(OwnerType.system, well, 'Change the filter',
      everyDays: 180, lastDone: DateTime(2026, 5, 14));
  await interval(OwnerType.system, septic, 'Pump the tank',
      everyDays: 1095, lastDone: DateTime(2026, 8, 30));
  await interval(OwnerType.system, generator, 'Annual service',
      season: IntervalSeason.fall, lastDone: DateTime(2025, 10, 6));
  // Overdue: the generator service anchor (Oct 1) is already past at
  // screenshot time relative to lastDone 2025 — shows the red badge.
  await interval(OwnerType.equipment, blower, 'Pre-season oil change',
      season: IntervalSeason.fall, lastDone: DateTime(2025, 11, 8));
  await interval(OwnerType.equipment, boat, 'Winterize',
      season: IntervalSeason.fall, lastDone: DateTime(2025, 10, 12));
  await interval(OwnerType.equipment, boat, 'Repack trailer bearings',
      everyDays: 730, lastDone: DateTime(2024, 10, 14)); // overdue

  // --- The boat's fall checklist, with carried wisdom ---
  await db.into(db.checklists).insert(ChecklistsCompanion.insert(
      equipmentId: boat,
      season: ChecklistSeason.storeFall,
      year: 2025,
      steps: const Value([
        ChecklistStep(label: 'Fog the engine', done: true,
            note: 'Fogging oil is in the red cabinet'),
        ChecklistStep(label: 'Drain the livewell', done: true),
        ChecklistStep(label: 'Battery to the basement', done: true,
            note: 'Tender on the workbench outlet'),
        ChecklistStep(label: 'Stabilizer in the tank', done: true,
            note: '2 oz per 5 gal, run 10 minutes'),
      ])));
}
