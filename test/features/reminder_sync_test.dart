import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/features/reminders/reminder_sync.dart';

void main() {
  final now = DateTime(2026, 9, 5);
  final systems = [
    System(id: 1, name: 'The Well', kind: SystemKind.well, kindLabel: null,
        installDate: null, specs: const {}, notes: null),
  ];
  Interval mk(int id, {int? everyDays, IntervalSeason? season,
          DateTime? lastDone}) =>
      Interval(id: id, ownerType: OwnerType.system, ownerId: 1,
          label: 'i$id', everyDays: everyDays, season: season,
          lastDone: lastDone);

  test('Pro: one reminder per future due, at 9am on the due day',
      () async {
    final fake = FakeReminderScheduler();
    final planted = await syncReminders(fake,
        entitled: true,
        intervals: [
          mk(1, everyDays: 90, lastDone: DateTime(2026, 8, 1)), // Oct 30
          mk(2, everyDays: 30, lastDone: DateTime(2026, 7, 1)), // overdue
          mk(3, everyDays: 90), // never done: no date to schedule
          mk(4, season: IntervalSeason.spring,
              lastDone: DateTime(2026, 4, 5)), // Apr 1 2027
        ],
        systems: systems,
        equipment: const [],
        now: now);
    expect(planted, 2);
    expect(fake.scheduled[1]!.at, DateTime(2026, 10, 30, 9));
    expect(fake.scheduled[1]!.body, contains('The Well'));
    expect(fake.scheduled[4]!.at, DateTime(2027, 4, 1, 9));
  });

  test('free tier: the slate is wiped and nothing is planted', () async {
    final fake = FakeReminderScheduler();
    await fake.schedule(
        id: 99, title: 'stale', body: 'stale', at: DateTime(2027));
    final planted = await syncReminders(fake,
        entitled: false,
        intervals: [mk(1, everyDays: 90, lastDone: DateTime(2026, 8, 1))],
        systems: systems,
        equipment: const [],
        now: now);
    expect(planted, 0);
    expect(fake.scheduled, isEmpty);
  });

  test('re-sync converges: marking done moves the reminder', () async {
    final fake = FakeReminderScheduler();
    await syncReminders(fake,
        entitled: true,
        intervals: [mk(1, everyDays: 90, lastDone: DateTime(2026, 8, 1))],
        systems: systems, equipment: const [], now: now);
    expect(fake.scheduled[1]!.at, DateTime(2026, 10, 30, 9));

    await syncReminders(fake,
        entitled: true,
        intervals: [mk(1, everyDays: 90, lastDone: now)],
        systems: systems, equipment: const [], now: now);
    expect(fake.scheduled, hasLength(1));
    expect(fake.scheduled[1]!.at, DateTime(2026, 12, 4, 9));
  });
}
