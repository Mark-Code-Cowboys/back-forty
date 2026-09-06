import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import 'scan_import_providers.dart';

/// What one service receipt transcribed to.
class ReceiptReading {
  ReceiptReading({this.costCents, this.date});

  int? costCents;
  DateTime? date;

  bool get isEmpty => costCents == null && date == null;
}

/// Shoots one service receipt and transcribes the total and the date
/// (cc_core parseCostCents/parsePageDates). Resolves to the reading
/// the user confirmed, or null; the composer fills its fields.
Future<ReceiptReading?> scanReceipt(
    BuildContext context, WidgetRef ref) async {
  final pro = await ref.read(entitlementServiceProvider).isUnlimited();
  if (!context.mounted) return null;
  if (!pro) {
    final unlocked = await showPaywallSheet(context);
    if (!unlocked || !context.mounted) return null;
  }

  final messenger = ScaffoldMessenger.of(context);
  final paths = await captureDocumentPages(
      ref.read(documentScanServiceProvider),
      pageLimit: 1);
  final path = paths.firstOrNull;
  if (path == null || !context.mounted) return null;

  final ReceiptReading reading;
  try {
    final lines =
        await ref.read(textRecognitionServiceProvider).recognize(path);
    final rows = mergeOcrRows(lines);
    reading = ReceiptReading(
      costCents: parseCostCents(rows),
      date: parsePageDates(rows, max: 1).firstOrNull,
    );
  } on Exception {
    messenger.showSnackBar(const SnackBar(
        content: Text("Couldn't read that receipt — try a closer, "
            'straighter shot.')));
    return null;
  }
  if (!context.mounted) return null;
  if (reading.isEmpty) {
    messenger.showSnackBar(const SnackBar(
        content: Text('No total or date found on that receipt.')));
    return null;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Receipt says'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reading.costCents != null)
            Text('Cost: \$${(reading.costCents! / 100).toStringAsFixed(2)}'),
          if (reading.date != null) Text('Date: ${formatDate(reading.date!)}'),
          const SizedBox(height: 12),
          Text(
            'Exactly what was read — you can still edit every field '
            'before saving.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Use these')),
      ],
    ),
  );
  return confirmed == true ? reading : null;
}
