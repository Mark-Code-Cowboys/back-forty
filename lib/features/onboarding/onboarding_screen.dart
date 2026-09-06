import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../owners/system_composer_screen.dart';
import '../scan_import/notebook_flow.dart';

/// First run seen? Refreshed after onboarding completes.
final firstRunSeenProvider = FutureProvider<bool>(
  (ref) => FirstRunFlag(ref.watch(kvStoreProvider)).seen(),
);

/// The consent line is the cc_core privacy promise; the fork leads
/// with add-first-system — the kind picker in the composer does the
/// heavy lift of explaining what belongs here.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(WidgetRef ref) async {
    await FirstRunFlag(ref.read(kvStoreProvider)).markSeen();
    ref.invalidate(firstRunSeenProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScaffold(
      icon: Icons.cabin_outlined,
      positioning: 'Service records for everything on your land.',
      subtitle: 'The well, the septic, the generator, the seasonal '
          'fleet — what was done, when, what it cost, and what\'s due. '
          'Out of your head and off the fridge.',
      actions: [
        FilledButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add my first system'),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SystemComposerScreen(),
                fullscreenDialog: true,
              ),
            );
            await _finish(ref);
          },
        ),
        // The folder-of-receipts crowd arrives with history.
        OutlinedButton.icon(
          icon: const Icon(Icons.document_scanner_outlined),
          label: const Text('Import my service history'),
          onPressed: () async {
            // Run the flow first so this screen stays alive under it,
            // then swap to the shell.
            await runNotebookImport(context, ref);
            await _finish(ref);
          },
        ),
        TextButton(
          onPressed: () => _finish(ref),
          child: const Text('Just look around'),
        ),
      ],
    );
  }
}
