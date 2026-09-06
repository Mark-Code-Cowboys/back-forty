import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../../data/database/converters.dart';

/// The whole log as a JSON-encodable map (format 1). Pure data — photo
/// files are referenced by store name; the archive carries their bytes
/// separately. Journal tables ride cc_core's dumpJournalTables. No
/// lifetime tally here: Back Forty's free tier gates on live counts.
Future<Map<String, Object?>> buildExportData(AppDatabase db,
    {DateTime? now}) async {
  final systems =
      await (db.select(db.systems)..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
  final equipment = await (db.select(db.equipment)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final events = await (db.select(db.serviceEvents)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final intervals = await (db.select(db.intervals)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final checklists = await (db.select(db.checklists)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();

  return {
    'app': 'BackForty',
    'format': 1,
    'exportedAt': (now ?? DateTime.now()).toIso8601String(),
    'systems': [
      for (final s in systems)
        {
          'id': s.id,
          'name': s.name,
          'kind': s.kind.name,
          'kindLabel': s.kindLabel,
          'installDate': s.installDate?.toIso8601String(),
          'specs': s.specs,
          'notes': s.notes,
        },
    ],
    'equipment': [
      for (final e in equipment)
        {
          'id': e.id,
          'name': e.name,
          'kind': e.kind.name,
          'kindLabel': e.kindLabel,
          'year': e.year,
          'model': e.model,
          'serial': e.serial,
          'specs': e.specs,
          'notes': e.notes,
        },
    ],
    'serviceEvents': [
      for (final e in events)
        {
          'id': e.id,
          'ownerType': e.ownerType.name,
          'ownerId': e.ownerId,
          'date': e.date.toIso8601String(),
          'kind': e.kind.name,
          'kindLabel': e.kindLabel,
          'costCents': e.costCents,
          'partsUsed': e.partsUsed,
          'journalEntryId': e.journalEntryId,
        },
    ],
    'intervals': [
      for (final i in intervals)
        {
          'id': i.id,
          'ownerType': i.ownerType.name,
          'ownerId': i.ownerId,
          'label': i.label,
          'everyDays': i.everyDays,
          'season': i.season?.name,
          'lastDone': i.lastDone?.toIso8601String(),
        },
    ],
    'checklists': [
      for (final c in checklists)
        {
          'id': c.id,
          'equipmentId': c.equipmentId,
          'season': c.season.name,
          'year': c.year,
          'steps': [for (final s in c.steps) s.toJson()],
        },
    ],
    ...await db.journal().dumpJournalTables(),
  };
}

DateTime? _date(Object? iso) =>
    iso == null ? null : DateTime.parse(iso as String);

/// Replaces the entire log with the contents of an export. Runs in one
/// transaction; ids are preserved.
Future<void> restoreFromExportData(
    AppDatabase db, Map<String, Object?> data) async {
  if (data['app'] != 'BackForty' || data['format'] != 1) {
    throw const InvalidBackupException('Unrecognized export format');
  }
  final systems = data['systems'];
  final equipment = data['equipment'];
  final events = data['serviceEvents'];
  final intervals = data['intervals'];
  final checklists = data['checklists'];
  if (systems is! List ||
      equipment is! List ||
      events is! List ||
      intervals is! List ||
      checklists is! List) {
    throw const InvalidBackupException('Malformed export tables');
  }

  await db.transaction(() async {
    await db.delete(db.serviceEvents).go();
    await db.delete(db.intervals).go();
    await db.delete(db.systems).go();
    await db.delete(db.equipment).go(); // checklists cascade
    await db.journal().restoreJournalTables(data);

    for (final row in systems.cast<Map<String, dynamic>>()) {
      await db.into(db.systems).insert(SystemsCompanion(
            id: Value(row['id'] as int),
            name: Value(row['name'] as String),
            kind: Value(SystemKind.values.byName(row['kind'] as String)),
            kindLabel: Value(row['kindLabel'] as String?),
            installDate: Value(_date(row['installDate'])),
            specs: Value((row['specs'] as Map<String, dynamic>)
                .cast<String, String>()),
            notes: Value(row['notes'] as String?),
          ));
    }
    for (final row in equipment.cast<Map<String, dynamic>>()) {
      await db.into(db.equipment).insert(EquipmentCompanion(
            id: Value(row['id'] as int),
            name: Value(row['name'] as String),
            kind:
                Value(EquipmentKind.values.byName(row['kind'] as String)),
            kindLabel: Value(row['kindLabel'] as String?),
            year: Value(row['year'] as int?),
            model: Value(row['model'] as String?),
            serial: Value(row['serial'] as String?),
            specs: Value((row['specs'] as Map<String, dynamic>)
                .cast<String, String>()),
            notes: Value(row['notes'] as String?),
          ));
    }
    for (final row in events.cast<Map<String, dynamic>>()) {
      await db.into(db.serviceEvents).insert(ServiceEventsCompanion(
            id: Value(row['id'] as int),
            ownerType:
                Value(OwnerType.values.byName(row['ownerType'] as String)),
            ownerId: Value(row['ownerId'] as int),
            date: Value(_date(row['date'])!),
            kind: Value(ServiceKind.values.byName(row['kind'] as String)),
            kindLabel: Value(row['kindLabel'] as String?),
            costCents: Value(row['costCents'] as int?),
            partsUsed: Value(row['partsUsed'] as String?),
            journalEntryId: Value(row['journalEntryId'] as int?),
          ));
    }
    for (final row in intervals.cast<Map<String, dynamic>>()) {
      await db.into(db.intervals).insert(IntervalsCompanion(
            id: Value(row['id'] as int),
            ownerType:
                Value(OwnerType.values.byName(row['ownerType'] as String)),
            ownerId: Value(row['ownerId'] as int),
            label: Value(row['label'] as String),
            everyDays: Value(row['everyDays'] as int?),
            season: Value(switch (row['season'] as String?) {
              null => null,
              final name => IntervalSeason.values.byName(name),
            }),
            lastDone: Value(_date(row['lastDone'])),
          ));
    }
    for (final row in checklists.cast<Map<String, dynamic>>()) {
      await db.into(db.checklists).insert(ChecklistsCompanion(
            id: Value(row['id'] as int),
            equipmentId: Value(row['equipmentId'] as int),
            season: Value(
                ChecklistSeason.values.byName(row['season'] as String)),
            year: Value(row['year'] as int),
            steps: Value([
              for (final s in row['steps'] as List)
                ChecklistStep.fromJson(s as Map<String, dynamic>),
            ]),
          ));
    }
  });
}
