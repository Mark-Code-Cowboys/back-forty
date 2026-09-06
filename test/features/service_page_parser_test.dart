import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/features/scan_import/service_page_parser.dart';

void main() {
  test('transcribes a filed receipt page', () {
    final draft = parseServicePage(const [
      OcrLine("DALE'S SEPTIC SERVICE", left: 0, top: 0, height: 30),
      OcrLine('Pumped 1000 gal tank', left: 0, top: 60, height: 14),
      OcrLine('9/12/2025', left: 0, top: 90, height: 12),
      OcrLine('Total \$425.00', left: 0, top: 120, height: 14),
    ])!;
    expect(draft.itemName, "Dale's Septic Service");
    expect(draft.kind, ServiceKind.pumpOut);
    expect(draft.date, DateTime(2025, 9, 12));
    expect(draft.costCents, 42500);
  });

  test('unmatched service words fall to other; nothing invented', () {
    final draft = parseServicePage(const [
      OcrLine('The Snowblower', left: 0, top: 0, height: 30),
      OcrLine('Carb rebuilt by Gary', left: 0, top: 60, height: 14),
    ])!;
    expect(draft.itemName, 'The Snowblower');
    expect(draft.kind, ServiceKind.other);
    expect(draft.date, isNull);
    expect(draft.costCents, isNull);
    expect(parseServicePage(const []), isNull);
  });
}
