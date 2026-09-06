import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'data/database/app_database.dart';
import 'data/providers.dart';

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
        photoServiceProvider.overrideWithValue(
            ImagePickerPhotoService(photosDir, filePrefix: 'photo')),
      ],
      child: const BackFortyApp(),
    ),
  );
}
