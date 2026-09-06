import 'package:cc_core/cc_core.dart';

import '../../data/database/app_database.dart';

/// What one notebook page or filed receipt transcribed to — the
/// converter's schema: {item name, date, what was done, cost?}. Every
/// field is exactly what the camera saw; the user confirms and edits
/// on the review screen before anything is saved.
class ServicePageDraft {
  ServicePageDraft({
    this.itemName,
    this.date,
    this.kind = ServiceKind.other,
    this.kindLabel,
    this.costCents,
  });

  String? itemName;
  DateTime? date;
  ServiceKind kind;

  /// The page's own words when nothing canonical matched.
  String? kindLabel;
  int? costCents;
}

// What-was-done vocabulary, first match wins. Word stems on purpose —
// "pumped", "winterized", "sharpened" all land.
const _kindStems = [
  ('pump', ServiceKind.pumpOut),
  ('oil', ServiceKind.oilChange),
  ('filter', ServiceKind.filterChange),
  ('winteriz', ServiceKind.winterize),
  ('blade', ServiceKind.bladeSharpen),
  ('sharpen', ServiceKind.bladeSharpen),
  ('inspect', ServiceKind.inspection),
  ('salt', ServiceKind.saltFill),
  ('spring start', ServiceKind.springStart),
  ('de-winteriz', ServiceKind.springStart),
  ('repair', ServiceKind.repair),
  ('replac', ServiceKind.repair),
  ('service', ServiceKind.service),
  ('tune', ServiceKind.service),
];

// Rows that are page plumbing, never an item name.
// Vendor names legitimately contain "service"/"repair" ("DALE'S
// SEPTIC SERVICE") — only true plumbing rows are noise.
final _nameNoise = RegExp(
    r'\b(date|total|amount|paid|cost|invoice|receipt|thank|www|\.com)\b',
    caseSensitive: false);

/// Transcribes one page's OCR into a [ServicePageDraft].
///
/// Item name: the tallest text in the top third that isn't plumbing.
/// Date: the first on the page. Cost: the labeled total. What was
/// done: the first stem from the service vocabulary; a page with
/// service words that match nothing canonical keeps its own words as
/// other(label).
///
/// Null when the photo had no text at all. No field is ever invented.
ServicePageDraft? parseServicePage(List<OcrLine> lines) {
  if (lines.isEmpty) return null;

  final bottom =
      lines.map((l) => l.top + l.height).reduce((a, b) => a > b ? a : b);
  final topThird = lines.where((l) => l.top < bottom / 3).toList()
    ..sort((a, b) => b.height.compareTo(a.height));
  String? itemName;
  for (final line in topThird) {
    final text = line.text.trim();
    if (text.length < 3 || _nameNoise.hasMatch(text)) continue;
    if (!RegExp(r'[a-zA-Z]{3}').hasMatch(text)) continue;
    if (parseLooseDate(text) != null) continue;
    itemName = titleCaseShouted(text);
    break;
  }

  final rows = mergeOcrRows(lines);
  // Stem priority beats row order: "DALE'S SEPTIC SERVICE / Pumped
  // 1000 gal" is a pump-out, not a generic service — the specific
  // verbs are listed first and win wherever they appear on the page.
  var kind = ServiceKind.other;
  String? kindLabel;
  final lowerRows = [for (final r in rows) r.toLowerCase()];
  outer:
  for (final (stem, k) in _kindStems) {
    for (final row in lowerRows) {
      if (row.contains(stem)) {
        kind = k;
        break outer;
      }
    }
  }

  final date = parsePageDates(rows, max: 1).firstOrNull;
  final cost = parseCostCents(rows);

  if (itemName == null && date == null && cost == null) return null;
  return ServicePageDraft(
    itemName: itemName,
    date: date,
    kind: kind,
    kindLabel: kindLabel,
    costCents: cost,
  );
}
