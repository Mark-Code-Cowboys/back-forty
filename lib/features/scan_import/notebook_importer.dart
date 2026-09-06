import '../../data/database/app_database.dart';
import '../../data/repositories/equipment_repository.dart';
import '../../data/repositories/service_event_repository.dart';
import '../../data/repositories/system_repository.dart';
import 'service_page_parser.dart';

/// What a notebook import did, for the wrap-up line.
class NotebookImportReport {
  const NotebookImportReport({
    required this.eventsAdded,
    required this.itemsCreated,
    required this.pagesSkipped,
  });

  final int eventsAdded;

  /// Names that matched nothing and became equipment (kind: other).
  final int itemsCreated;

  /// Pages without a usable item name.
  final int pagesSkipped;

  String get summary {
    final parts = [
      'Filed $eventsAdded ${eventsAdded == 1 ? 'event' : 'events'}',
      if (itemsCreated > 0)
        '$itemsCreated new ${itemsCreated == 1 ? 'item' : 'items'}',
      if (pagesSkipped > 0)
        '$pagesSkipped ${pagesSkipped == 1 ? 'page' : 'pages'} had no '
            'item name and were skipped',
    ];
    return parts.join(' · ');
  }
}

/// Files reviewed pages as service events. Item names are matched
/// case-insensitively against systems first, then equipment; a name
/// matching nothing becomes new EQUIPMENT with kind `other` — the
/// converter can't know a well from a mower, so the review screen says
/// so and the user recategorizes later. Pages without dates are filed
/// under today.
Future<NotebookImportReport> insertServicePages({
  required SystemRepository systems,
  required EquipmentRepository equipment,
  required ServiceEventRepository events,
  required List<ServicePageDraft> drafts,
}) async {
  final systemRows = await systems.getAll();
  final equipmentRows = await equipment.getAll();
  final systemByName = {
    for (final s in systemRows) s.name.trim().toLowerCase(): s.id,
  };
  final equipmentByName = {
    for (final e in equipmentRows) e.name.trim().toLowerCase(): e.id,
  };

  var added = 0, created = 0, skipped = 0;
  for (final draft in drafts) {
    final name = draft.itemName?.trim();
    if (name == null || name.isEmpty) {
      skipped++;
      continue;
    }
    final key = name.toLowerCase();

    OwnerType type;
    int ownerId;
    if (systemByName.containsKey(key)) {
      type = OwnerType.system;
      ownerId = systemByName[key]!;
    } else if (equipmentByName.containsKey(key)) {
      type = OwnerType.equipment;
      ownerId = equipmentByName[key]!;
    } else {
      type = OwnerType.equipment;
      ownerId = await equipment.create(
          EquipmentDraft(name: name, kind: EquipmentKind.other));
      equipmentByName[key] = ownerId;
      created++;
    }

    await events.create(
      type,
      ownerId,
      ServiceEventDraft(
        date: draft.date ?? DateTime.now(),
        kind: draft.kind,
        kindLabel: draft.kindLabel,
        costCents: draft.costCents,
      ),
    );
    added++;
  }
  return NotebookImportReport(
    eventsAdded: added,
    itemsCreated: created,
    pagesSkipped: skipped,
  );
}
