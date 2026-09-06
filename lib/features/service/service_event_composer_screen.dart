import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/service_event_repository.dart';

/// Log or edit one thing done to one thing owned. Kind-aware: opening
/// from a septic system preselects Pump-out, a mower Oil change —
/// defaults only, everything stays pickable.
class ServiceEventComposerScreen extends ConsumerStatefulWidget {
  const ServiceEventComposerScreen({
    super.key,
    required this.ownerType,
    required this.ownerId,
    this.systemKind,
    this.equipmentKind,
    this.existing,
  });

  final OwnerType ownerType;
  final int ownerId;
  final SystemKind? systemKind;
  final EquipmentKind? equipmentKind;
  final EventWithStory? existing;

  @override
  ConsumerState<ServiceEventComposerScreen> createState() =>
      _ServiceEventComposerScreenState();
}

class _ServiceEventComposerScreenState
    extends ConsumerState<ServiceEventComposerScreen> {
  late ServiceKind _kind = widget.existing?.event.kind ??
      defaultServiceKind(
          system: widget.systemKind, equipment: widget.equipmentKind);
  late final _kindLabel =
      TextEditingController(text: widget.existing?.event.kindLabel);
  late DateTime _date = widget.existing?.event.date ?? DateTime.now();
  late final _cost = TextEditingController(
      text: widget.existing?.event.costCents == null
          ? null
          : (widget.existing!.event.costCents! / 100).toStringAsFixed(2));
  late final _parts =
      TextEditingController(text: widget.existing?.event.partsUsed);
  late final _notes = TextEditingController(text: widget.existing?.notes);
  final _newPhotos = <JournalPhotoDraft>[];
  var _saving = false;

  @override
  void dispose() {
    _kindLabel.dispose();
    _cost.dispose();
    _parts.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    final source = await showModalBottomSheet<PhotoSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(context).pop(PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pick from gallery'),
              onTap: () => Navigator.of(context).pop(PhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final path = await ref.read(photoServiceProvider).acquire(source);
    if (path != null && mounted) {
      final existing = widget.existing;
      if (existing != null) {
        await ref
            .read(serviceEventRepositoryProvider)
            .addPhoto(existing.event.id, JournalPhotoDraft(path: path));
      } else {
        setState(() => _newPhotos.add(JournalPhotoDraft(path: path)));
      }
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    String? emptyToNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final costText = emptyToNull(_cost)?.replaceFirst(r'$', '');
    final draft = ServiceEventDraft(
      date: _date,
      kind: _kind,
      kindLabel: _kind == ServiceKind.other ? emptyToNull(_kindLabel) : null,
      costCents: costText == null
          ? null
          : switch (double.tryParse(costText)) {
              null => null,
              final v => (v * 100).round(),
            },
      partsUsed: emptyToNull(_parts),
      notes: emptyToNull(_notes),
      photos: List.of(_newPhotos),
    );
    final repo = ref.read(serviceEventRepositoryProvider);
    final existing = widget.existing;
    if (existing == null) {
      await repo.create(widget.ownerType, widget.ownerId, draft);
    } else {
      await repo.update(existing.event.id, draft);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final photoService = ref.read(photoServiceProvider);
    final existingPhotos = widget.existing?.photos ?? const [];
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.existing == null ? 'Log service' : 'Edit service'),
        actions: [
          TextButton(
              onPressed: _saving ? null : _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<ServiceKind>(
            initialValue: _kind,
            decoration: const InputDecoration(labelText: 'What was done'),
            items: [
              for (final k in ServiceKind.values)
                DropdownMenuItem(value: k, child: Text(k.label)),
            ],
            onChanged: (k) => setState(() => _kind = k ?? _kind),
          ),
          if (_kind == ServiceKind.other) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _kindLabel,
              decoration:
                  const InputDecoration(labelText: 'What (your word)'),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                  icon: const Icon(Icons.event),
                  label: Text(formatDate(_date)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cost,
                  decoration: const InputDecoration(
                      labelText: 'Cost', prefixText: r'$'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _parts,
            decoration: const InputDecoration(
                labelText: 'Parts used',
                hintText: 'Filter FXHTC, 2x 5W-30…'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'What you found, what to check next time.',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          PhotoAttachmentStrip(
            items: [
              for (final p in existingPhotos)
                PhotoStripItem(
                  file: photoService.fileFor(p.path),
                  caption: p.caption,
                  onRemove: () => ref
                      .read(serviceEventRepositoryProvider)
                      .removePhoto(p.id),
                ),
              for (final p in _newPhotos)
                PhotoStripItem(
                  file: photoService.fileFor(p.path),
                  onRemove: () => setState(() => _newPhotos.remove(p)),
                ),
            ],
            onAdd: _addPhoto,
          ),
        ],
      ),
    );
  }
}
