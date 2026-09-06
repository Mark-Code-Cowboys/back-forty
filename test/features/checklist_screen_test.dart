import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/repositories/equipment_repository.dart';
import 'package:back_forty/features/checklists/checklist_screen.dart';

import '../helpers.dart';

void main() {
  testWidgets('build the ritual: add a step, check it off',
      (tester) async {
    final db = makeTestDb();
    final boatId = await EquipmentRepository(db)
        .create(equipmentDraft(name: 'The Boat', kind: EquipmentKind.boat));

    await tester.pumpWidget(testApp(
        db: db,
        home: ChecklistScreen(
            equipmentId: boatId, season: ChecklistSeason.storeFall)));
    await tester.pumpAndSettle();

    expect(find.text('Build it once, keep it forever.'), findsOneWidget);

    await tester.tap(find.text('Add step'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Step'), 'Fog the engine');
    await tester.enterText(find.widgetWithText(TextField, 'Note'),
        'Fogging oil is in the red cabinet');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Fog the engine'), findsOneWidget);
    expect(find.text('Fogging oil is in the red cabinet'), findsOneWidget);
    expect(find.text('0 of 1 done'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(find.text('1 of 1 done'), findsOneWidget);

    final row = (await db.select(db.checklists).get()).single;
    expect(row.steps.single.done, isTrue);
    expect(row.steps.single.note, 'Fogging oil is in the red cabinet');

    await disposeApp(tester);
    await db.close();
  });
}
