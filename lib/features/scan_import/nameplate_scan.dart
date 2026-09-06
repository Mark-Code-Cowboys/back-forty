import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import 'nameplate_parser.dart';
import 'scan_import_providers.dart';

/// Shoots one nameplate and transcribes model, serial, and the labeled
/// ratings. Resolves to the reading the user confirmed, or null. The
/// composer merges the result — nothing is saved here.
///
/// Transcription only: the confirm dialog shows exactly what was read.
Future<NameplateReading?> scanNameplate(
    BuildContext context, WidgetRef ref) async {
  // Scanning is a Pro feature, like in every CC app.
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

  final NameplateReading? reading;
  try {
    final lines =
        await ref.read(textRecognitionServiceProvider).recognize(path);
    reading = parseNameplate(lines);
  } on Exception {
    messenger.showSnackBar(const SnackBar(
        content: Text("Couldn't read that plate — try a closer, "
            'straighter shot.')));
    return null;
  }
  if (!context.mounted) return null;
  if (reading == null) {
    messenger.showSnackBar(const SnackBar(
        content: Text('No readable text found on that plate.')));
    return null;
  }

  final read = reading;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => _ConfirmNameplateDialog(reading: read),
  );
  return confirmed == true ? read : null;
}

/// Shows exactly what the plate said; the user applies it or not.
/// GUARDRAIL: values are verbatim — this dialog never suggests,
/// corrects, or flags anything.
class _ConfirmNameplateDialog extends StatelessWidget {
  const _ConfirmNameplateDialog({required this.reading});

  final NameplateReading reading;

  @override
  Widget build(BuildContext context) {
    final lines = [
      if (reading.model != null) 'Model: ${reading.model}',
      if (reading.serial != null) 'Serial: ${reading.serial}',
      for (final e in reading.specs.entries) '${e.key}: ${e.value}',
    ];
    return AlertDialog(
      title: const Text('The plate says'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in lines) Text(line),
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
    );
  }
}
