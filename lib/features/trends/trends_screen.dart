
import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/backup/backup_service.dart';
import '../../core/export/export_service.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../intervals/whats_due_screen.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import 'trends_math.dart';

/// Every service event, raw, for the trends math.
final allEventsProvider = StreamProvider<List<ServiceEvent>>(
  (ref) => ref.watch(serviceEventRepositoryProvider).watchAllRaw(),
);

/// What the land actually costs. Pro-only; restore is never gated.
class TrendsScreen extends ConsumerWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pro = ref.watch(isProProvider).value ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Trends')),
      body: pro
          ? const _TrendsContent()
          : ProTeaser(
              icon: Icons.insights_outlined,
              headline: 'What the land actually costs.',
              body: 'Service spend by year, how often the wrenches come '
                  'out, total cost of ownership per item, and export — '
                  'all part of Back Forty Pro.',
              ctaLabel: 'See Back Forty Pro',
              onSeePro: () => showPaywallSheet(context),
              ungatedLabel: 'Restore a backup',
              onUngated: () => restoreBackupFlow(context, ref),
            ),
    );
  }
}

class _TrendsContent extends ConsumerWidget {
  const _TrendsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final events = ref.watch(allEventsProvider).value;
    final systems = ref.watch(allSystemsProvider).value;
    final equipment = ref.watch(allEquipmentProvider).value;
    if (events == null || systems == null || equipment == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final spend = costByYear(events);
    final frequency = eventsByYear(events);
    final tco = tcoRows(events, systems, equipment);

    Widget section(String title, Widget child) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              child,
            ],
          ),
        );

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        section(
          'The log so far',
          Text(
            countHeadline([
              CountedSubject(systems.length, 'system'),
              CountedSubject(equipment.length, 'piece of equipment',
                  many: 'pieces of equipment'),
              CountedSubject(events.length, 'service event'),
            ]),
            style: theme.textTheme.titleMedium,
          ),
        ),
        if (spend.isNotEmpty)
          section('Service spend by year (\$)',
              YearlyBars(countsByYear: spend)),
        if (frequency.isNotEmpty)
          section('Service events by year',
              YearlyBars(countsByYear: frequency)),
        if (tco.isNotEmpty)
          section('Total cost of ownership', _TcoTable(rows: tco)),
        if (events.isEmpty)
          section(
            'Nothing to chart yet',
            Text(
              'Log service — or import the folder of receipts — and the '
              'numbers appear.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        section(
          'Your records, portable',
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.table_chart_outlined),
                label: const Text('Share service records as CSV'),
                onPressed: () => _shareCsv(context, ref),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.archive_outlined),
                label: const Text('Back up the whole log'),
                onPressed: () => _shareBackup(context, ref),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.settings_backup_restore),
                label: const Text('Restore a backup'),
                onPressed: () => restoreBackupFlow(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ExportService _exporter(WidgetRef ref) => ExportService(
        ref.read(databaseProvider),
        ref.read(shareLauncherProvider),
        ref.read(tempDirProvider),
        photos: ref.read(photoServiceProvider),
      );

  Future<void> _shareCsv(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _exporter(ref).shareServiceCsv();
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  Future<void> _shareBackup(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _exporter(ref).shareBackup();
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Backup failed: $e')));
    }
  }
}

/// "The Well · 6 events · \$1,240" rows, most expensive first.
class _TcoTable extends StatelessWidget {
  const _TcoTable({required this.rows});

  final List<TcoRow> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        for (final row in rows.take(10))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Expanded(
                    child: Text(row.name,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium)),
                Text(
                  '${row.events} ${row.events == 1 ? 'event' : 'events'}'
                  ' · \$${(row.totalCents / 100).toStringAsFixed(2)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// The shared cc_core restore flow with Back Forty's words. Available
/// to free users — restoring your own records is never gated.
Future<void> restoreBackupFlow(BuildContext context, WidgetRef ref) async {
  await runRestoreFlow(
    context,
    confirmBody: 'The log on this phone is replaced with the backup — '
        'systems, equipment, service history, intervals, and checklists. '
        'This cannot be undone.',
    photoStore: ref.read(photoServiceProvider),
    restore: (contents) => restoreFromExportData(
        ref.read(databaseProvider), contents.exportData),
  );
}
