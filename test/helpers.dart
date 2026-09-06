import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Riverpod 3 keeps the Override type out of the main barrel.
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'package:back_forty/core/theme/app_theme.dart';
import 'package:back_forty/data/database/app_database.dart';
import 'package:back_forty/data/providers.dart';
import 'package:back_forty/data/repositories/equipment_repository.dart';
import 'package:back_forty/features/monetization/monetization_providers.dart';
import 'package:back_forty/features/reminders/reminder_sync.dart';
import 'package:back_forty/data/repositories/service_event_repository.dart';
import 'package:back_forty/data/repositories/system_repository.dart';

AppDatabase makeTestDb() => AppDatabase(NativeDatabase.memory());

/// Plugin-free photo service for widget tests.
class FakeAppPhotoService implements PhotoService {
  final discarded = <String>[];

  @override
  Future<String?> acquire(PhotoSource source) async => null;

  @override
  Future<String?> acquireTransient(PhotoSource source) async => null;

  @override
  File fileFor(String photoPath) => File('/test-photos/$photoPath');

  @override
  Future<void> importBytes(String photoPath, List<int> bytes) async {}

  @override
  Future<void> discard(String photoPath) async {
    discarded.add(photoPath);
  }
}

/// The app wired to an in-memory database and fake services.
Widget testApp({
  required AppDatabase db,
  required Widget home,
  EntitlementService? entitlements,
  ReminderScheduler? scheduler,
  KeyValueStore? kvStore,
  List<Override> overrides = const [],
}) =>
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        photoServiceProvider.overrideWithValue(FakeAppPhotoService()),
        kvStoreProvider.overrideWithValue(kvStore ?? InMemoryKeyValueStore()),
        entitlementServiceProvider
            .overrideWithValue(entitlements ?? FakeEntitlementService()),
        reminderSchedulerProvider
            .overrideWithValue(scheduler ?? FakeReminderScheduler()),
        ...overrides,
      ],
      child: MaterialApp(theme: AppTheme.light(), home: home),
    );

/// Call at the end of every widget test that renders [testApp]; lets
/// drift stream-query cleanup timers fire inside the test zone.
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
}

SystemDraft systemDraft({
  String name = 'The Well',
  SystemKind kind = SystemKind.well,
  Map<String, String> specs = const {'GPM': '12', 'Depth': '180 ft'},
  String? notes,
}) =>
    SystemDraft(name: name, kind: kind, specs: specs, notes: notes);

EquipmentDraft equipmentDraft({
  String name = 'The Snowblower',
  EquipmentKind kind = EquipmentKind.snowblower,
  int? year = 2021,
  String? model = 'Ariens Deluxe 28',
  Map<String, String> specs = const {},
}) =>
    EquipmentDraft(
        name: name, kind: kind, year: year, model: model, specs: specs);

ServiceEventDraft eventDraft({
  DateTime? date,
  ServiceKind kind = ServiceKind.oilChange,
  int? costCents,
  String? partsUsed,
  String? notes,
  List<JournalPhotoDraft> photos = const [],
}) =>
    ServiceEventDraft(
      date: date ?? DateTime(2026, 9, 1),
      kind: kind,
      costCents: costCents,
      partsUsed: partsUsed,
      notes: notes,
      photos: photos,
    );
