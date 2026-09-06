import 'package:flutter/material.dart';

/// Freeform spec-sheet editor: label/value rows, add and remove, order
/// preserved. Emits the whole map on every change; blank-label rows
/// are dropped on emit.
class SpecsEditor extends StatefulWidget {
  const SpecsEditor({super.key, required this.initial, required this.onChanged});

  final Map<String, String> initial;
  final ValueChanged<Map<String, String>> onChanged;

  @override
  State<SpecsEditor> createState() => _SpecsEditorState();
}

class _SpecRow {
  _SpecRow(String label, String value)
      : label = TextEditingController(text: label),
        value = TextEditingController(text: value);

  final TextEditingController label;
  final TextEditingController value;

  void dispose() {
    label.dispose();
    value.dispose();
  }
}

class _SpecsEditorState extends State<SpecsEditor> {
  late final List<_SpecRow> _rows = [
    for (final e in widget.initial.entries) _SpecRow(e.key, e.value),
  ];

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  void _emit() {
    final map = <String, String>{};
    for (final r in _rows) {
      final label = r.label.text.trim();
      if (label.isEmpty) continue;
      map[label] = r.value.text.trim();
    }
    widget.onChanged(map);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Spec sheet', style: theme.textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(
          'The numbers you dig for every time — capacity, filter model, '
          'oil weight.',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        for (final (i, row) in _rows.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: row.label,
                    decoration: const InputDecoration(
                        labelText: 'Label', isDense: true),
                    onChanged: (_) => _emit(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: row.value,
                    decoration: const InputDecoration(
                        labelText: 'Value', isDense: true),
                    onChanged: (_) => _emit(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: 'Remove spec',
                  onPressed: () {
                    setState(() => _rows.removeAt(i).dispose());
                    _emit();
                  },
                ),
              ],
            ),
          ),
        TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add spec'),
          onPressed: () => setState(() => _rows.add(_SpecRow('', ''))),
        ),
      ],
    );
  }
}
