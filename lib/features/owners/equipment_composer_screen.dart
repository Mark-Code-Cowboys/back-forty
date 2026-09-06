import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/equipment_repository.dart';
import '../scan_import/nameplate_scan.dart';
import 'specs_editor.dart';

/// Add or edit a piece of seasonal equipment.
class EquipmentComposerScreen extends ConsumerStatefulWidget {
  const EquipmentComposerScreen({super.key, this.existing});

  final EquipmentData? existing;

  @override
  ConsumerState<EquipmentComposerScreen> createState() =>
      _EquipmentComposerScreenState();
}

class _EquipmentComposerScreenState
    extends ConsumerState<EquipmentComposerScreen> {
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _kindLabel =
      TextEditingController(text: widget.existing?.kindLabel);
  late final _year =
      TextEditingController(text: widget.existing?.year?.toString());
  late final _model = TextEditingController(text: widget.existing?.model);
  late final _serial = TextEditingController(text: widget.existing?.serial);
  late final _notes = TextEditingController(text: widget.existing?.notes);
  late EquipmentKind _kind = widget.existing?.kind ?? EquipmentKind.mower;
  late Map<String, String> _specs = widget.existing?.specs ?? const {};
  // Bumped after a nameplate scan so the specs editor rebuilds with
  // the merged map.
  var _specsRevision = 0;
  var _saving = false;

  /// Fills model, serial, and specs from a scanned nameplate — after
  /// the user confirmed the reading, and still fully editable here.
  Future<void> _scanNameplate() async {
    final reading = await scanNameplate(context, ref);
    if (reading == null || !mounted) return;
    setState(() {
      if (reading.model != null) _model.text = reading.model!;
      if (reading.serial != null) _serial.text = reading.serial!;
      if (reading.specs.isNotEmpty) {
        _specs = {..._specs, ...reading.specs};
        _specsRevision++;
      }
    });
  }

  @override
  void dispose() {
    for (final c in [_name, _kindLabel, _year, _model, _serial, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || _name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    String? emptyToNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final draft = EquipmentDraft(
      name: _name.text.trim(),
      kind: _kind,
      kindLabel: emptyToNull(_kindLabel),
      year: switch (emptyToNull(_year)) {
        null => null,
        final y => int.tryParse(y),
      },
      model: emptyToNull(_model),
      serial: emptyToNull(_serial),
      specs: _specs,
      notes: emptyToNull(_notes),
    );
    final repo = ref.read(equipmentRepositoryProvider);
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
        title: Text(
            widget.existing == null ? 'Add equipment' : 'Edit equipment'),
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
          DropdownButtonFormField<EquipmentKind>(
            initialValue: _kind,
            decoration: const InputDecoration(labelText: 'Kind'),
            items: [
              for (final k in EquipmentKind.values)
                DropdownMenuItem(value: k, child: Text(k.label)),
            ],
            onChanged: (k) => setState(() => _kind = k ?? _kind),
          ),
          if (_kind == EquipmentKind.other) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _kindLabel,
              decoration:
                  const InputDecoration(labelText: 'Kind (your word)'),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _year,
                  decoration: const InputDecoration(labelText: 'Year'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _model,
                  decoration: const InputDecoration(labelText: 'Model'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _serial,
            decoration: const InputDecoration(labelText: 'Serial number'),
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
              hintText: 'Where the manual is, what it takes, what to watch.',
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
