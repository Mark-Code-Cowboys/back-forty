import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'monetization_providers.dart';

/// Shows the Pro pitch. Resolves true if the user owns Pro when the
/// sheet closes (purchase or restore completed while it was open).
Future<bool> showPaywallSheet(BuildContext context) async {
  final result = await showPaywallModal<bool>(
    context,
    builder: (context) => const _PaywallSheet(),
  );
  return result ?? false;
}

class _PaywallSheet extends ConsumerWidget {
  const _PaywallSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyPrice = ref.watch(_monthlyPriceProvider).value;
    final lifetimePrice = ref.watch(_lifetimePriceProvider).value;
    final service = ref.read(entitlementServiceProvider);

    // Close with success the moment the entitlement lands.
    ref.listen(isProProvider, (_, next) {
      if (next.value == true && context.mounted) {
        Navigator.of(context).pop(true);
      }
    });

    // Purchase-stream failures land asynchronously; show them so
    // "nothing happened" always has a visible reason (offline taps
    // included, via runStoreAction).
    ref.listen(storeErrorsProvider, (_, next) {
      final message = next.value;
      if (message != null && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return PaywallSheetScaffold(
      icon: Icons.cabin_outlined,
      title: 'Back Forty Pro',
      body: 'Everything you\'ve recorded stays yours forever, free or '
          'not. Pro removes the caps and turns the intervals into '
          'reminders. Pick the price you like — the lifetime isn\'t a '
          'gimmick, it\'s for people who hate subscriptions. So are we.',
      benefits: const [
        PaywallBenefit(
          icon: Icons.all_inclusive,
          title: 'Unlimited systems and equipment',
          detail: 'The whole property, the whole fleet.',
        ),
        PaywallBenefit(
          icon: Icons.notifications_active_outlined,
          title: 'Service reminders',
          detail: 'The pump-out, the filter, the winterize — on time.',
        ),
        PaywallBenefit(
          icon: Icons.ios_share_outlined,
          title: 'Export and backup',
          detail: 'Your records back out — CSV and full backup.',
        ),
      ],
      // Equal citizens; lifetime is not the fine print.
      primaryLabel: 'Monthly · ${monthlyPrice ?? r'$1.49'} / month',
      onPrimary: () => runStoreAction(context, service.buyPremium),
      restoreLabel: 'Restore purchase',
      onRestore: () => runStoreAction(context, service.restorePurchases),
      extraActions: [
        FilledButton.tonalIcon(
          icon: const Icon(Icons.workspace_premium_outlined),
          label: Text('Lifetime · ${lifetimePrice ?? r'$19.99'} once'),
          onPressed: () => runStoreAction(context, service.buyUnlimited),
        ),
      ],
      onLater: () => Navigator.of(context).pop(false),
    );
  }
}

final _monthlyPriceProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(entitlementServiceProvider).premiumPrice(),
);

final _lifetimePriceProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(entitlementServiceProvider).unlimitedPrice(),
);
