import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// An interval being composed. Every-N-days XOR seasonal — asserted
/// here so the CHECK never fires from app code.
class IntervalDraft {
  const IntervalDraft({
    required this.label,
    this.everyDays,
    this.season,
    this.lastDone,
  }) : assert((everyDays == null) != (season == null),
            'An interval repeats every N days OR every season, exactly one');

  final String label;
  final int? everyDays;
  final IntervalSeason? season;
  final DateTime? lastDone;
}

class IntervalRepository {
  IntervalRepository(this._db);

  final AppDatabase _db;

  /// One owner's intervals, A-Z by label.
  Stream<List<Interval>> watchForOwner(OwnerType type, int ownerId) {
    final query = _db.select(_db.intervals)
      ..where((i) =>
          i.ownerType.equalsValue(type) & i.ownerId.equals(ownerId))
      ..orderBy([(i) => OrderingTerm.asc(i.label.lower())]);
    return query.watch();
  }

  /// Every interval on the property — the "What's due" screen sorts
  /// and filters in Dart with interval_math.
  Stream<List<Interval>> watchAll() => _db.select(_db.intervals).watch();

  Future<int> create(OwnerType type, int ownerId, IntervalDraft d) =>
      _db.into(_db.intervals).insert(IntervalsCompanion.insert(
            ownerType: type,
            ownerId: ownerId,
            label: d.label,
            everyDays: Value(d.everyDays),
            season: Value(d.season),
            lastDone: Value(d.lastDone),
          ));

  Future<void> update(int id, IntervalDraft d) {
    return (_db.update(_db.intervals)..where((i) => i.id.equals(id)))
        .write(IntervalsCompanion(
      label: Value(d.label),
      everyDays: Value(d.everyDays),
      season: Value(d.season),
      lastDone: Value(d.lastDone),
    ));
  }

  /// The check-off: stamps when the obligation was met; next-due rolls
  /// forward from here.
  Future<void> markDone(int id, {DateTime? when}) {
    return (_db.update(_db.intervals)..where((i) => i.id.equals(id)))
        .write(IntervalsCompanion(lastDone: Value(when ?? DateTime.now())));
  }

  Future<void> delete(int id) =>
      (_db.delete(_db.intervals)..where((i) => i.id.equals(id))).go();

  /// Owner-deletion cleanup (see ServiceEventRepository.deleteForOwner).
  Future<void> deleteForOwner(OwnerType type, int ownerId) =>
      (_db.delete(_db.intervals)
            ..where((i) =>
                i.ownerType.equalsValue(type) & i.ownerId.equals(ownerId)))
          .go();
}
