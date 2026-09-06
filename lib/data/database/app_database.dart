import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// This database's concrete journal repository type (cc_core's
/// JournalRepository is generic over the generated table classes).
typedef AppJournalRepository = JournalRepository<$AppJournalEntriesTable,
    $AppJournalPhotosTable, $AppJournalTagsTable>;

// Thin local registrations of cc_core's journal tables (drift can't
// analyze table classes across package boundaries in the default build
// mode, and @UseRowClass doesn't inherit). Names pinned to the shared
// schema so backups stay fleet-compatible.
@UseRowClass(JournalEntry)
class AppJournalEntries extends JournalEntries {
  @override
  String get tableName => 'journal_entries';
}

@UseRowClass(JournalPhoto)
class AppJournalPhotos extends JournalPhotos {
  @override
  String get tableName => 'journal_photos';
}

@UseRowClass(JournalTag)
class AppJournalTags extends JournalTags {
  @override
  String get tableName => 'journal_tags';
}

/// PHASE A: add the app's domain tables here (with raw-SQL FKs to
/// journal_entries — see Hitch Post's Visits for the pattern) and list
/// them in @DriftDatabase. Then `dart run build_runner build`.
@DriftDatabase(tables: [AppJournalEntries, AppJournalPhotos, AppJournalTags])
class AppDatabase extends _$AppDatabase {
  /// Creates the database over any executor (tests pass an in-memory
  /// NativeDatabase).
  AppDatabase(super.e);

  /// The on-device database file.
  factory AppDatabase.open() =>
      AppDatabase(driftDatabase(name: 'back_forty'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// cc_core's journal repository over this database's tables.
  AppJournalRepository journal({PhotoFileStore? photoStore}) =>
      JournalRepository(
        this,
        entries: appJournalEntries,
        photos: appJournalPhotos,
        tags: appJournalTags,
        photoStore: photoStore,
      );
}
