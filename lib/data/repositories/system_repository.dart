import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'interval_repository.dart';
import 'service_event_repository.dart';

/// A system being composed.
class SystemDraft {
  const SystemDraft({
    required this.name,
    required this.kind,
    this.kindLabel,
    this.installDate,
    this.specs = const {},
    this.notes,
  });

  final String name;
  final SystemKind kind;
  final String? kindLabel;
  final DateTime? installDate;
  final Map<String, String> specs;
  final String? notes;
}

class SystemRepository {
  SystemRepository(this._db,
      {ServiceEventRepository? events, IntervalRepository? intervals})
      : _events = events ?? ServiceEventRepository(_db),
        _intervals = intervals ?? IntervalRepository(_db);

  final AppDatabase _db;
  final ServiceEventRepository _events;
  final IntervalRepository _intervals;

  /// All systems, A-Z.
  Stream<List<System>> watchAll() {
    final query = _db.select(_db.systems)
      ..orderBy([(s) => OrderingTerm.asc(s.name.lower())]);
    return query.watch();
  }

  /// One-shot list for the importers (matching by name).
  Future<List<System>> getAll() => _db.select(_db.systems).get();

  Stream<System?> watchOne(int id) {
    final query = _db.select(_db.systems)..where((s) => s.id.equals(id));
    return query.watchSingleOrNull();
  }

  /// Systems on the property — feeds `FreeLimit(3, 'systems')`. Live
  /// count, rig semantics: the well you replaced shouldn't lock the
  /// free tier (and systems barely churn anyway — Phase C decides
  /// finally).
  Future<int> count() async {
    final countExp = _db.systems.id.count();
    final query = _db.selectOnly(_db.systems)..addColumns([countExp]);
    return (await query.getSingle()).read(countExp)!;
  }

  Future<int> create(SystemDraft d) =>
      _db.into(_db.systems).insert(_companion(d));

  Future<void> update(int id, SystemDraft d) {
    return (_db.update(_db.systems)..where((s) => s.id.equals(id)))
        .write(_companion(d));
  }

  /// How many service events a delete would take with it.
  Future<int> eventCount(int id) async {
    final countExp = _db.serviceEvents.id.count();
    final query = _db.selectOnly(_db.serviceEvents)
      ..addColumns([countExp])
      ..where(_db.serviceEvents.ownerType.equalsValue(OwnerType.system) &
          _db.serviceEvents.ownerId.equals(id));
    return (await query.getSingle()).read(countExp)!;
  }

  /// Deletes the system and everything polymorphically owned by it —
  /// service events (journal entries included) and intervals.
  Future<void> delete(int id) async {
    await _events.deleteForOwner(OwnerType.system, id);
    await _intervals.deleteForOwner(OwnerType.system, id);
    await (_db.delete(_db.systems)..where((s) => s.id.equals(id))).go();
  }

  SystemsCompanion _companion(SystemDraft d) => SystemsCompanion.insert(
        name: d.name,
        kind: d.kind,
        kindLabel: Value(d.kind == SystemKind.other ? d.kindLabel : null),
        installDate: Value(d.installDate),
        specs: Value(d.specs),
        notes: Value(d.notes),
      );
}
