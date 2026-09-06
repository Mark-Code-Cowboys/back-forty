import 'package:cc_core/cc_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Overridden in main() with the ML Kit scanner (Android); the default
/// makes flows fall back to the photo picker.
final documentScanServiceProvider = Provider<DocumentScanService>(
  (ref) => const UnsupportedDocumentScanService(),
);

/// Overridden in main() with the ML Kit recognizer, and in tests with
/// cc_core's [FakeTextRecognitionService].
final textRecognitionServiceProvider = Provider<TextRecognitionService>(
  (ref) => throw UnimplementedError(
      'textRecognitionServiceProvider must be overridden'),
);
