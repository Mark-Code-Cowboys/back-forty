import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/interval_math.dart';
import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../intervals/whats_due_screen.dart';
import '../monetization/free_limit.dart';
import '../owners/owner_detail_screen.dart';

/// The worst obligation hanging over one owner: overdue beats
/// upcoming, sooner beats later, null when it owes nothing.
({DateTime? due, bool overdue})? worstObligation(
    List<Interval> intervals, OwnerType type, int ownerId,
    {DateTime? now}) {
  ({DateTime? due, bool overdue})? worst;
  for (final i in intervals) {
    if (i.ownerType != type || i.ownerId != ownerId) continue;
    final candidate =
        (due: intervalNextDue(i, now: now), overdue: intervalIsOverdue(i, now: now));
    if (worst == null) {
      worst = candidate;
      continue;
    }
    if (candidate.overdue != worst.overdue) {
      if (candidate.overdue) worst = candidate;
      continue;
    }
    final cd = candidate.due, wd = worst.due;
    if (cd == null || (wd != null && cd.isBefore(wd))) worst = candidate;
  }
  return worst;
}

/// The property: systems and equipment, each with its next-due badge.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systems = ref.watch(allSystemsProvider).value;
    final equipment = ref.watch(allEquipmentProvider).value;
    final intervals =
        ref.watch(allIntervalsProvider).value ?? const <Interval>[];
    if (systems == null || equipment == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final empty = systems.isEmpty && equipment.isEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('Back Forty')),
      body: empty
          ? _empty(context)
          : ListView(
              padding: const EdgeInsets.only(bottom: 88),
              children: [
                _sectionHeader(context, 'Systems',
                    systemFreeLimit.usage(systems.length).label),
                for (final s in systems)
                  _OwnerTile(
                    name: s.name,
                    kind: systemKindLabel(s),
                    ownerType: OwnerType.system,
                    ownerId: s.id,
                    badge: worstObligation(
                        intervals, OwnerType.system, s.id),
                  ),
                if (systems.isEmpty)
                  _sectionHint(context,
                      'The well, the septic, the generator — add what the '
                      'house depends on.'),
                _sectionHeader(context, 'Equipment',
                    equipmentFreeLimit.usage(equipment.length).label),
                for (final e in equipment)
                  _OwnerTile(
                    name: e.name,
                    kind: equipmentKindLabel(e),
                    ownerType: OwnerType.equipment,
                    ownerId: e.id,
                    badge: worstObligation(
                        intervals, OwnerType.equipment, e.id),
                  ),
                if (equipment.isEmpty)
                  _sectionHint(context,
                      'The boat, the snowblower, the mower — the seasonal '
                      'fleet.'),
              ],
            ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, String chip) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Row(
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          const Spacer(),
          // Phase C hides these for Pro owners.
          Chip(
            label: Text(chip, style: theme.textTheme.labelSmall),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _sectionHint(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(text,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
    );
  }

  Widget _empty(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cabin_outlined,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('Service records for everything on your land.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Start with the thing you\'d least like to explain to a '
              'repairman from memory — the well, the septic, the '
              'generator.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _OwnerTile extends StatelessWidget {
  const _OwnerTile({
    required this.name,
    required this.kind,
    required this.ownerType,
    required this.ownerId,
    this.badge,
  });

  final String name;
  final String kind;
  final OwnerType ownerType;
  final int ownerId;
  final ({DateTime? due, bool overdue})? badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = badge;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(name),
        subtitle: Text(kind),
        trailing: b == null
            ? null
            : Text(
                b.overdue
                    ? 'Overdue'
                    : b.due == null
                        ? ''
                        : 'Due ${formatDate(b.due!)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: b.overdue
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: b.overdue ? FontWeight.w600 : null,
                ),
              ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => OwnerDetailScreen(
                ownerType: ownerType, ownerId: ownerId),
          ),
        ),
      ),
    );
  }
}
