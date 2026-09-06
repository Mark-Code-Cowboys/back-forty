import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/features/scan_import/nameplate_parser.dart';

OcrLine line(String text, {double top = 0}) =>
    OcrLine(text, left: 0, top: top, height: 16);

void main() {
  test('transcribes model, serial, and the labeled ratings', () {
    final reading = parseNameplate([
      line('GOULDS PUMPS', top: 0),
      line('MODEL J10S', top: 20),
      line('SER. NO 8A412-77', top: 40),
      line('HP 1', top: 60),
      line('VOLTS 230', top: 80),
      line('GPM 12', top: 100),
      line('MAX PSI 64', top: 120),
    ])!;
    expect(reading.model, 'J10S');
    expect(reading.serial, '8A412-77');
    expect(reading.specs, {
      'HP': '1',
      'VOLTS': '230',
      'GPM': '12',
      'MAX PSI': '64',
    });
  });

  test('a plate with nothing parseable reads as null — never guessed',
      () {
    expect(parseNameplate([line('WEATHERED PLATE')]), isNull);
    expect(parseNameplate(const []), isNull);
  });
}
