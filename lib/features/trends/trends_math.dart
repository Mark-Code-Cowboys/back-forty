import '../../data/database/app_database.dart';

/// Service spend per year, in whole dollars (for the bars).
Map<int, int> costByYear(List<ServiceEvent> events) {
  final byYear = <int, int>{};
  for (final e in events) {
    final cost = e.costCents;
    if (cost == null) continue;
    byYear[e.date.year] = (byYear[e.date.year] ?? 0) + cost;
  }
  return {
    for (final entry in byYear.entries) entry.key: (entry.value / 100).round(),
  };
}

/// How often the wrenches come out: events per year.
Map<int, int> eventsByYear(List<ServiceEvent> events) {
  final byYear = <int, int>{};
  for (final e in events) {
    byYear[e.date.year] = (byYear[e.date.year] ?? 0) + 1;
  }
  return byYear;
}

/// One item's lifetime ledger line.
typedef TcoRow = ({String name, int events, int totalCents});

/// Total cost of ownership per item, most expensive first (ties by
/// event count, then A-Z). Items with no events don't appear; events
/// without a cost still count toward frequency.
List<TcoRow> tcoRows(
  List<ServiceEvent> events,
  List<System> systems,
  List<EquipmentData> equipment,
) {
  final names = <(OwnerType, int), String>{
    for (final s in systems) (OwnerType.system, s.id): s.name,
    for (final e in equipment) (OwnerType.equipment, e.id): e.name,
  };
  final sums = <String, (int events, int cents)>{};
  for (final e in events) {
    final name = names[(e.ownerType, e.ownerId)];
    if (name == null) continue;
    final (count, cents) = sums[name] ?? (0, 0);
    sums[name] = (count + 1, cents + (e.costCents ?? 0));
  }
  final rows = [
    for (final entry in sums.entries)
      (
        name: entry.key,
        events: entry.value.$1,
        totalCents: entry.value.$2
      ),
  ]..sort((a, b) {
      final byCost = b.totalCents.compareTo(a.totalCents);
      if (byCost != 0) return byCost;
      final byEvents = b.events.compareTo(a.events);
      return byEvents != 0 ? byEvents : a.name.compareTo(b.name);
    });
  return rows;
}
