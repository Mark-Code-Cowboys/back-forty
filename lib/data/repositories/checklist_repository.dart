import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/converters.dart';

class ChecklistRepository {
  ChecklistRepository(this._db);

  final AppDatabase _db;

  /// One equipment's checklist for a season+year, live.
  Stream<Checklist?> watchFor(
      int equipmentId, ChecklistSeason season, int year) {
    final query = _db.select(_db.checklists)
      ..where((c) =>
          c.equipmentId.equals(equipmentId) &
          c.season.equalsValue(season) &
          c.year.equals(year));
    return query.watchSingleOrNull();
  }

  /// The year's checklist, created on first open: a fresh year copies
  /// the most recent prior year's step labels AND notes (the wisdom
  /// carries), with everything unchecked. A first-ever checklist
  /// starts empty for the user to build.
  Future<Checklist> instantiateForYear(
      int equipmentId, ChecklistSeason season, int year) async {
    final existing = await (_db.select(_db.checklists)
          ..where((c) =>
              c.equipmentId.equals(equipmentId) &
              c.season.equalsValue(season) &
              c.year.equals(year)))
        .getSingleOrNull();
    if (existing != null) return existing;

    final prior = await (_db.select(_db.checklists)
          ..where((c) =>
              c.equipmentId.equals(equipmentId) &
              c.season.equalsValue(season) &
              c.year.isSmallerThanValue(year))
          ..orderBy([(c) => OrderingTerm.desc(c.year)])
          ..limit(1))
        .getSingleOrNull();
    final steps = [
      for (final step in prior?.steps ?? const <ChecklistStep>[])
        ChecklistStep(label: step.label, note: step.note),
    ];
    final id = await _db.into(_db.checklists).insert(
        ChecklistsCompanion.insert(
            equipmentId: equipmentId,
            season: season,
            year: year,
            steps: Value(steps)));
    return (_db.select(_db.checklists)..where((c) => c.id.equals(id)))
        .getSingle();
  }

  /// Replaces the checklist's steps (check-offs, edits, reorders — the
  /// screen owns the list, this persists it).
  Future<void> saveSteps(int id, List<ChecklistStep> steps) {
    return (_db.update(_db.checklists)..where((c) => c.id.equals(id)))
        .write(ChecklistsCompanion(steps: Value(steps)));
  }
}
