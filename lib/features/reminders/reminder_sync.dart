import 'dart:async';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../data/database/app_database.dart';
import '../intervals/whats_due_screen.dart';
import '../monetization/monetization_providers.dart';

/// Overridden in main() with cc_core's LocalNotificationsScheduler,
/// and in tests with FakeReminderScheduler.
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => throw UnimplementedError(
      'reminderSchedulerProvider must be overridden'),
);

/// Rebuilds every scheduled reminder from the current book: one per
/// interval with a future due date — Pro only (reminders are the paid
/// feature; the intervals themselves stay visible to everyone). Wipes
/// the slate first so cancels, edits, and entitlement lapses all
/// converge on the same truth.
Future<int> syncReminders(
  ReminderScheduler scheduler, {
  required bool entitled,
  required List<Interval> intervals,
  required List<System> systems,
  required List<EquipmentData> equipment,
  DateTime? now,
}) async {
  await scheduler.cancelAll();
  if (!entitled) return 0;
  final reference = now ?? DateTime.now();
  var planted = 0;
  for (final row in dueRows(intervals, systems, equipment, now: reference)) {
    final due = row.due;
    if (due == null || !due.isAfter(reference)) continue;
    await scheduler.schedule(
      id: row.interval.id,
      title: row.interval.label,
      body: '${row.ownerName} — due ${formatDate(due)}',
      at: DateTime(due.year, due.month, due.day, 9), // 9am local
    );
    planted++;
  }
  return planted;
}

/// Side-effect provider: watched once from the app root, it re-syncs
/// whenever intervals, owners, or the entitlement change.
final reminderSyncProvider = Provider<void>((ref) {
  final scheduler = ref.watch(reminderSchedulerProvider);
  final pro = ref.watch(isProProvider).value ?? false;
  final intervals = ref.watch(allIntervalsProvider).value;
  final systems = ref.watch(allSystemsProvider).value;
  final equipment = ref.watch(allEquipmentProvider).value;
  if (intervals == null || systems == null || equipment == null) return;
  unawaited(syncReminders(scheduler,
      entitled: pro,
      intervals: intervals,
      systems: systems,
      equipment: equipment));
});
