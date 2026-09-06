import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../backup/backup_service.dart';
import '../utils/labels.dart';

/// Writes exports to temp files and hands them to the share sheet.
/// The temp directory is injected so tests stay plugin-free.
class ExportService {
  ExportService(this._db, this._share, this._tempDir,
      {PhotoService? photos})
      : _photos = photos; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final ShareLauncher _share;
  final Future<Directory> Function() _tempDir;
  final PhotoService? _photos;

  static String _stamp(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// Every service event as one flattened CSV row joined with its
  /// item — the record a buyer or an insurance adjuster asks for.
  Future<File> shareServiceCsv({DateTime? now}) async {
    final systems = {
      for (final s in await _db.select(_db.systems).get()) s.id: s,
    };
    final equipment = {
      for (final e in await _db.select(_db.equipment).get()) e.id: e,
    };
    final events = await (_db.select(_db.serviceEvents)
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
    final entries = {
      for (final e in await _db.select(_db.appJournalEntries).get()) e.id: e,
    };

    final csv = buildCsv([
      ['item', 'item_type', 'what', 'date', 'cost', 'parts', 'notes'],
      for (final e in events)
        [
          e.ownerType == OwnerType.system
              ? systems[e.ownerId]?.name
              : equipment[e.ownerId]?.name,
          e.ownerType.name,
          serviceKindLabel(e),
          e.date.toIso8601String().substring(0, 10),
          e.costCents == null
              ? null
              : (e.costCents! / 100).toStringAsFixed(2),
          e.partsUsed,
          entries[e.journalEntryId]?.notes,
        ],
    ]);

    final stamp = _stamp(now ?? DateTime.now());
    final file =
        File('${(await _tempDir()).path}/backforty-service-$stamp.csv');
    await file.writeAsString(csv);
    await _share.shareFile(file.path,
        mimeType: 'text/csv', text: 'Back Forty service records ($stamp)');
    return file;
  }

  /// The full log as one zip: export JSON plus receipt photo files.
  Future<File> shareBackup({DateTime? now}) async {
    final store = _photos;
    final bytes = buildBackupArchive(
      exportData: await buildExportData(_db, now: now),
      media: store == null
          ? const {}
          : await _db.journal().collectMedia(store),
    );
    final stamp = _stamp(now ?? DateTime.now());
    final file =
        File('${(await _tempDir()).path}/backforty-backup-$stamp.zip');
    await file.writeAsBytes(bytes);
    await _share.shareFile(file.path,
        mimeType: 'application/zip', text: 'Back Forty backup ($stamp)');
    return file;
  }
}
