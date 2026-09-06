import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// PLACEHOLDER DOMAIN — Phase A replaces this with the app's real
/// Drift schema and repositories. It exists so the freshly scaffolded
/// app demonstrates the house pattern end to end: a journal list, the
/// cc_core FreeLimit counter, and the gate on add.
final placeholderEntriesProvider =
    NotifierProvider<PlaceholderEntries, List<String>>(
        PlaceholderEntries.new);

class PlaceholderEntries extends Notifier<List<String>> {
  @override
  List<String> build() => const [];

  void add() => state = [...state, 'Entry ${state.length + 1}'];
}

/// The free tier this app will enforce for real in Phase C.
const freeLimit = FreeLimit(5, 'entries');

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(placeholderEntriesProvider);
    final theme = Theme.of(context);
    final usage = freeLimit.usage(entries.length);
    return Scaffold(
      appBar: AppBar(title: const Text('Back Forty')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          try {
            freeLimit.guard(used: entries.length, entitled: false);
            ref.read(placeholderEntriesProvider.notifier).add();
          } on FreeLimitReachedException {
            _showPaywallStub(context);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add entry'),
      ),
      body: entries.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book_outlined,
                        size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('Back Forty scaffold is alive.',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(
                      'Phase A replaces this placeholder with the real '
                      'domain. The add button demonstrates the free-tier '
                      'gate at ${freeLimit.count}.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              children: [
                // The house free-tier counter; Phase C hides it for
                // entitled users (usage == null there).
                FreeTierCounter(
                  usage: usage,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  onGoPro: () => _showPaywallStub(context),
                ),
                for (final entry in entries) ListTile(title: Text(entry)),
              ],
            ),
    );
  }

  void _showPaywallStub(BuildContext context) {
    showPaywallModal<void>(
      context,
      builder: (context) => PaywallSheetScaffold(
        icon: Icons.star_rounded,
        title: 'Back Forty Pro',
        highlight: freeLimit.usage(freeLimit.count).label,
        body: 'Phase C wires real products here via cc_core '
            'StoreEntitlementService; this stub proves the sheet.',
        primaryLabel: 'Buy (stub)',
        onPrimary: () => Navigator.of(context).pop(),
        onLater: () => Navigator.of(context).pop(),
      ),
    );
  }
}
