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
/// PHASE C adds the entitlement override here (see Hitch Post's
/// helpers for the full shape).
Widget testApp({
  required AppDatabase db,
  required Widget home,
  KeyValueStore? kvStore,
  List<Override> overrides = const [],
}) =>
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        photoServiceProvider.overrideWithValue(FakeAppPhotoService()),
        kvStoreProvider.overrideWithValue(kvStore ?? InMemoryKeyValueStore()),
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
