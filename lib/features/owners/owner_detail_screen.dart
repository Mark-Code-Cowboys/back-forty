import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/interval_math.dart';
import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/service_event_repository.dart';
import '../checklists/checklist_screen.dart';
import '../intervals/interval_editor.dart';
import '../service/service_event_composer_screen.dart';
import 'equipment_composer_screen.dart';
import 'system_composer_screen.dart';

final systemProvider = StreamProvider.family<System?, int>(
  (ref, id) => ref.watch(systemRepositoryProvider).watchOne(id),
);

final equipmentProvider = StreamProvider.family<EquipmentData?, int>(
  (ref, id) => ref.watch(equipmentRepositoryProvider).watchOne(id),
);

final ownerIntervalsProvider =
    StreamProvider.family<List<Interval>, (OwnerType, int)>(
  (ref, key) =>
      ref.watch(intervalRepositoryProvider).watchForOwner(key.$1, key.$2),
);

final ownerEventsProvider =
    StreamProvider.family<List<EventWithStory>, (OwnerType, int)>(
  (ref, key) => ref
      .watch(serviceEventRepositoryProvider)
      .watchForOwner(key.$1, key.$2),
);

/// One thing owned: spec sheet, obligations, and the service timeline —
/// the same page whether it's the well or the boat.
class OwnerDetailScreen extends ConsumerWidget {
  const OwnerDetailScreen(
      {super.key, required this.ownerType, required this.ownerId});

  final OwnerType ownerType;
  final int ownerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final system = ownerType == OwnerType.system
        ? ref.watch(systemProvider(ownerId)).value
        : null;
    final equipment = ownerType == OwnerType.equipment
        ? ref.watch(equipmentProvider(ownerId)).value
        : null;
    if (system == null && equipment == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final theme = Theme.of(context);
    final intervals =
        ref.watch(ownerIntervalsProvider((ownerType, ownerId))).value ??
            const [];
    final events =
        ref.watch(ownerEventsProvider((ownerType, ownerId))).value ??
            const [];
    final overdue =
        intervals.where((i) => intervalIsOverdue(i)).toList();

    final name = system?.name ?? equipment!.name;
    final kindText = system != null
        ? systemKindLabel(system)
        : equipmentKindLabel(equipment!);
    final specs = system?.specs ?? equipment!.specs;
    // Not `??`: a system with null notes must not reach equipment!.
    final notes = system != null ? system.notes : equipment!.notes;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => system != null
                    ? SystemComposerScreen(existing: system)
                    : EquipmentComposerScreen(existing: equipment),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context, ref, name),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (_) => ServiceEventComposerScreen(
              ownerType: ownerType,
              ownerId: ownerId,
              systemKind: system?.kind,
              equipmentKind: equipment?.kind,
            ),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Log service'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          if (overdue.isNotEmpty)
            MaterialBanner(
              backgroundColor: theme.colorScheme.errorContainer,
              content: Text(
                overdue.length == 1
                    ? 'Overdue: ${overdue.single.label}'
                    : '${overdue.length} obligations overdue',
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
              leading: Icon(Icons.warning_amber_rounded,
                  color: theme.colorScheme.onErrorContainer),
              actions: const [SizedBox.shrink()],
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(kindText)),
                    if (system?.installDate != null)
                      Chip(
                          label: Text(
                              'Installed ${formatDate(system!.installDate!)}')),
                    if (equipment?.year != null)
                      Chip(label: Text('${equipment!.year}')),
                    if (equipment?.model != null)
                      Chip(label: Text(equipment!.model!)),
                  ],
                ),
                if (equipment?.serial != null) ...[
                  const SizedBox(height: 8),
                  Text('S/N ${equipment!.serial}',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                ],
                if (specs.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _SpecSheet(specs: specs),
                ],
                if (notes != null) ...[
                  const SizedBox(height: 12),
                  Text(notes, style: theme.textTheme.bodyMedium),
                ],
                if (equipment != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.ac_unit, size: 18),
                          label: const Text('Fall storage'),
                          onPressed: () => _openChecklist(
                              context, ChecklistSeason.storeFall),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.local_florist_outlined,
                              size: 18),
                          label: const Text('Spring start'),
                          onPressed: () => _openChecklist(
                              context, ChecklistSeason.startSpring),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Obligations', style: theme.textTheme.titleSmall),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add interval'),
                  onPressed: () => showIntervalEditor(context, ref,
                      ownerType: ownerType, ownerId: ownerId),
                ),
              ],
            ),
          ),
          if (intervals.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'No recurring obligations yet — the filter change, the '
                'pump-out, the fall winterize.',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          for (final interval in intervals)
            _IntervalTile(
                interval: interval, ownerType: ownerType, ownerId: ownerId),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                Text('Service history', style: theme.textTheme.titleSmall),
          ),
          if (events.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Nothing logged yet. The next oil change starts the '
                'record.',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ),
          for (final event in events)
            _EventTile(
                event: event,
                ownerType: ownerType,
                ownerId: ownerId,
                systemKind: system?.kind,
                equipmentKind: equipment?.kind),
        ],
      ),
    );
  }

  void _openChecklist(BuildContext context, ChecklistSeason season) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ChecklistScreen(equipmentId: ownerId, season: season),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, String name) async {
    final events = ownerType == OwnerType.system
        ? await ref.read(systemRepositoryProvider).eventCount(ownerId)
        : await ref.read(equipmentRepositoryProvider).eventCount(ownerId);
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete $name?'),
        content: Text(events == 0
            ? 'This cannot be undone.'
            : 'Its service history ($events '
                '${events == 1 ? 'event' : 'events'}) goes with it. This '
                'cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    if (ownerType == OwnerType.system) {
      await ref.read(systemRepositoryProvider).delete(ownerId);
    } else {
      await ref.read(equipmentRepositoryProvider).delete(ownerId);
    }
    if (context.mounted) Navigator.of(context).pop();
  }
}

