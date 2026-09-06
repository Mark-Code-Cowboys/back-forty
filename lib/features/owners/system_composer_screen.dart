import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/system_repository.dart';
import '../scan_import/nameplate_scan.dart';
import 'specs_editor.dart';

/// Add or edit a fixed system.
class SystemComposerScreen extends ConsumerStatefulWidget {
  const SystemComposerScreen({super.key, this.existing});

  final System? existing;

  @override
  ConsumerState<SystemComposerScreen> createState() =>
      _SystemComposerScreenState();
}

class _SystemComposerScreenState
    extends ConsumerState<SystemComposerScreen> {
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _kindLabel =
      TextEditingController(text: widget.existing?.kindLabel);
  late final _notes = TextEditingController(text: widget.existing?.notes);
  late SystemKind _kind = widget.existing?.kind ?? SystemKind.well;
  late DateTime? _installDate = widget.existing?.installDate;
  late Map<String, String> _specs = widget.existing?.specs ?? const {};
  var _specsRevision = 0;
  var _saving = false;

  /// Systems keep the whole plate in the spec sheet (no model/serial
  /// columns) — confirmed reading merges in, still fully editable.
  Future<void> _scanNameplate() async {
    final reading = await scanNameplate(context, ref);
    if (reading == null || !mounted) return;
    setState(() {
      _specs = {
        ..._specs,
        if (reading.model != null) 'MODEL': reading.model!,
        if (reading.serial != null) 'SERIAL': reading.serial!,
        ...reading.specs,
      };
      _specsRevision++;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _kindLabel.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || _name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final draft = SystemDraft(
      name: _name.text.trim(),
      kind: _kind,
      kindLabel: _kindLabel.text.trim().isEmpty ? null : _kindLabel.text.trim(),
      installDate: _installDate,
      specs: _specs,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );
    final repo = ref.read(systemRepositoryProvider);
    final existing = widget.existing;
    if (existing == null) {
      await repo.create(draft);
    } else {
      await repo.update(existing.id, draft);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.existing == null ? 'Add a system' : 'Edit system'),
        actions: [
          IconButton(
            icon: const Icon(Icons.document_scanner_outlined),
            tooltip: 'Scan nameplate',
            onPressed: _scanNameplate,
          ),
          TextButton(
              onPressed: _saving ? null : _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<SystemKind>(
            initialValue: _kind,
            decoration: const InputDecoration(labelText: 'Kind'),
            items: [
              for (final k in SystemKind.values)
                DropdownMenuItem(value: k, child: Text(k.label)),
            ],
            onChanged: (k) => setState(() => _kind = k ?? _kind),
          ),
          if (_kind == SystemKind.other) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _kindLabel,
              decoration:
                  const InputDecoration(labelText: 'Kind (your word)'),
            ),
          ],
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _installDate ?? DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _installDate = picked);
            },
            icon: const Icon(Icons.event),
            label: Text(_installDate == null
                ? 'Install date'
                : 'Installed ${formatDate(_installDate!)}'),
          ),
          const SizedBox(height: 16),
          SpecsEditor(
              key: ValueKey(_specsRevision),
              initial: _specs,
              onChanged: (m) => _specs = m),
          const SizedBox(height: 16),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Shutoff locations, quirks, who serviced it last.',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}
