import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:stream_transform/stream_transform.dart';

import '../database/app_database.dart';

/// A service event joined with its story (notes, receipt photos).
class EventWithStory {
  const EventWithStory(this.event, {this.entry, this.photos = const []});

  final ServiceEvent event;
  final JournalEntry? entry;
  final List<JournalPhoto> photos;

  String? get notes => entry?.notes;
}

/// A service event being composed. Notes/photos land in the journal
/// tables.
class ServiceEventDraft {
  const ServiceEventDraft({
    required this.date,
    required this.kind,
    this.kindLabel,
    this.costCents,
    this.partsUsed,
    this.notes,
    this.photos = const [],
  });

  final DateTime date;
  final ServiceKind kind;
  final String? kindLabel;
  final int? costCents;
  final String? partsUsed;
  final String? notes;
  final List<JournalPhotoDraft> photos;

  bool get hasStory => notes != null || photos.isNotEmpty;
}

class ServiceEventRepository {
  ServiceEventRepository(this._db, {AppJournalRepository? journal})
      : _journalOverride = journal; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final AppJournalRepository? _journalOverride;
  late final AppJournalRepository _journal =
      _journalOverride ?? _db.journal();

  /// One owner's history, newest first, each with its story.
  Stream<List<EventWithStory>> watchForOwner(OwnerType type, int ownerId) {
    final query = _db.select(_db.serviceEvents)
      ..where((e) =>
          e.ownerType.equalsValue(type) & e.ownerId.equals(ownerId))
      ..orderBy([
        (e) => OrderingTerm.desc(e.date),
        (e) => OrderingTerm.desc(e.id),
      ]);
    return _withStories(query.watch());
  }

  /// Every event, raw — cost math and trends work across the book.
  Stream<List<ServiceEvent>> watchAllRaw() =>
      _db.select(_db.serviceEvents).watch();

  /// Creates the event (and its journal entry when there's a story)
  /// atomically; returns the event id.
  Future<int> create(OwnerType type, int ownerId, ServiceEventDraft d) {
    return _db.transaction(() async {
      int? entryId;
      if (d.hasStory) {
        entryId = await _journal.createEntry(
            JournalEntryDraft(notes: d.notes, photos: d.photos));
      }
      return _db
          .into(_db.serviceEvents)
          .insert(_companion(type, ownerId, d, entryId));
    });
  }

  /// Rewrites the event's fields and notes. Photos are managed
  /// separately via [addPhoto]/[removePhoto].
  Future<void> update(int id, ServiceEventDraft d) {
    return _db.transaction(() async {
      final event = await (_db.select(_db.serviceEvents)
            ..where((e) => e.id.equals(id)))
          .getSingle();
      var entryId = event.journalEntryId;
      if (entryId == null && d.hasStory) {
        entryId =
            await _journal.createEntry(JournalEntryDraft(notes: d.notes));
      } else if (entryId != null) {
        await _journal.updateEntry(entryId, notes: d.notes);
      }
      await (_db.update(_db.serviceEvents)..where((e) => e.id.equals(id)))
          .write(_companion(event.ownerType, event.ownerId, d, entryId));
    });
  }

  /// Attaches a photo, creating the entry if the event had no story.
  Future<void> addPhoto(int id, JournalPhotoDraft photo) {
    return _db.transaction(() async {
      final event = await (_db.select(_db.serviceEvents)
            ..where((e) => e.id.equals(id)))
          .getSingle();
      var entryId = event.journalEntryId;
      if (entryId == null) {
        entryId = await _journal.createEntry(const JournalEntryDraft());
        await (_db.update(_db.serviceEvents)
              ..where((e) => e.id.equals(id)))
            .write(ServiceEventsCompanion(journalEntryId: Value(entryId)));
      }
      await _journal.addPhoto(entryId, photo);
    });
  }

  /// Removes one photo (row and file).
  Future<void> removePhoto(int photoId) => _journal.removePhoto(photoId);

  /// Deletes one event and its journal entry.
  Future<void> delete(int id) async {
    final event = await (_db.select(_db.serviceEvents)
          ..where((e) => e.id.equals(id)))
        .getSingleOrNull();
    await (_db.delete(_db.serviceEvents)..where((e) => e.id.equals(id)))
        .go();
    final entryId = event?.journalEntryId;
    if (entryId != null) await _journal.deleteEntries([entryId]);
  }

  /// Owner-deletion cleanup: removes every event (and journal entry,
  /// photo files included) hanging off [type]/[ownerId]. The owner
  /// tables can't cascade into a polymorphic child, so the owning
  /// repositories call this inside their delete.
  Future<void> deleteForOwner(OwnerType type, int ownerId) async {
    final entryId = _db.serviceEvents.journalEntryId;
    final query = _db.selectOnly(_db.serviceEvents)
      ..addColumns([entryId])
      ..where(_db.serviceEvents.ownerType.equalsValue(type) &
          _db.serviceEvents.ownerId.equals(ownerId) &
          entryId.isNotNull());
    final entryIds = [
      for (final row in await query.get()) row.read(entryId)!,
    ];
    await (_db.delete(_db.serviceEvents)
          ..where((e) =>
              e.ownerType.equalsValue(type) & e.ownerId.equals(ownerId)))
        .go();
    if (entryIds.isNotEmpty) await _journal.deleteEntries(entryIds);
  }

  Stream<List<EventWithStory>> _withStories(
      Stream<List<ServiceEvent>> events) {
    final entries = _db.select(_db.appJournalEntries).watch();
    final photos = (_db.select(_db.appJournalPhotos)
          ..orderBy([(p) => OrderingTerm.asc(p.id)]))
        .watch();
    return events
        .combineLatest(entries,
            (List<ServiceEvent> e, List<JournalEntry> j) => (e, j))
        .combineLatest(photos, (pair, List<JournalPhoto> p) {
      final (eventRows, entryRows) = pair;
      final byId = {for (final e in entryRows) e.id: e};
      return [
        for (final event in eventRows)
          EventWithStory(
            event,
            entry: byId[event.journalEntryId],
            photos: [
              for (final photo in p)
                if (photo.entryId == event.journalEntryId) photo,
            ],
          ),
      ];
    });
  }

  ServiceEventsCompanion _companion(
          OwnerType type, int ownerId, ServiceEventDraft d, int? entryId) =>
      ServiceEventsCompanion.insert(
        ownerType: type,
        ownerId: ownerId,
        date: d.date,
        kind: d.kind,
        kindLabel: Value(d.kind == ServiceKind.other ? d.kindLabel : null),
        costCents: Value(d.costCents),
        partsUsed: Value(d.partsUsed),
        journalEntryId: Value(entryId),
      );
}
