import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'interval_repository.dart';
import 'service_event_repository.dart';

/// A piece of equipment being composed.
class EquipmentDraft {
  const EquipmentDraft({
    required this.name,
    required this.kind,
    this.kindLabel,
    this.year,
    this.model,
    this.serial,
    this.specs = const {},
    this.notes,
  });

  final String name;
  final EquipmentKind kind;
  final String? kindLabel;
  final int? year;
  final String? model;
  final String? serial;
  final Map<String, String> specs;
  final String? notes;
}

class EquipmentRepository {
  EquipmentRepository(this._db,
      {ServiceEventRepository? events, IntervalRepository? intervals})
      : _events = events ?? ServiceEventRepository(_db),
        _intervals = intervals ?? IntervalRepository(_db);

  final AppDatabase _db;
  final ServiceEventRepository _events;
  final IntervalRepository _intervals;

  /// All equipment, A-Z.
  Stream<List<EquipmentData>> watchAll() {
    final query = _db.select(_db.equipment)
      ..orderBy([(e) => OrderingTerm.asc(e.name.lower())]);
    return query.watch();
  }

  /// One-shot list for the importers (matching by name).
  Future<List<EquipmentData>> getAll() => _db.select(_db.equipment).get();

  Stream<EquipmentData?> watchOne(int id) {
    final query = _db.select(_db.equipment)..where((e) => e.id.equals(id));
    return query.watchSingleOrNull();
  }

  /// Equipment in the shed — feeds `FreeLimit(2, 'equipment')`. Live
  /// count: selling the boat frees the slot (rig semantics).
  Future<int> count() async {
    final countExp = _db.equipment.id.count();
    final query = _db.selectOnly(_db.equipment)..addColumns([countExp]);
    return (await query.getSingle()).read(countExp)!;
  }

  Future<int> create(EquipmentDraft d) =>
      _db.into(_db.equipment).insert(_companion(d));

  Future<void> update(int id, EquipmentDraft d) {
    return (_db.update(_db.equipment)..where((e) => e.id.equals(id)))
        .write(_companion(d));
  }

  /// How many service events a delete would take with it.
  Future<int> eventCount(int id) async {
    final countExp = _db.serviceEvents.id.count();
    final query = _db.selectOnly(_db.serviceEvents)
      ..addColumns([countExp])
      ..where(
          _db.serviceEvents.ownerType.equalsValue(OwnerType.equipment) &
              _db.serviceEvents.ownerId.equals(id));
    return (await query.getSingle()).read(countExp)!;
  }

  /// Deletes the equipment and everything owned by it — service events
  /// (journal entries included), intervals, and (via FK cascade) its
  /// seasonal checklists.
  Future<void> delete(int id) async {
    await _events.deleteForOwner(OwnerType.equipment, id);
    await _intervals.deleteForOwner(OwnerType.equipment, id);
    await (_db.delete(_db.equipment)..where((e) => e.id.equals(id))).go();
  }

  EquipmentCompanion _companion(EquipmentDraft d) =>
      EquipmentCompanion.insert(
        name: d.name,
        kind: d.kind,
        kindLabel:
            Value(d.kind == EquipmentKind.other ? d.kindLabel : null),
        year: Value(d.year),
        model: Value(d.model),
        serial: Value(d.serial),
        specs: Value(d.specs),
        notes: Value(d.notes),
      );
}
