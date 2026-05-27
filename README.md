# WOD — Functional Fitness

A friendly mobile client (Android + iOS) for the daily workout (WOD)
schedule of the Vogue Fitness UAE gym chain. It shows today's workout
for your favorite branch the moment you open it.

Built with Flutter. The published schedule at <https://vfuae.com/wod/>
is the source of truth — this app makes it pleasant to read on a phone.

> **Unaffiliated with Vogue Fitness.** The app reads their public WOD
> page and re-presents it for personal use. All workout content is the
> work of their coaches.

## What it does

- **Launches straight to today's WOD** for your home branch — zero taps.
- First run asks you to pick a home branch; it never asks again.
- Swipe through the days with a horizontal date strip.
- Switch branches from the header at any time.
- **Browse** every branch's workout for a chosen day.
- **Focus mode** — a huge-type, distraction-free view for reading the WOD
  at arm's length mid-session. The screen is kept awake while open.
- **Workout timer** — auto-detects AMRAP / EMOM / Tabata / For Time from
  the programming and runs a full-screen timer with haptic phase cues.
- **Training log** — tap DONE on any WOD to log it (optional score and
  note). The History tab tracks your weekly count and every entry.
- **Share** — send a formatted WOD to a buddy via the system share sheet.
- Works offline — the last fetched schedule is cached and shown with an
  "offline" hint.

It is a **read-only viewer**: no booking, no accounts, no notifications.

## How it gets the data

There is **no backend**. The app fetches the public WOD page from
`vfuae.com/wod/` and parses the schedule out of the page HTML on-device
(the site's GravityView JSON API is not publicly accessible). The parsed
schedule is cached locally between launches.

All knowledge of the page's HTML shape lives in one file —
`lib/data/wod_html_parser.dart`. If the upstream site changes, that is the
only place to fix.

## Quickstart

Requires the Flutter SDK (3.41+, Dart 3.11+).

```bash
flutter pub get
dart run build_runner build        # generates freezed / json code
flutter test                       # 22 tests
flutter run                        # pick a device when prompted
```

Run the full local check (format + analyze + test) before a PR:

```bash
bash tool/dev/check.sh             # prints ALL GREEN
```

## Project layout

| Path | Purpose |
|---|---|
| `lib/core/` | `AppFailure`, `Result`, `Log` — framework-free primitives. |
| `lib/domain/` | Immutable models (`Wod`, `Branch`, `Program`) + the `WodRepository` port. |
| `lib/data/` | HTML parser, network source, local cache, cache-first repository. |
| `lib/presentation/theme/` | The design system — tokens, typography, `ThemeData`. |
| `lib/presentation/` | Screens (Today / Browse / detail / onboarding) + their cubits + shared widgets. |
| `lib/router.dart`, `lib/app.dart`, `lib/main.dart` | Routing and the composition root. |
| `test/` | Parser, repository, cubit and widget tests (`test/fixtures/` holds the HTML snapshot). |
| `tool/dev/check.sh` | Local CI mirror. |
| `docs/superpowers/` | The design spec and implementation plan. |

## Releasing

The app is configured for release: app icon, splash, display name, an
Android upload-signing config, and the iOS export-compliance declaration.
See [`RELEASE.md`](RELEASE.md) for the full publishing runbook.

```bash
flutter build appbundle --release   # Android → Google Play (.aab)
flutter build ipa --release         # iOS → App Store (.ipa)
```

## Documentation

- [`AGENTS.md`](AGENTS.md) — conventions every contributor follows.
- [`DESIGN.md`](DESIGN.md) — the design-system reference.
- [`RELEASE.md`](RELEASE.md) — build & publishing runbook.
- [`PRIVACY.md`](PRIVACY.md) — the app's privacy policy.
- [`docs/superpowers/specs/`](docs/superpowers/specs/) — the design spec.
- [`docs/superpowers/plans/`](docs/superpowers/plans/) — the implementation plan.
