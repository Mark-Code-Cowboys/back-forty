import 'dart:async';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../intervals/whats_due_screen.dart';
import 'entitlements.dart';
import 'free_limit.dart';

final entitlementServiceProvider = Provider<EntitlementService>((ref) {
  final service =
      StoreEntitlementService(ref.watch(kvStoreProvider), bfStoreProducts);
  // Fire-and-forget lapse check; the cache answers until it lands.
  unawaited(service.refreshEntitlements());
  ref.onDispose(service.dispose);
  return service;
});

/// True when Pro is owned — the lifetime unlock or an active monthly.
/// Defaults false while loading so gating stays conservative.
final isProProvider = StreamProvider<bool>(
  (ref) => ref.watch(entitlementServiceProvider).watchUnlimited(),
);

/// Store failure messages so an open paywall sheet can show why
/// nothing happened.
final storeErrorsProvider = StreamProvider<String>(
  (ref) => ref.watch(entitlementServiceProvider).storeErrors,
);

/// Null while loading and null whenever the cap doesn't apply (Pro
/// owned) — the section chips simply disappear for paying users.
final systemsUsageProvider = Provider<FreeLimitUsage?>((ref) {
  final pro = ref.watch(isProProvider).value;
  final count = ref.watch(allSystemsProvider).value?.length;
  if (pro == null || pro || count == null) return null;
  return systemFreeLimit.usage(count);
});

/// See [systemsUsageProvider].
final equipmentUsageProvider = Provider<FreeLimitUsage?>((ref) {
  final pro = ref.watch(isProProvider).value;
  final count = ref.watch(allEquipmentProvider).value?.length;
  if (pro == null || pro || count == null) return null;
  return equipmentFreeLimit.usage(count);
});