/// The numbers you dig for, as a two-column card.
class _SpecSheet extends StatelessWidget {
  const _SpecSheet({required this.specs});

  final Map<String, String> specs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            for (final entry in specs.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(entry.key,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    ),
                    Expanded(
                      flex: 2,
                      child:
                          Text(entry.value, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _IntervalTile extends ConsumerWidget {
  const _IntervalTile(
      {required this.interval,
      required this.ownerType,
      required this.ownerId});

  final Interval interval;
  final OwnerType ownerType;
  final int ownerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final due = intervalNextDue(interval);
    final overdue = intervalIsOverdue(interval);
    final cadence = interval.everyDays != null
        ? 'every ${interval.everyDays} days'
        : interval.season!.label.toLowerCase();
    return ListTile(
      dense: true,
      title: Text(interval.label),
      subtitle: Text([
        cadence,
        if (due != null) 'due ${formatDate(due)}' else 'never done',
      ].join(' · ')),
      leading: Icon(
        overdue ? Icons.warning_amber_rounded : Icons.schedule,
        color: overdue
            ? theme.colorScheme.error
            : theme.colorScheme.onSurfaceVariant,
      ),
      trailing: TextButton(
        onPressed: () =>
            ref.read(intervalRepositoryProvider).markDone(interval.id),
        child: const Text('Done'),
      ),
      onTap: () => showIntervalEditor(context, ref,
          ownerType: ownerType, ownerId: ownerId, existing: interval),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile(
      {required this.event,
      required this.ownerType,
      required this.ownerId,
      this.systemKind,
      this.equipmentKind});

  final EventWithStory event;
  final OwnerType ownerType;
  final int ownerId;
  final SystemKind? systemKind;
  final EquipmentKind? equipmentKind;

  @override
  Widget build(BuildContext context) {
    final e = event.event;
    final details = [
      formatDate(e.date),
      if (e.costCents != null)
        '\$${(e.costCents! / 100).toStringAsFixed(2)}',
      if (e.partsUsed != null) e.partsUsed!,
    ].join(' · ');
    return ListTile(
      title: Row(
        children: [
          Text(serviceKindLabel(e)),
          if (event.photos.isNotEmpty) ...[
            const SizedBox(width: 6),
            const Icon(Icons.photo_outlined, size: 14),
          ],
        ],
      ),
      subtitle: Text([
        details,
        if (event.notes != null) event.notes!,
      ].join('\n')),
      isThreeLine: event.notes != null,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => ServiceEventComposerScreen(
            ownerType: ownerType,
            ownerId: ownerId,
            systemKind: systemKind,
            equipmentKind: equipmentKind,
            existing: event,
          ),
        ),
      ),
    );
  }
}
