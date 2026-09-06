# Back Forty — Play monetization setup (manual checklist)

Do these in order — the products menu is hidden until Play has
processed a build containing the billing permission. Mirrors the
fleet checklists.

## 0. Payments profile (account level, one-time)

Already done. Skip.

## 1. Upload the AAB

Internal testing → Create release → `app-release.aab` (see
release-checklist.md for the build). The `in_app_purchase` plugin
embeds `com.android.vending.BILLING`; once Play processes the build,
**Monetize** unlocks.

## 2. One-time product (Monetize → Products → In-app products)

| Product ID | Name | Price |
| --- | --- | --- |
| `backforty_pro_lifetime` | Back Forty Pro — Lifetime | $19.99 |

Id must match `lib/features/monetization/entitlements.dart` exactly.
Purchase option ID: `buy`. Mark **Active**.

Description (≤200 chars, shown in the purchase dialog):

> Back Forty Pro, forever: unlimited systems and equipment, service
> reminders, scanning, and export. One purchase, no subscription —
> nobody out here likes subscriptions.

## 3. Subscription (Monetize → Products → Subscriptions)

| Product ID | Base plan ID | Billing | Price |
| --- | --- | --- | --- |
| `backforty_pro_monthly` | `monthly` | Monthly, auto-renewing | $1.49/mo |

Single base plan — cc_core's `premiumPrice()`/`buyPremium()` use the
first (only) plan. Enable the base plan, mark the subscription
**Active**.

Benefits list (shown on the store):
unlimited systems & equipment · service reminders · nameplate &
receipt scan · CSV export & backup.

The in-app sheet presents monthly and lifetime as EQUAL citizens and
the lifetime is NOT positioned as the discount — keep store pricing
consistent (lifetime ≈ 13 months).

## 4. License testers

Play Console → Settings → License testing: add the test account(s) so
sandbox purchases don't charge. Verify on-device per the 11-step
paywall pass in `release-checklist.md`.

## 5. Data safety form

All "No" (no data collected, no data shared), except:
- "On-device processing only" note for plate/receipt/page images
- Purchases: handled by Google Play

Back Forty makes no network calls of its own; reminders are local
notifications. The policy's wording is load-bearing — keep the two in
sync.

## App Store (later, with the Codemagic iOS lane)

`backforty_pro_lifetime` as a non-consumable; `backforty_pro_monthly`
as an auto-renewable subscription in its own group.
