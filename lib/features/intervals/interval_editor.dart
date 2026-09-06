import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/interval_repository.dart';

/// Add or edit one recurring obligation — every N days or seasonal,
/// never both (the schema's XOR, surfaced as a segmented choice).
Future<void> showIntervalEditor(
  BuildContext context,
  WidgetRef ref, {
  required OwnerType ownerType,
  required int ownerId,
  Interval? existing,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _IntervalDialog(
        ownerType: ownerType, ownerId: ownerId, existing: existing),
  );
}

enum _Mode { days, seasonal }

class _IntervalDialog extends ConsumerStatefulWidget {
  const _IntervalDialog(
      {required this.ownerType, required this.ownerId, this.existing});

  final OwnerType ownerType;
  final int ownerId;
  final Interval? existing;

  @override
  ConsumerState<_IntervalDialog> createState() => _IntervalDialogState();
}

class _IntervalDialogState extends ConsumerState<_IntervalDialog> {
  late final _label = TextEditingController(text: widget.existing?.label);
  late final _days =
      TextEditingController(text: widget.existing?.everyDays?.toString());
  late _Mode _mode =
      widget.existing?.season != null ? _Mode.seasonal : _Mode.days;
  late IntervalSeason _season =
      widget.existing?.season ?? IntervalSeason.fall;

  @override
  void dispose() {
    _label.dispose();
    _days.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final label = _label.text.trim();
    final days = int.tryParse(_days.text.trim());
    if (label.isEmpty) return;
    if (_mode == _Mode.days && (days == null || days < 1)) return;
    final draft = IntervalDraft(
      label: label,
      everyDays: _mode == _Mode.days ? days : null,
      season: _mode == _Mode.seasonal ? _season : null,
      lastDone: widget.existing?.lastDone,
    );
    final repo = ref.read(intervalRepositoryProvider);
    if (widget.existing == null) {
      await repo.create(widget.ownerType, widget.ownerId, draft);
    } else {
      await repo.update(widget.existing!.id, draft);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.existing == null ? 'Add interval' : 'Edit interval'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _label,
            decoration: const InputDecoration(
                labelText: 'What', hintText: 'Change the filter'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          SegmentedButton<_Mode>(
            segments: const [
              ButtonSegment(value: _Mode.days, label: Text('Every N days')),
              ButtonSegment(value: _Mode.seasonal, label: Text('Seasonal')),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.single),
          ),
          const SizedBox(height: 12),
          if (_mode == _Mode.days)
            TextField(
              controller: _days,
              decoration: const InputDecoration(
                  labelText: 'Every', suffixText: 'days'),
              keyboardType: TextInputType.number,
            )
          else
            DropdownButtonFormField<IntervalSeason>(
              initialValue: _season,
              decoration: const InputDecoration(labelText: 'Season'),
              items: [
                for (final s in IntervalSeason.values)
                  DropdownMenuItem(value: s, child: Text(s.label)),
              ],
              onChanged: (s) => setState(() => _season = s ?? _season),
            ),
        ],
      ),
      actions: [
        if (widget.existing != null)
          TextButton(
            onPressed: () async {
              await ref
                  .read(intervalRepositoryProvider)
                  .delete(widget.existing!.id);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
