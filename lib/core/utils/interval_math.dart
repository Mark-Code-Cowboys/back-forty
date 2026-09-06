import '../../data/database/app_database.dart';

/// Seasonal anchor dates — the convention the whole app states in its
/// UI: fall obligations come due October 1, spring ones April 1.
DateTime seasonAnchor(IntervalSeason season, int year) => switch (season) {
      IntervalSeason.fall => DateTime(year, 10, 1),
      IntervalSeason.spring => DateTime(year, 4, 1),
    };

/// When [interval] is next due.
///
/// Every-N-days: lastDone + N days; null when it's never been done —
/// the caller shows "never done" and treats it as due, rather than
/// inventing a date.
///
/// Seasonal: the season's next anchor strictly after lastDone (so a
/// fall task done in November isn't due again until next October), or
/// after [now] when never done.
DateTime? intervalNextDue(Interval interval, {DateTime? now}) {
  final reference = now ?? DateTime.now();
  final everyDays = interval.everyDays;
  if (everyDays != null) {
    final last = interval.lastDone;
    if (last == null) return null;
    // Calendar-day arithmetic, not Duration: service is due on a DAY,
    // and Duration(days:) drifts an hour across DST boundaries.
    return DateTime(last.year, last.month, last.day + everyDays);
  }
  final season = interval.season!;
  final from = interval.lastDone ?? reference;
  final thisYear = seasonAnchor(season, from.year);
  return thisYear.isAfter(from)
      ? thisYear
      : seasonAnchor(season, from.year + 1);
}

/// Overdue: never done, or the due date is behind [now].
bool intervalIsOverdue(Interval interval, {DateTime? now}) {
  final reference = now ?? DateTime.now();
  final due = intervalNextDue(interval, now: reference);
  if (due == null) return true; // never done: it's owed
  return due.isBefore(reference);
}
