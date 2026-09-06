import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'converters.dart';

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

/// What a fixed system is. `other` pairs with [Systems.kindLabel].
enum SystemKind {
  well,
  septic,
  generator,
  softener,
  sumpPump,
  waterHeater,
  hvac,
  other,
}

/// What a piece of seasonal equipment is. `other` pairs with
/// [Equipment.kindLabel].
enum EquipmentKind {
  boat,
  outboard,
  snowblower,
  mower,
  tractor,
  sprinklerSystem,
  hotTub,
  pressureWasher,
  chainsaw,
  generatorPortable,
  other,
}

/// Which table a service event or interval hangs off — the land has
/// fixed systems and seasonal equipment, and service history reads the
/// same over both.
enum OwnerType { system, equipment }

/// What was done. `other` pairs with [ServiceEvents.kindLabel].
enum ServiceKind {
  service,
  repair,
  inspection,
  filterChange,
  saltFill,
  pumpOut,
  oilChange,
  bladeSharpen,
  winterize,
  springStart,
  other,
}

/// A seasonal interval's anchor.
enum IntervalSeason { fall, spring }

/// Which end of the season a checklist covers.
enum ChecklistSeason { storeFall, startSpring }

/// A fixed system on the property — the well, the septic, the standby
/// generator. Notes are a plain column; service stories live on the
/// events.
class Systems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get kind => textEnum<SystemKind>()();
  // The user's own word when kind == other.
  TextColumn get kindLabel => text().nullable()();
  DateTimeColumn get installDate => dateTime().nullable()();
  // Freeform spec sheet, label -> value, entry order preserved.
  TextColumn get specs => text()
      .map(const SpecsConverter())
      .withDefault(const Constant('{}'))();
  TextColumn get notes => text().nullable()();
}

/// Seasonal equipment — the boat, the snowblower, the mower.
class Equipment extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get kind => textEnum<EquipmentKind>()();
  // The user's own word when kind == other.
  TextColumn get kindLabel => text().nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get model => text().nullable()();
  TextColumn get serial => text().nullable()();
  TextColumn get specs => text()
      .map(const SpecsConverter())
      .withDefault(const Constant('{}'))();
  TextColumn get notes => text().nullable()();
}

/// One thing done to one thing owned. Polymorphic owner (ownerType +
/// ownerId, no SQL FK possible across two tables) — the repositories
/// own the cleanup when an owner is deleted. The story (notes, receipt
/// and parts-label photos) rides a cc_core journal entry.
class ServiceEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ownerType => textEnum<OwnerType>()();
  IntColumn get ownerId => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get kind => textEnum<ServiceKind>()();
  // The user's own word when kind == other.
  TextColumn get kindLabel => text().nullable()();
  IntColumn get costCents => integer().nullable()();
  TextColumn get partsUsed => text().nullable()();
  // Raw-SQL FK for the same cross-package reason as the journal tables.
  IntColumn get journalEntryId => integer().nullable()();

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (journal_entry_id) REFERENCES journal_entries (id) '
            'ON DELETE SET NULL',
      ];
}

/// A recurring obligation: every N days XOR every fall/spring —
/// exactly one, CHECK-enforced. nextDue is computed in Dart
/// (interval_math.dart), never stored.
class Intervals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ownerType => textEnum<OwnerType>()();
  IntColumn get ownerId => integer()();
  TextColumn get label => text().withLength(min: 1, max: 120)();
  IntColumn get everyDays => integer().nullable()();
  TextColumn get season => textEnum<IntervalSeason>().nullable()();
  DateTimeColumn get lastDone => dateTime().nullable()();

  @override
  List<String> get customConstraints => [
        'CHECK ((every_days IS NULL) != (season IS NULL))',
      ];
}

/// A seasonal checklist, instantiated per equipment per year. The
/// steps carry notes year to year; a new year copies labels and notes
/// with everything unchecked.
class Checklists extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get equipmentId =>
      integer().references(Equipment, #id, onDelete: KeyAction.cascade)();
  TextColumn get season => textEnum<ChecklistSeason>()();
  IntColumn get year => integer()();
  TextColumn get steps => text()
      .map(const ChecklistStepsConverter())
      .withDefault(const Constant('[]'))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {equipmentId, season, year},
      ];
}

@DriftDatabase(tables: [
  Systems,
  Equipment,
  ServiceEvents,
  Intervals,
  Checklists,
  AppJournalEntries,
  AppJournalPhotos,
  AppJournalTags,
])
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
