import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';

/// First run seen? Refreshed after onboarding completes.
final firstRunSeenProvider = FutureProvider<bool>(
  (ref) => FirstRunFlag(ref.watch(kvStoreProvider)).seen(),
);

/// PHASE F: replace the placeholder copy with the app's positioning
/// line and add the import-or-start-fresh fork (see Hitch Post's
/// onboarding for the house shape). The privacy promise stays.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(WidgetRef ref) async {
    await FirstRunFlag(ref.read(kvStoreProvider)).markSeen();
    ref.invalidate(firstRunSeenProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScaffold(
      icon: Icons.menu_book_outlined,
      positioning: 'Back Forty scaffold is alive.',
      subtitle: 'Phase F writes the real positioning line and the '
          'import-or-start-fresh fork here.',
      actions: [
        TextButton(
          onPressed: () => _finish(ref),
          child: const Text('Just look around'),
        ),
      ],
    );
  }
}
