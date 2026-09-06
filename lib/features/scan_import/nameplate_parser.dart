import 'package:cc_core/cc_core.dart';

/// What one nameplate photo transcribed to. Every field is exactly
/// what the camera saw — the user confirms before anything fills, and
/// edits everything afterward.
class NameplateReading {
  NameplateReading({this.model, this.serial, this.specs = const {}});

  String? model;
  String? serial;

  /// Labeled ratings off the plate ("HP" -> "1.5", "VOLTS" -> "230").
  Map<String, String> specs;

  bool get isEmpty => model == null && serial == null && specs.isEmpty;
}

// "MODEL J10S", "MOD. NO: J10S", "S/N 8A412-77", "SER. NO 8A412" —
// keyword, optional no/number connective, punctuation soup, value.
final _modelRow = RegExp(
    r'\b(?:model|mod|m/n)\b[.:#\s]*(?:no|number)?[.:#\s]*([A-Za-z0-9][A-Za-z0-9./-]{0,30})',
    caseSensitive: false);
final _serialRow = RegExp(
    r'\b(?:serial|ser|s/n)\b[.:#\s]*(?:no|number)?[.:#\s]*([A-Za-z0-9-]{3,30})',
    caseSensitive: false);

// "HP 1.5", "VOLTS: 230", "GPM 12", "RPM 3450", "MAX PSI 60" — a short
// letters-only label followed by a number-led value. Conservative on
// purpose: a spec row we miss is a row the user types; a wrong one is
// noise in their sheet forever.
final _specRow = RegExp(
    r'^([A-Za-z][A-Za-z .]{0,14}?)\s*[:=]?\s+(\d[\d.,/]*\s*[A-Za-z%°]{0,6})$');

/// Transcribes one nameplate photo's OCR into a [NameplateReading]:
/// the model row, the serial row, and every labeled rating as a spec
/// entry (model/serial rows excluded from specs). Null when the photo
/// had no text at all. No field is ever invented.
NameplateReading? parseNameplate(List<OcrLine> lines) {
  if (lines.isEmpty) return null;
  final rows = mergeOcrRows(lines);

  String? model;
  String? serial;
  final specs = <String, String>{};
  for (final row in rows) {
    final trimmed = row.trim();
    final modelMatch = _modelRow.firstMatch(trimmed);
    final serialMatch = _serialRow.firstMatch(trimmed);
    if (model == null && modelMatch != null) {
      model = modelMatch.group(1)!.trim();
    }
    if (serial == null && serialMatch != null) {
      serial = serialMatch.group(1)!.trim();
    }
    if (modelMatch != null || serialMatch != null) continue;
    final spec = _specRow.firstMatch(trimmed);
    if (spec != null) {
      final label = spec.group(1)!.trim().toUpperCase();
      specs.putIfAbsent(label, () => spec.group(2)!.trim());
    }
  }

  final reading =
      NameplateReading(model: model, serial: serial, specs: specs);
  return reading.isEmpty ? null : reading;
}
