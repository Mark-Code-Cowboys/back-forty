import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:back_forty/core/backup/backup_service.dart';
import 'package:back_forty/core/export/export_service.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/database/converters.dart';
import 'package:back_forty/data/repositories/checklist_repository.dart';
import 'package:back_forty/data/repositories/equipment_repository.dart';
import 'package:back_forty/data/repositories/interval_repository.dart';
import 'package:back_forty/data/repositories/service_event_repository.dart';
import 'package:back_forty/data/repositories/system_repository.dart';

import '../helpers.dart';

void main() {
  test('backup archive round-trips the whole log', () async {
    final source = makeTestDb();
    addTearDown(source.close);
    final systems = SystemRepository(source);
    final equipment = EquipmentRepository(source);
    final events = ServiceEventRepository(source);
    final intervals = IntervalRepository(source);
    final checklists = ChecklistRepository(source);

    final wellId = await systems.create(systemDraft(
        notes: 'Shutoff behind the tank.'));
    final boatId = await equipment.create(
        equipmentDraft(name: 'The Boat', kind: EquipmentKind.boat));
    await events.create(OwnerType.system, wellId,
        eventDraft(kind: ServiceKind.filterChange, costCents: 4500,
            partsUsed: 'FXHTC', notes: 'Sediment heavy.',
            photos: const [JournalPhotoDraft(path: 'receipt-1.jpg')]));
    await intervals.create(OwnerType.system, wellId,
        IntervalDraft(label: 'Filter', everyDays: 90,
            lastDone: DateTime(2026, 9, 1)));
    final list = await checklists.instantiateForYear(
        boatId, ChecklistSeason.storeFall, 2026);
    await checklists.saveSteps(list.id, const [
      ChecklistStep(label: 'Fog the engine', done: true,
          note: 'Oil in the red cabinet'),
    ]);

    final bytes = buildBackupArchive(
      exportData: await buildExportData(source, now: DateTime(2026, 9, 5)),
      media: {
        'receipt-1.jpg': [1, 2, 3],
      },
    );

    // Restore into a fresh database, as after a reinstall.
    final target = makeTestDb();
    addTearDown(target.close);
    final contents = readBackupArchive(bytes);
    expect(contents.media['receipt-1.jpg'], [1, 2, 3]);
    await restoreFromExportData(target, contents.exportData);

    final restored =
        await buildExportData(target, now: DateTime(2026, 9, 5));
    expect(restored, contents.exportData);

    // Spot checks: specs, steps-with-notes, the polymorphic event.
    final well = (await SystemRepository(target).getAll()).single;
    expect(well.specs['GPM'], '12');
    final history = await ServiceEventRepository(target)
        .watchForOwner(OwnerType.system, wellId)
        .first;
    expect(history.single.notes, 'Sediment heavy.');
    expect(history.single.photos.single.path, 'receipt-1.jpg');
    final restoredList = await ChecklistRepository(target)
        .instantiateForYear(boatId, ChecklistSeason.storeFall, 2026);
    expect(restoredList.steps.single.note, 'Oil in the red cabinet');
    expect(restoredList.steps.single.done, isTrue);
  });

  test('restore rejects foreign or malformed exports', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    expect(
      () => restoreFromExportData(db, {'app': 'FreshPot', 'format': 1}),
      throwsA(isA<InvalidBackupException>()),
    );
    expect(
      () => restoreFromExportData(
          db, {'app': 'BackForty', 'format': 1, 'systems': 'nope'}),
      throwsA(isA<InvalidBackupException>()),
    );
  });

  test('CSV export flattens item + event into one row', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    final wellId = await SystemRepository(db).create(systemDraft());
    await ServiceEventRepository(db).create(OwnerType.system, wellId,
        eventDraft(kind: ServiceKind.pumpOut,
            date: DateTime(2025, 9, 12), costCents: 42500,
            notes: 'Baffle fine.'));

    final share = FakeShareLauncher();
    final temp = await Directory.systemTemp.createTemp('bf-export');
    addTearDown(() => temp.delete(recursive: true));
    final file = await ExportService(db, share, () async => temp)
        .shareServiceCsv(now: DateTime(2026, 9, 5));

    expect(share.sharedFiles, [file.path]);
    expect(file.path, endsWith('backforty-service-2026-09-05.csv'));
    final doc = parseCsv(await file.readAsString());
    final row = doc.rows.single;
    expect(doc.rowCell(row, 0), 'The Well');
    expect(doc.rowCell(row, doc.header.indexOf('what')), 'Pump-out');
    expect(doc.rowCell(row, doc.header.indexOf('cost')), '425.00');
    expect(doc.rowCell(row, doc.header.indexOf('notes')), 'Baffle fine.');
  });
}
