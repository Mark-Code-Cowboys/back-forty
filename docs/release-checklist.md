# Back Forty — Release checklist

Work top to bottom; nothing ships with an unchecked box above it.

## Code

- [x] `pubspec.yaml` version bumped (`1.0.0+1` for the first release)
- [x] cc_core pinned to a pushed tag (currently `v0.19.0`) —
      `pubspec_overrides.yaml` is git-ignored and must NOT influence the
      release build: `flutter pub get` on a clean checkout resolves
- [x] `flutter analyze` — zero issues
- [x] `flutter test` — all green (50)
- [x] `dart run flutter_launcher_icons` output committed (android/ios)

## The 11-step paywall pass (both platforms, sandbox/license testers)

Run in order on a fresh install. Same pass on iOS once the Codemagic
lane exists — steps identical, StoreKit sandbox account instead.

1. [ ] Fresh install → onboarding → "Just look around": section chips
       read "0 of 3 free systems used" / "0 of 2 free equipment used",
       Trends shows the Pro teaser
2. [ ] Add 3 systems → the 4th opens the paywall instead of the sheet's
       composer
3. [ ] Add 2 equipment → the 3rd opens the paywall
4. [ ] Delete a piece of equipment → the slot FREES (live count —
       trading up the mower is not a paywall event)
5. [ ] Free user taps Add interval → the pitch, with Service reminders
       in the benefits; existing intervals still show and mark Done
6. [ ] Nameplate scan and receipt scan as free user → paywall first
7. [ ] Buy monthly (sandbox) → sheet closes itself, chips gone, the
       composer opens, Trends content live; first interval add asks for
       notification permission
8. [ ] Kill + relaunch offline → still Pro (entitlement cache); a due
       reminder fires (schedule one a few minutes out via a short
       everyDays for the test)
9. [ ] Cancel the subscription → after sandbox expiry + relaunch,
       gates return AND scheduled reminders are wiped (the sync wipes
       on entitlement lapse); records all still readable
10. [ ] Buy lifetime on a second tester from ITS OWN equal-citizen
        button → same entitlement
11. [ ] Uninstall → reinstall → Restore purchase → Pro returns; then
        restore a backup → records, photos, checklists intact

## On-device (Pixel), release build

- [ ] `flutter run --release` cold start < 2s, no red screens
- [ ] Onboarding shows once; kill/relaunch skips it
- [ ] Nameplate scan on a real pump/engine plate: "The plate says"
      verbatim, confirm fills model/serial/specs
- [ ] Notebook import with 3 real receipts: review shows transcriptions,
      edit one, file; unknown vendor becomes other-kind equipment
- [ ] Interval: mark Done → badge and What's-due roll forward; reminder
      reschedules (check system notification settings)
- [ ] Reboot the phone → scheduled reminders survive (boot receiver)
- [ ] Backup → share to Drive → wipe app data → restore → everything
      intact including checklist notes
- [ ] DEMO_SEED build only for screenshots — never the uploaded AAB
- [ ] Dark theme spot-check: home badges, detail banner, checklist,
      trends, paywall

## Store

- [ ] Privacy policy live at code-cowboys.com/privacy/backforty
      (source: `docs/privacy-policy.md`)
- [ ] Listing fields pasted from `docs/play-store-listing.md`
- [ ] Screenshots: 6 per the listing doc (#4 nameplate needs a real
      plate; #6 needs a non-demo build)
- [ ] Feature graphic + 512 store icon exported
- [ ] Products created per `docs/play-monetization-setup.md`, Active
- [ ] Data safety form matches the privacy policy

## Build & upload

- [ ] `android/key.properties` + keystore in place (never committed)
- [ ] `flutter build appbundle --release`
- [ ] Internal testing release; license testers run the 11-step pass
- [ ] Promote to closed → production when the boxes above are checked

## Post-launch

- [ ] Tag the app repo `v1.0.0`
- [ ] Note any cc_core friction found during release in
      course-ledger's `docs/cc-core-gaps.md` (the fleet ledger)
- [ ] Backlog: reminder lead-time setting (remind N days early),
      per-item cost budgets, checklist reorder by drag
