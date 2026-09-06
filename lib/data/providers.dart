import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'repositories/checklist_repository.dart';
import 'repositories/equipment_repository.dart';
import 'repositories/interval_repository.dart';
import 'repositories/service_event_repository.dart';
import 'repositories/system_repository.dart';

/// Overridden in main() with the real on-device database, and in tests
/// with an in-memory one.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);

/// Overridden in tests with [InMemoryKeyValueStore].
final kvStoreProvider = Provider<KeyValueStore>((ref) => SharedPrefsStore());

/// Overridden in main() with ImagePickerPhotoService over the app's
/// photo directory, and in tests with a fake.
final photoServiceProvider = Provider<PhotoService>(
  (ref) => throw UnimplementedError('photoServiceProvider must be overridden'),
);

/// Overridden in main() with cc_core's SharePlusLauncher, and in tests
/// with FakeShareLauncher.
final shareLauncherProvider = Provider<ShareLauncher>(
  (ref) =>
      throw UnimplementedError('shareLauncherProvider must be overridden'),
);

/// Overridden in main() with path_provider's temp dir, and in tests
/// with a system temp directory.
final tempDirProvider = Provider<Future<Directory> Function()>(
  (ref) => throw UnimplementedError('tempDirProvider must be overridden'),
);

/// cc_core's journal repository over this database's generated tables.
final journalRepositoryProvider = Provider<AppJournalRepository>(
  (ref) => ref
      .watch(databaseProvider)
      .journal(photoStore: ref.watch(photoServiceProvider)),
);

final serviceEventRepositoryProvider = Provider<ServiceEventRepository>(
  (ref) => ServiceEventRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider)),
);

final intervalRepositoryProvider = Provider<IntervalRepository>(
  (ref) => IntervalRepository(ref.watch(databaseProvider)),
);

final systemRepositoryProvider = Provider<SystemRepository>(
  (ref) => SystemRepository(ref.watch(databaseProvider),
      events: ref.watch(serviceEventRepositoryProvider),
      intervals: ref.watch(intervalRepositoryProvider)),
);

final equipmentRepositoryProvider = Provider<EquipmentRepository>(
  (ref) => EquipmentRepository(ref.watch(databaseProvider),
      events: ref.watch(serviceEventRepositoryProvider),
      intervals: ref.watch(intervalRepositoryProvider)),
);

final checklistRepositoryProvider = Provider<ChecklistRepository>(
  (ref) => ChecklistRepository(ref.watch(databaseProvider)),
);
