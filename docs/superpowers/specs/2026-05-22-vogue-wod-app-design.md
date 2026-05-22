# Vogue WOD — Design Spec

**Date:** 2026-05-22
**Status:** Approved (owner delegated full decision authority to the agent)
**Author:** Claude (driving the full cycle autonomously)

## 1. Goal

A friendly mobile client (Android + iOS) that shows the daily workout (WOD)
for **Vogue Fitness UAE** branches, sourced from the same data published at
<https://vfuae.com/wod/>.

The single success criterion, in the owner's words:

> "A mobile client which I can run and which will show me the available
> trainings in a friendly way — e.g. I mostly use one branch, so on launch I
> should see today's training for my favorite location."

## 2. Data source — investigation result

The public WOD page is a WordPress site (`vfuae.com`) rendering a
**GravityView** list of Gravity Forms entries (form id `30`).

- GravityView's REST API (`/wp-json/gravityview/v1/views/.../entries`) is
  **locked down** — returns `rest_forbidden_access_denied`. No clean JSON API.
- The full schedule **is** embedded in the rendered HTML of `/wod/`
  (~537 KB, ~323 entries). This is the data source we use.

### Entry markup (stable GravityView structure)

```html
<div id="gv_list_XXXXX" class="gv-list-view">
  <div class="gv-list-view-title">
    <div class="gv-list-view-subtitle">
      <h4 class="gv-field-30-5">05/05/2026</h4>              <!-- date DD/MM/YYYY -->
      <h4 class="gv-field-30-2">Vogue Fitness | JLT</h4>     <!-- location -->
      <h4 class="gv-field-30-3">VogueFit</h4>                <!-- program -->
    </div>
  </div>
  <div class="gv-grid gv-list-view-content">
    <div class="gv-grid-col-2-3 gv-list-view-content-description">
      <div class="gv-field-30-4"><p>...workout...<br/>...</p></div> <!-- details -->
    </div>
  </div>
</div>
```

### Data dimensions (snapshot 2026-05-22)

- **10 branches:** Yas Marina, Yas Ladies, Marina Mall Mixed, Al Raha, JLT,
  Al Ghadeer, Al Ain Mixed, Al Ain Ladies, Saadiyat, Stamina.
  (Location strings carry a `Vogue Fitness | ` prefix that we strip.)
- **5 program types:** VogueFit, Metcon, WOD, Speciality, Stamina.
- **~25 days** of programming at any time (rolling ~3-4 week window).
- A `(branch, date)` pair may have **0..N** entries (often 1, sometimes a
  branch runs more than one program a day).
- The description field is HTML (`<p>` blocks, `<br>` lines). It contains
  named sections (Prep / Metcon / Strength / Individual Workout …) and ends
  with a fixed boilerplate line: *"NO RESERVATION, NO CLASS. MORE THAN 5
  MINUTES LATE = NO ENTRY TO CLASS"* — surfaced separately as a footer note.

### Data strategy

On-device fetch + parse. **No backend** — the owner runs the app and it works.

1. App fetches `https://vfuae.com/wod/` over HTTPS.
2. `WodHtmlParser` parses the `gv-list-view` blocks into typed `Wod` models.
3. Parsed result is cached locally (JSON file) with a fetch timestamp.
4. On launch the app shows cached data instantly, then refreshes in the
   background; pull-to-refresh forces a refresh. Offline = cached data + a
   "last updated" label.

Resilience: all HTML-shape knowledge is isolated in `WodHtmlParser`. If the
site changes, exactly one file needs editing. The parser tolerates missing
fields per entry (skips a malformed block rather than failing the whole parse).

## 3. Product / UX

### Screens

1. **First-run location picker** — shown once when no favorite is set. Grid of
   the 10 branches. Selection is saved; the app never asks again (changeable
   later from the Today screen).
