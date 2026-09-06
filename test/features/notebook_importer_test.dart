import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/repositories/equipment_repository.dart';
import 'package:back_forty/data/repositories/service_event_repository.dart';
import 'package:back_forty/data/repositories/system_repository.dart';
import 'package:back_forty/features/scan_import/notebook_importer.dart';
import 'package:back_forty/features/scan_import/service_page_parser.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late SystemRepository systems;
  late EquipmentRepository equipment;
  late ServiceEventRepository events;

  setUp(() {
    db = makeTestDb();
    systems = SystemRepository(db);
    equipment = EquipmentRepository(db);
    events = ServiceEventRepository(db);
  });

  tearDown(() => db.close());

  test('matches systems first, then equipment; unknown names become '
      'other-kind equipment', () async {
    final wellId = await systems.create(systemDraft(name: 'The Well'));
    await equipment.create(equipmentDraft(name: 'The Snowblower'));

    final report = await insertServicePages(
      systems: systems,
      equipment: equipment,
      events: events,
      drafts: [
        ServicePageDraft(
            itemName: 'the well', // case-insensitive
            date: DateTime(2025, 9, 12),
            kind: ServiceKind.filterChange,
            costCents: 4500),
        ServicePageDraft(
            itemName: 'The Snowblower', kind: ServiceKind.oilChange),
        ServicePageDraft(itemName: 'Mystery Pump'),
        ServicePageDraft(costCents: 1200), // no name: skipped
      ],
    );
    expect(report.eventsAdded, 3);
    expect(report.itemsCreated, 1);
    expect(report.pagesSkipped, 1);

    final wellHistory = await db.select(db.serviceEvents).get();
    expect(wellHistory, hasLength(3));
    final wellEvent = wellHistory
        .singleWhere((e) => e.ownerType == OwnerType.system);
    expect(wellEvent.ownerId, wellId);
    expect(wellEvent.costCents, 4500);

    final created = (await equipment.getAll())
        .singleWhere((e) => e.name == 'Mystery Pump');
    expect(created.kind, EquipmentKind.other);
  });

  test('re-running the same drafts files duplicate events (pages are '
      'not keyed) but never duplicate items', () async {
    final drafts = [ServicePageDraft(itemName: 'Mystery Pump')];
    await insertServicePages(
        systems: systems, equipment: equipment, events: events,
        drafts: drafts);
    await insertServicePages(
        systems: systems, equipment: equipment, events: events,
        drafts: drafts);
    expect((await equipment.getAll()), hasLength(1));
    expect(await db.select(db.serviceEvents).get(), hasLength(2));
  });
}
