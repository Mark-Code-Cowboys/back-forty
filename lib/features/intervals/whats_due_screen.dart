import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/interval_math.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../owners/owner_detail_screen.dart';

/// Every interval on the property, joined with its owner's name.
final allIntervalsProvider = StreamProvider<List<Interval>>(
  (ref) => ref.watch(intervalRepositoryProvider).watchAll(),
);

final allSystemsProvider = StreamProvider<List<System>>(
  (ref) => ref.watch(systemRepositoryProvider).watchAll(),
);

final allEquipmentProvider = StreamProvider<List<EquipmentData>>(
  (ref) => ref.watch(equipmentRepositoryProvider).watchAll(),
);

/// One row of the What's-due list.
typedef DueRow = ({Interval interval, String ownerName, DateTime? due, bool overdue});

/// Joins, sorts: overdue first (oldest debt first, never-done at the
/// very top), then upcoming by date. Orphan intervals (owner deleted
/// mid-stream) are dropped.
List<DueRow> dueRows(
  List<Interval> intervals,
  List<System> systems,
  List<EquipmentData> equipment, {
  DateTime? now,
}) {
  final systemNames = {for (final s in systems) s.id: s.name};
  final equipmentNames = {for (final e in equipment) e.id: e.name};
  final rows = <DueRow>[];
  for (final i in intervals) {
    final name = i.ownerType == OwnerType.system
        ? systemNames[i.ownerId]
        : equipmentNames[i.ownerId];
    if (name == null) continue;
    rows.add((
      interval: i,
      ownerName: name,
      due: intervalNextDue(i, now: now),
      overdue: intervalIsOverdue(i, now: now),
    ));
  }
  rows.sort((a, b) {
    if (a.overdue != b.overdue) return a.overdue ? -1 : 1;
    final ad = a.due, bd = b.due;
    if (ad == null) return -1; // never done: the oldest debt
    if (bd == null) return 1;
    return ad.compareTo(bd);
  });
  return rows;
}

/// The point of the app on one screen: what the land is owed.
class WhatsDueScreen extends ConsumerWidget {
  const WhatsDueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final intervals = ref.watch(allIntervalsProvider).value;
    final systems = ref.watch(allSystemsProvider).value;
    final equipment = ref.watch(allEquipmentProvider).value;
    if (intervals == null || systems == null || equipment == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final rows = dueRows(intervals, systems, equipment);
    return Scaffold(
      appBar: AppBar(title: const Text("What's due")),
      body: rows.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.task_alt,
                        size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('Nothing on the books.',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Add intervals to your systems and equipment — the '
                      'filter change, the pump-out, the fall winterize — '
                      'and this screen becomes the season\'s to-do list.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              children: [
                for (final row in rows)
                  ListTile(
                    leading: Icon(
                      row.overdue
                          ? Icons.warning_amber_rounded
                          : Icons.schedule,
                      color: row.overdue
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(row.interval.label),
                    subtitle: Text([
                      row.ownerName,
                      if (row.due == null)
                        'never done'
                      else if (row.overdue)
                        'was due ${formatDate(row.due!)}'
                      else
                        'due ${formatDate(row.due!)}',
                    ].join(' · ')),
                    trailing: TextButton(
                      onPressed: () => ref
                          .read(intervalRepositoryProvider)
                          .markDone(row.interval.id),
                      child: const Text('Done'),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => OwnerDetailScreen(
                            ownerType: row.interval.ownerType,
                            ownerId: row.interval.ownerId),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
