import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/features/trends/trends_math.dart';

ServiceEvent event(int id,
        {OwnerType ownerType = OwnerType.system,
        int ownerId = 1,
        DateTime? date,
        int? costCents}) =>
    ServiceEvent(
      id: id,
      ownerType: ownerType,
      ownerId: ownerId,
      date: date ?? DateTime(2026, 6, 1),
      kind: ServiceKind.service,
      kindLabel: null,
      costCents: costCents,
      partsUsed: null,
      journalEntryId: null,
    );

void main() {
  final systems = [
    System(id: 1, name: 'The Well', kind: SystemKind.well, kindLabel: null,
        installDate: null, specs: const {}, notes: null),
  ];
  final equipment = [
    EquipmentData(id: 1, name: 'The Boat', kind: EquipmentKind.boat,
        kindLabel: null, year: null, model: null, serial: null,
        specs: const {}, notes: null),
  ];

  test('costByYear sums cents to whole dollars; costless events skip',
      () {
    final spend = costByYear([
      event(1, date: DateTime(2025, 3, 1), costCents: 42500),
      event(2, date: DateTime(2025, 9, 1), costCents: 4550),
      event(3, date: DateTime(2026, 4, 1), costCents: 9900),
      event(4, date: DateTime(2026, 5, 1)), // no cost
    ]);
    expect(spend, {2025: 471, 2026: 99});
  });

  test('eventsByYear counts everything, costed or not', () {
    expect(
        eventsByYear([
          event(1, date: DateTime(2025, 3, 1)),
          event(2, date: DateTime(2026, 4, 1), costCents: 100),
          event(3, date: DateTime(2026, 5, 1)),
        ]),
        {2025: 1, 2026: 2});
  });

  test('tcoRows: most expensive first, costless events still count, '
      'same-id owners never merge', () {
    final rows = tcoRows([
      event(1, costCents: 42500), // well
      event(2), // well, costless
      event(3, ownerType: OwnerType.equipment, costCents: 9900), // boat
    ], systems, equipment);
    expect(rows, hasLength(2));
    expect(rows.first, (name: 'The Well', events: 2, totalCents: 42500));
    expect(rows.last, (name: 'The Boat', events: 1, totalCents: 9900));
  });
}
