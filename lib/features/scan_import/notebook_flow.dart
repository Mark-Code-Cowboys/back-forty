import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import 'notebook_importer.dart';
import 'scan_import_providers.dart';
import 'service_page_parser.dart';

/// The onboarding converter: photograph the folder of receipts or the
/// notebook (up to 20 pages in one session), review what each page
/// transcribed to, fix anything the camera misread, and file them all
/// at once.
///
/// Transcription only: the review screen shows exactly what was read —
/// missing fields stay blank for the user, never guessed.
Future<void> runNotebookImport(BuildContext context, WidgetRef ref) async {
  // The converter is a Pro feature, like scanning in every CC app.
  final pro = await ref.read(entitlementServiceProvider).isUnlimited();
  if (!context.mounted) return;
  if (!pro) {
    final unlocked = await showPaywallSheet(context);
    if (!unlocked || !context.mounted) return;
  }

  final messenger = ScaffoldMessenger.of(context);
  final paths = await captureDocumentPages(
      ref.read(documentScanServiceProvider),
      pageLimit: 20);
  if (paths.isEmpty || !context.mounted) return;

  final transcription = await batchTranscribe<ServicePageDraft>(
    imagePaths: paths,
    recognizer: ref.read(textRecognitionServiceProvider),
    parse: parseServicePage,
  );
  if (!context.mounted) return;
  if (transcription.items.isEmpty) {
    messenger.showSnackBar(const SnackBar(
        content: Text("Couldn't read those pages — try closer, "
            'straighter shots.')));
    return;
  }
  if (transcription.failedCount > 0) {
    messenger.showSnackBar(SnackBar(
        content: Text('${transcription.failedCount} '
            '${transcription.failedCount == 1 ? 'page was' : 'pages were'} '
            'unreadable and skipped.')));
  }

  final kept = await showBatchReviewScreen<ServicePageDraft>(
    context,
    items: transcription.items,
    title: 'Scanned pages',
    subtitle: 'Exactly what each page says — fix anything the camera '
        'misread, uncheck pages that don\'t belong. Names matching '
        'nothing become new equipment (recategorize later); pages '
        'without a date are filed under today.',
    confirmLabel: (n) => n == 1 ? 'File 1 event' : 'File $n events',
    itemBuilder: (context, item, onChanged) =>
        _ServicePageRow(item: item, onChanged: onChanged),
  );
  if (kept == null || kept.isEmpty || !context.mounted) return;

  final report = await insertServicePages(
    systems: ref.read(systemRepositoryProvider),
    equipment: ref.read(equipmentRepositoryProvider),
    events: ref.read(serviceEventRepositoryProvider),
    drafts: [for (final item in kept) item.value],
  );
  messenger.showSnackBar(SnackBar(content: Text(report.summary)));
}

class _ServicePageRow extends StatelessWidget {
  const _ServicePageRow({required this.item, required this.onChanged});

  final BatchScanItem<ServicePageDraft> item;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final draft = item.value;
    final details = [
      draft.kind.label,
      if (draft.date == null) 'No date' else formatDate(draft.date!),
      if (draft.costCents != null)
        '\$${(draft.costCents! / 100).toStringAsFixed(2)}',
    ].join(' · ');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(draft.itemName ?? 'No item name',
          style: draft.itemName == null
              ? theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant)
              : null),
      subtitle: Text(details),
      trailing: IconButton(
        icon: const Icon(Icons.edit_outlined),
        tooltip: 'Edit page',
        onPressed: () async {
          await showDialog<void>(
            context: context,
            builder: (_) => _EditServicePageDialog(draft: draft),
          );
          onChanged();
        },
      ),
    );
  }
}

/// Edits one transcribed page in place. Fields start as what the
/// camera saw; the dialog never suggests values.
class _EditServicePageDialog extends StatefulWidget {
  const _EditServicePageDialog({required this.draft});

  final ServicePageDraft draft;

  @override
  State<_EditServicePageDialog> createState() =>
      _EditServicePageDialogState();
}

class _EditServicePageDialogState extends State<_EditServicePageDialog> {
  late final _name = TextEditingController(text: widget.draft.itemName);
  late final _cost = TextEditingController(
      text: widget.draft.costCents == null
          ? null
          : (widget.draft.costCents! / 100).toStringAsFixed(2));
  late ServiceKind _kind = widget.draft.kind;
  late DateTime? _date = widget.draft.date;

  @override
  void dispose() {
    _name.dispose();
    _cost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit page'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Item name'),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ServiceKind>(
              initialValue: _kind,
              decoration:
                  const InputDecoration(labelText: 'What was done'),
              items: [
                for (final k in ServiceKind.values)
                  DropdownMenuItem(value: k, child: Text(k.label)),
              ],
              onChanged: (k) => setState(() => _kind = k ?? _kind),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date ?? DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                    child: Text(
                        _date == null ? 'Date' : formatDate(_date!)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cost,
                    decoration: const InputDecoration(
                        labelText: 'Cost', prefixText: r'$'),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final name = _name.text.trim();
            final costText =
                _cost.text.trim().replaceFirst(r'$', '');
            widget.draft
              ..itemName = name.isEmpty ? null : name
              ..kind = _kind
              ..date = _date
              ..costCents = costText.isEmpty
                  ? null
                  : switch (double.tryParse(costText)) {
                      null => widget.draft.costCents,
                      final v => (v * 100).round(),
                    };
            Navigator.of(context).pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
