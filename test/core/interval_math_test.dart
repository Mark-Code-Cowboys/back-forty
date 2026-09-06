import 'package:flutter_test/flutter_test.dart';
import 'package:back_forty/core/utils/interval_math.dart';
import 'package:back_forty/data/database/app_database.dart';

Interval interval({int? everyDays, IntervalSeason? season, DateTime? lastDone}) =>
    Interval(
      id: 1,
      ownerType: OwnerType.system,
      ownerId: 1,
      label: 'test',
      everyDays: everyDays,
      season: season,
      lastDone: lastDone,
    );

void main() {
  test('every-N-days rolls forward from lastDone', () {
    final due = intervalNextDue(
        interval(everyDays: 90, lastDone: DateTime(2026, 6, 1)));
    expect(due, DateTime(2026, 8, 30));
  });

  test('every-N-days across the year boundary', () {
    final due = intervalNextDue(
        interval(everyDays: 180, lastDone: DateTime(2026, 11, 15)));
    expect(due, DateTime(2027, 5, 14));
  });

  test('never done: no invented date, but it counts as owed', () {
    final i = interval(everyDays: 90);
    expect(intervalNextDue(i), isNull);
    expect(intervalIsOverdue(i, now: DateTime(2026, 9, 5)), isTrue);
  });

  test('seasonal: next anchor strictly after lastDone', () {
    // Fall task done in November isn't due again until NEXT October.
    expect(
        intervalNextDue(
            interval(season: IntervalSeason.fall,
                lastDone: DateTime(2025, 11, 3))),
        DateTime(2026, 10, 1));
    // Fall task done in September rolls to October 1 the same year.
    expect(
        intervalNextDue(
            interval(season: IntervalSeason.fall,
                lastDone: DateTime(2026, 9, 2))),
        DateTime(2026, 10, 1));
    // Spring task done in April 2026 -> April 1, 2027.
    expect(
        intervalNextDue(
            interval(season: IntervalSeason.spring,
                lastDone: DateTime(2026, 4, 10))),
        DateTime(2027, 4, 1));
  });

  test('seasonal never done: anchored off now', () {
    final due = intervalNextDue(
        interval(season: IntervalSeason.spring),
        now: DateTime(2026, 9, 5));
    expect(due, DateTime(2027, 4, 1));
  });

  test('overdue is a date comparison against now', () {
    final winterize = interval(
        season: IntervalSeason.fall, lastDone: DateTime(2025, 10, 20));
    expect(
        intervalIsOverdue(winterize, now: DateTime(2026, 9, 30)), isFalse);
    expect(
        intervalIsOverdue(winterize, now: DateTime(2026, 10, 2)), isTrue);
  });
}
