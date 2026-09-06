import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/database/converters.dart';
import '../../data/providers.dart';
import '../owners/owner_detail_screen.dart';

/// One equipment's seasonal ritual for the current year. Opened fresh,
/// it copies last year's steps — labels and the year-to-year notes —
/// with everything unchecked.
class ChecklistScreen extends ConsumerStatefulWidget {
  const ChecklistScreen(
      {super.key, required this.equipmentId, required this.season});

  final int equipmentId;
  final ChecklistSeason season;

  @override
  ConsumerState<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends ConsumerState<ChecklistScreen> {
  late final int _year = DateTime.now().year;
  Checklist? _checklist;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await ref
        .read(checklistRepositoryProvider)
        .instantiateForYear(widget.equipmentId, widget.season, _year);
    if (mounted) setState(() => _checklist = list);
  }

  Future<void> _save(List<ChecklistStep> steps) async {
    final list = _checklist;
    if (list == null) return;
    await ref.read(checklistRepositoryProvider).saveSteps(list.id, steps);
    if (mounted) {
      setState(() => _checklist = null);
      await _load();
    }
  }

  Future<void> _addStep() => _editStep(null);

  Future<void> _editStep(int? index) async {
    final steps = List.of(_checklist?.steps ?? const <ChecklistStep>[]);
    final existing = index == null ? null : steps[index];
    final result = await showDialog<_StepResult>(
      context: context,
      builder: (_) => _StepDialog(existing: existing),
    );
    if (result == null) return;
    if (result.delete) {
      if (index != null) steps.removeAt(index);
    } else {
      final step = ChecklistStep(
        label: result.label,
        done: existing?.done ?? false,
        note: result.note,
      );
      if (index == null) {
        steps.add(step);
      } else {
        steps[index] = step;
      }
    }
    await _save(steps);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final equipment =
        ref.watch(equipmentProvider(widget.equipmentId)).value;
    final list = _checklist;
    final steps = list?.steps ?? const <ChecklistStep>[];
    final done = steps.where((s) => s.done).length;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.season.label} $_year — ${equipment?.name ?? ''}'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addStep,
        icon: const Icon(Icons.add),
        label: const Text('Add step'),
      ),
      body: list == null
          ? const Center(child: CircularProgressIndicator())
          : steps.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.checklist,
                            size: 64, color: theme.colorScheme.primary),
                        const SizedBox(height: 16),
                        Text('Build it once, keep it forever.',
                            style: theme.textTheme.titleMedium,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text(
                          'Add the steps this ritual takes — next year '
                          'they come back with your notes, unchecked and '
                          'ready.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.only(bottom: 88),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('$done of ${steps.length} done',
                          style: theme.textTheme.titleSmall),
                    ),
                    for (final (i, step) in steps.indexed)
                      CheckboxListTile(
                        value: step.done,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(step.label,
                            style: step.done
                                ? theme.textTheme.bodyLarge?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color:
                                        theme.colorScheme.onSurfaceVariant)
                                : null),
                        subtitle:
                            step.note == null ? null : Text(step.note!),
                        secondary: IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          tooltip: 'Edit step',
                          onPressed: () => _editStep(i),
                        ),
                        onChanged: (v) {
                          final next = List.of(steps);
                          next[i] = step.copyWith(done: v ?? false);
                          _save(next);
                        },
                      ),
                  ],
                ),
    );
  }
}

class _StepResult {
  const _StepResult({required this.label, this.note, this.delete = false});

  final String label;
  final String? note;
  final bool delete;
}

/// Owns its controllers so they outlive the dialog's exit animation.
class _StepDialog extends StatefulWidget {
  const _StepDialog({this.existing});

  final ChecklistStep? existing;

  @override
  State<_StepDialog> createState() => _StepDialogState();
}

class _StepDialogState extends State<_StepDialog> {
  late final _label = TextEditingController(text: widget.existing?.label);
  late final _note = TextEditingController(text: widget.existing?.note);

  @override
  void dispose() {
    _label.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add step' : 'Edit step'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _label,
            decoration: const InputDecoration(labelText: 'Step'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _note,
            decoration: const InputDecoration(
                labelText: 'Note',
                hintText: 'Carried to next year — where things are, '
                    'what it takes.'),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        if (widget.existing != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(_StepResult(
                label: widget.existing!.label, delete: true)),
            child: const Text('Delete'),
          ),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final label = _label.text.trim();
            if (label.isEmpty) return;
            Navigator.of(context).pop(_StepResult(
              label: label,
              note: _note.text.trim().isEmpty ? null : _note.text.trim(),
            ));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
