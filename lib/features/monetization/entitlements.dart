import 'package:cc_core/cc_core.dart';

// The billing wrapper, entitlement cache, and store types live in
// cc_core; this file keeps Back Forty's product catalog and re-exports
// the shared types for app import sites.
export 'package:cc_core/cc_core.dart'
    show
        EntitlementService,
        FakeEntitlementService,
        StoreEntitlementService,
        StoreProducts,
        StoreUnavailableException;

/// Store product ids. Must match the products configured in Play
/// Console (and later App Store Connect) exactly.
abstract final class ProductIds {
  static const proMonthly = 'backforty_pro_monthly';
  static const proLifetime = 'backforty_pro_lifetime';
  static const all = [proMonthly, proLifetime];
}

/// Back Forty's catalog: one Pro entitlement, sold as a cheap monthly
/// or a lifetime unlock — equal citizens, because this audience
/// resents subscriptions and the lifetime is NOT the discount option.
const bfStoreProducts = StoreProducts(
  lifetimeUnlock: ProductIds.proLifetime,
  premiumSubscription: ProductIds.proMonthly,
);