2. **Today** (home) — the launch destination. Shows the favorite branch's
   WOD(s) for today:
   - Branch name + a tappable branch switcher in the header.
   - Big, friendly date header ("Today · Fri 22 May").
   - One `WodCard` per program that day; program-type color-coded badge.
   - Empty state when the branch has no WOD today ("No WOD posted for
     today — swipe back/forward to see other days").
   - A horizontal **date strip** to move day-to-day without leaving Today.
3. **WOD detail** — full workout, sections rendered with clear hierarchy,
   boilerplate as a muted footer.
4. **Browse / All branches** (secondary) — for a chosen date, every branch's
   WOD in a scannable list; lets the owner peek at other locations.

### Key interactions

- Launch → Today for favorite branch, today's date. Zero taps to the goal.
- Swipe / tap date strip → previous / next day.
- Tap branch in header → branch switcher sheet → Today re-renders.
- Pull to refresh anywhere.
- A "favorite" star so switching branch can optionally update the default.

### Out of scope (YAGNI)

Class booking, login/accounts, reservations, push notifications, the
gym's marketing pages, kids/PT/swimming programs, search/filter by
movement or equipment, multi-language. The app is a **read-only WOD
viewer**. These can be added later; none are needed for the goal.

## 4. Architecture

A **single Flutter app package**, folder-layered (not the 16-package
workspace of x4 — that machinery is overkill for a read-only viewer).
Layering discipline is kept; packaging is pragmatic.

```
lib/
  main.dart                 app entrypoint + DI composition
  app.dart                  MaterialApp + router + theme
  core/
    result.dart             Result<T> / typed failures
    failure.dart            sealed AppFailure (network/parse/cache)
    logger.dart             thin Log.d/i/w/e wrapper (no bare print)
  domain/
    models/                 Wod, Branch, Program, WodSection (freezed)
    wod_repository.dart      repository interface (port)
  data/
    wod_html_parser.dart     HTML -> List<Wod>   (the only HTML-aware code)
    wod_remote_source.dart   http GET of /wod/
    wod_local_cache.dart     JSON file cache + timestamp
    wod_repository_impl.dart cache-first repository (adapter)
    prefs.dart               favorite branch persistence
  presentation/
    theme/                   design system (tokens + components)
    today/                   TodayScreen + TodayCubit
    browse/                  BrowseScreen + BrowseCubit
    detail/                  WodDetailScreen
    onboarding/              LocationPickerScreen
    widgets/                 WodCard, ProgramBadge, DateStrip, BranchSwitcher
test/
  data/                     parser tests (fixture-driven), repo, cache
  domain/                   model tests
  presentation/             cubit tests + a widget smoke test
  fixtures/                 vfuae_wod_sample.html (committed snapshot)
```

**Data flow:** `Screen → Cubit → WodRepository → (RemoteSource | Cache)`.
`WodRepositoryImpl` returns cache immediately, fetches+parses fresh data,
re-emits. Cubits expose a sealed `freezed` state (loading / data / empty /
error). UI renders state and emits intents — no business logic in widgets.

**State management:** `flutter_bloc` **Cubit** (simpler than full Bloc, right
size for this app; consistent with the owner's x4 experience).

**Models:** `freezed` + `json_serializable` (immutability + cache (de)serialization).

**Error handling:** sealed `AppFailure` (`NetworkFailure`, `ParseFailure`,
`CacheFailure`). Adapters translate native errors at the boundary; cubits map
failures to user-facing copy. Never let raw exceptions reach the UI.

## 5. Design system ("claude design")

Built with the `design-system` skill. Vogue Fitness is a CrossFit box —
the visual language is **bold, energetic, high-contrast, dark-first**.

- **Tokens:** color, typography, spacing (4-pt scale), radius, elevation,
  motion — all referenced through a `VogueTheme` / token classes. No raw
  `Color(...)` or ad-hoc `TextStyle` in feature code.
- **Palette:** dark surface base; one high-energy accent; a neutral ramp;
  semantic colors. Each **program type gets its own accent** so a WOD is
  identifiable at a glance (VogueFit / Metcon / WOD / Speciality / Stamina).
- **Typography:** large, confident display type for the workout content
  (it must be readable mid-session at arm's length); a clean body face for
  details. Defined as a type scale.
- **Components:** `WodCard`, `ProgramBadge`, `DateStrip`, `BranchTile`,
  `SectionHeading`, primary/secondary buttons, empty + error states.
- **Accessibility:** AA contrast on text, ≥44 px touch targets, respects
  text-scale, supports light + dark.

A short `DESIGN.md` records the token vocabulary (adapted, much slimmer
than x4's).

## 6. Testing strategy

TDD where it pays off most — the parser.

- **Parser tests (highest value):** a committed `vfuae_wod_sample.html`
  fixture; assert entry count, branch/program enumeration, date parsing
  (DD/MM/YYYY), section splitting, boilerplate stripping, and graceful
  handling of a malformed block. Written before the parser.
- **Repository tests:** fake remote + in-memory cache → assert cache-first
  emission, refresh, offline fallback, failure mapping.
- **Cubit tests:** `bloc_test` → state sequences for load / refresh / empty
  / error and branch switching.
- **Widget smoke test:** Today screen renders a WodCard from seeded state.

Not tested: exact pixel layout, the live network (parser runs on a frozen
fixture; a separate opt-in test may hit the live site to detect upstream
drift).

## 7. Contribution guidelines

`vogue` currently has a one-line README. We add a slimmed, fit-for-purpose
`AGENTS.md` adapted from x4 — keeping the points that fit a small read-only
app and dropping the enterprise machinery.

**Kept from x4:** layering discipline (domain/data/presentation), Cubit/Bloc
state-owner pattern, sealed exception hierarchy, no bare `print` (use the
logger), `very_good_analysis` + the key lint rules (`avoid_print`,
`prefer_const_constructors`, `prefer_final_locals`, `require_trailing_commas`,
`unawaited_futures`, `directives_ordering`), design-tokens-only styling,
`freezed` immutable models, spec→plan→execute docs flow, a local
`tool/dev/check.sh` mirroring CI, conventional commits.

**Dropped (not a fit):** 16-package pub workspace, hexagonal micro-packages,
SQLCipher storage, DI codegen micro-packages, Matrix/integration harness,
flavors, l10n/ARB infrastructure, Jenkins release pipelines, grep-based lint
guard scripts.

## 8. Build / run

Standard Flutter — no special toolchain.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed/json
flutter test
flutter run                                                # iOS / Android
```

A connected iPhone and macOS/Chrome are available in the dev environment, so
the app is verified to build and run before completion.

## 9. Execution plan (big-company style)

Decomposed into tracks; independent tracks run as parallel subagents.

- **Phase 1 (parallel):** (a) scaffold + tooling, then (b) data layer TDD and
  (c) design system run concurrently.
- **Phase 2:** presentation (Today, Browse, detail, onboarding) — depends on
  domain models + design system.
- **Phase 3:** integration, `analyze`/`test`/`build` green, contribution
  guidelines + README, on-device run verification.

A detailed step-by-step plan follows in
`docs/superpowers/plans/2026-05-22-vogue-wod-app-plan.md`.
