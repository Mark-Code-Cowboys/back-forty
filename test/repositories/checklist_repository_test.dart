import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/database/converters.dart';
import 'package:back_forty/data/repositories/checklist_repository.dart';
import 'package:back_forty/data/repositories/equipment_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late ChecklistRepository checklists;
  late int boatId;

  setUp(() async {
    db = makeTestDb();
    checklists = ChecklistRepository(db);
    boatId = await EquipmentRepository(db)
        .create(equipmentDraft(name: 'The Boat', kind: EquipmentKind.boat));
  });

  tearDown(() => db.close());

  test('a first-ever checklist starts empty; steps persist', () async {
    final list = await checklists.instantiateForYear(
        boatId, ChecklistSeason.storeFall, 2025);
    expect(list.steps, isEmpty);

    await checklists.saveSteps(list.id, const [
      ChecklistStep(label: 'Fog the engine', done: true,
          note: 'Fogging oil is in the red cabinet'),
      ChecklistStep(label: 'Drain the livewell', done: true),
      ChecklistStep(label: 'Battery to the basement'),
    ]);
    final saved = (await checklists
        .watchFor(boatId, ChecklistSeason.storeFall, 2025)
        .first)!;
    expect(saved.steps, hasLength(3));
    expect(saved.steps.first.note, 'Fogging oil is in the red cabinet');
  });

  test('a new year copies labels AND notes, everything unchecked',
      () async {
    final y2025 = await checklists.instantiateForYear(
        boatId, ChecklistSeason.storeFall, 2025);
    await checklists.saveSteps(y2025.id, const [
      ChecklistStep(label: 'Fog the engine', done: true,
          note: 'Fogging oil is in the red cabinet'),
      ChecklistStep(label: 'Drain the livewell', done: true),
    ]);

    final y2026 = await checklists.instantiateForYear(
        boatId, ChecklistSeason.storeFall, 2026);
    expect(y2026.steps, hasLength(2));
    expect(y2026.steps.first.note, 'Fogging oil is in the red cabinet');
    expect(y2026.steps.every((s) => !s.done), isTrue,
        reason: 'the wisdom carries, the check-offs do not');

    // Idempotent: re-opening the same year returns the same list.
    final again = await checklists.instantiateForYear(
        boatId, ChecklistSeason.storeFall, 2026);
    expect(again.id, y2026.id);

    // Seasons are independent.
    final spring = await checklists.instantiateForYear(
        boatId, ChecklistSeason.startSpring, 2026);
    expect(spring.steps, isEmpty);
  });
}
