import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/repositories/system_repository.dart';
import 'package:back_forty/features/owners/equipment_composer_screen.dart';
import 'package:back_forty/features/service/service_event_composer_screen.dart';
import 'package:back_forty/features/scan_import/scan_import_providers.dart';

import '../helpers.dart';

void main() {
  testWidgets('nameplate scan fills model, serial, and the spec sheet '
      'after the user confirms', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      home: const EquipmentComposerScreen(),
      overrides: [
        documentScanServiceProvider
            .overrideWithValue(FakeDocumentScanService(['plate.jpg'])),
        textRecognitionServiceProvider.overrideWithValue(
          FakeTextRecognitionService(linesByPath: {
            'plate.jpg': const [
              OcrLine('MODEL J10S', left: 0, top: 0, height: 16),
              OcrLine('S/N 8A412', left: 0, top: 20, height: 16),
              OcrLine('HP 1', left: 0, top: 40, height: 16),
            ],
          }),
        ),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Scan nameplate'));
    await tester.pumpAndSettle();
    expect(find.text('The plate says'), findsOneWidget);
    expect(find.text('Model: J10S'), findsOneWidget);
    await tester.tap(find.text('Use these'));
    await tester.pumpAndSettle();

    expect(find.text('J10S'), findsOneWidget);
    expect(find.text('8A412'), findsOneWidget);
    expect(find.text('HP'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('receipt scan fills date and cost; free users hit the '
      'paywall first', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    final wellId = await SystemRepository(db).create(systemDraft());
    Widget composer({EntitlementService? entitlements}) => testApp(
          db: db,
          entitlements: entitlements,
          home: ServiceEventComposerScreen(
              ownerType: OwnerType.system, ownerId: wellId),
          overrides: [
            documentScanServiceProvider
                .overrideWithValue(FakeDocumentScanService(['r.jpg'])),
            textRecognitionServiceProvider.overrideWithValue(
              FakeTextRecognitionService(linesByPath: {
                'r.jpg': const [
                  OcrLine('9/12/2025', left: 0, top: 0, height: 14),
                  OcrLine('Total \$425.00', left: 0, top: 30, height: 14),
                ],
              }),
            ),
          ],
        );

    // Free: paywall, not scanner.
    await tester.pumpWidget(composer());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();
    expect(find.text('Back Forty Pro'), findsOneWidget);
    await disposeApp(tester);

    // Pro: confirm-then-fill.
    await tester.pumpWidget(composer(
        entitlements: FakeEntitlementService(unlimited: true)));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();
    expect(find.text(r'Cost: $425.00'), findsOneWidget);
    await tester.tap(find.text('Use these'));
    await tester.pumpAndSettle();
    expect(find.text('425.00'), findsOneWidget);
    expect(find.text('Sep 12, 2025'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
