# Back Forty — Google Play Store Listing

Copy-paste source for the Play Console listing. Character limits noted
per field; counts verified at draft time (2026-09-05).

---

## App name (max 30 chars)

> Back Forty: Home Service Log

(28 chars. Alternatives: "Back Forty" alone (10); "Back Forty — Rural
Maintenance" (30).)

## Short description (max 80 chars)

> Service records for everything on your land — well, septic, generator, fleet.

(78 chars — the tagline IS the pitch.)

## Full description (max 4000 chars)

> **Service records for everything on your land.**
>
> The well, the septic, the generator, the softener — plus the boat,
> the snowblower, the mower. What was done, when, what it cost, and
> what's due next. Out of your head, off the fridge, and out of that
> folder of receipts.
>
> **The property**
> • Systems and equipment, each with a spec sheet — the numbers you
>   dig for every time (GPM, filter model, oil weight, belt number)
> • Service history per item: what, when, cost, parts, receipt photos
> • Next-due badges on the home screen; an overdue banner you can't
>   miss
>
> **What's due**
> Recurring obligations, your way: every N days or every fall/spring.
> The pump-out, the filter change, the winterize — one screen shows
> what the land is owed, oldest debts first. Pro turns them into
> reminders that arrive on time.
>
> **Seasonal checklists**
> Build the fall-storage and spring-start rituals once. Next year they
> come back with your notes — where the fogging oil is, what the
> stabilizer mix was — unchecked and ready.
>
> **The converter**
> That folder of receipts? Photograph it 20 pages at a time. Back
> Forty reads each page — item, date, what was done, cost — you
> confirm every value, and years of history file themselves. The
> nameplate scanner reads model, serial, and ratings straight off the
> pump or the engine plate.
>
> **Trends (Pro)**
> Service spend by year. How often the wrenches come out. Total cost
> of ownership per item — the number that settles the repair-or-replace
> argument. Export everything as CSV or a full backup: the record a
> buyer or an insurance adjuster asks for.
>
> **Private by construction**
> No account. No cloud. No analytics. Page reading happens on-device,
> and reminders are local notifications — your phone talking to its
> own future self. First 3 systems and 2 pieces of equipment free
> forever; Pro is a cheap monthly or a one-time lifetime — equal
> citizens, because nobody out here likes subscriptions.
>
> The records are yours. We never see them.

## Keywords (App Store keyword field; woven into Play description above)

well maintenance log, septic tracker, generator service log, home
maintenance rural, equipment service log, winterize checklist,
property maintenance, service records

## Category

House & Home (secondary consideration: Lifestyle)

## Privacy policy URL

https://code-cowboys.com/privacy/backforty
(Source text: `docs/privacy-policy.md` — publish before submission.)

---

## Screenshots (phone, 1080×2400, DEMO_SEED data)

Run `flutter run --dart-define=DEMO_SEED=true`; the seed plants the
well/septic/generator/snowblower/boat cast with three years of
history, two overdue badges, and a carried checklist. Order per the
prompt:

1. **Home with due badges** — Systems and Equipment sections, the red
   Overdue on the generator and the trailer bearings. Caption:
   "Everything on your land, and what it's owed."
2. **The service timeline** — The Well: spec sheet card + six filter
   changes and the Friday-night pressure-switch story. Caption:
   "What was done, when, what it cost."
3. **The seasonal checklist** — the boat's fall storage list with its
   carried notes. Caption: "Build the ritual once. Keep it forever."
4. **The nameplate scan** — "The plate says" confirm dialog over the
   equipment composer (needs a REAL nameplate on-device; demo build is
   already Pro). Caption: "Shoot the plate. The spec sheet fills
   itself."
5. **Trends** — spend by year, events by year, the TCO table.
   Caption: "The number that settles repair-or-replace."
6. **The paywall framing** — a fresh non-demo install at the gate, or
   the sheet itself with both equal-citizen prices visible. Caption:
   "Cheap monthly or one-time lifetime. Nobody out here likes
   subscriptions."

Shot 6 needs a NON-demo build (demo fakes Pro).

Feature graphic (1024×500) and 512px store icon: derive from
`assets/icon/` art — soil brown, the barn-and-wrench mark, wordmark
right. TODO alongside first upload.
