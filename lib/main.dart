import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'data/database/app_database.dart';
import 'data/providers.dart';
import 'features/reminders/reminder_sync.dart';
import 'features/scan_import/scan_import_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase.open();
  final documents = await getApplicationDocumentsDirectory();
  final photosDir =
      await Directory('${documents.path}/photos').create(recursive: true);

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        documentScanServiceProvider
            .overrideWithValue(MlKitDocumentScanService()),
        textRecognitionServiceProvider
            .overrideWithValue(MlKitTextRecognitionService()),
        photoServiceProvider.overrideWithValue(
            ImagePickerPhotoService(photosDir, filePrefix: 'photo')),
        shareLauncherProvider.overrideWithValue(SharePlusLauncher()),
        tempDirProvider.overrideWithValue(getTemporaryDirectory),
        reminderSchedulerProvider.overrideWithValue(
            LocalNotificationsScheduler(
                channelId: 'backforty_reminders',
                channelName: 'Service reminders')),
      ],
      child: const BackFortyApp(),
    ),
  );
}
