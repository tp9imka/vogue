# AGENTS.md — conventions for the WOD app

Conventions every contributor (human or LLM) follows. Adapted from the x4
project's guidelines, slimmed to fit a small, read-only Flutter app.

> **Read first:** the design spec and implementation plan in
> `docs/superpowers/`. They explain *why* the app is shaped the way it is.

## What this app is

A Flutter (Android + iOS) client that shows the daily workout (WOD) for
Vogue Fitness UAE branches. It has **no backend** — it fetches and parses
the public schedule from `vfuae.com/wod/` on-device and caches it locally.
It is a **read-only viewer**: no booking, no accounts, no notifications.

## Architecture

A single Flutter app package, folder-layered. Layering discipline is kept;
the 16-package workspace machinery of larger projects is deliberately not.

```
lib/
  main.dart          composition root — builds the dependency graph
  app.dart           MaterialApp.router + theme
  router.dart        GoRouter routes
  core/              AppFailure, Result, Log — no Flutter, no features
  domain/            models (freezed) + WodRepository port
  data/              parser, remote source, cache, repository impl, prefs
  presentation/
    theme/           design system — tokens, typography, ThemeData
    <feature>/       one folder per screen: <name>_screen.dart + <name>_cubit.dart
    widgets/         shared widgets
test/                mirrors lib/ ; fixtures/ holds the HTML snapshot
```

**Dependency rule — strictly one direction:**
`presentation → domain → core` and `data → domain → core`.
`domain` and `core` never import `data`, `presentation`, or `package:flutter`
beyond what `freezed` needs. Features depend on the `WodRepository` *port*
in `domain/`, never on a concrete adapter.

**Data flow:** `Screen → Cubit → WodRepository → (RemoteSource | Cache)`.

## Conventions

### State — Cubit owns it, widgets render it

- Each screen has a `Cubit` that owns a sealed `freezed` state union
  (`loading` / `data` / `empty` / `error`). Widgets read state and emit
  intents; they contain **no business logic**.
- The repository is cache-first: it returns cached data immediately, then
  re-emits fresh data. UI shows a "last updated / offline" hint when stale.

### Errors — sealed `AppFailure`, never a raw exception in the UI

- Every failure is a leaf of `sealed class AppFailure` in `lib/core/`
  (`NetworkFailure`, `ParseFailure`, `CacheFailure`).
- Adapters in `data/` translate native exceptions into an `AppFailure` at
  the boundary and return `Result<T>` (`Ok` / `Err`) — they do not throw
  across layers.
- Cubits map an `AppFailure` to user-facing copy (`AppFailure.message`).

### Logging — no bare `print`

Use `Log.d/i/w/e` from `lib/core/logger.dart`. `avoid_print` is a lint
error.

### Styling — design tokens only

- All color, spacing, radius, typography come from
  `lib/presentation/theme/`. **No raw `Color(0x…)` and no ad-hoc
  `TextStyle` in feature code** — add a token if one is missing.
- Program-type colors come from `program_palette.dart`.
- See `DESIGN.md` for the token vocabulary.

### Models — immutable, `freezed`

Domain models are `@freezed`. Models that are cached add `fromJson`/`toJson`
(`json_serializable`, `explicit_to_json` is on — see `build.yaml`). After
changing a `freezed`/json model, run `dart run build_runner build`.

### The HTML parser is the one fragile spot

All knowledge of the `vfuae.com` HTML shape lives in
`lib/data/wod_html_parser.dart` and nowhere else. If the site changes,
that is the only file to edit. The parser must **skip** a malformed entry,
never throw and lose the whole feed. Its tests run against the committed
fixture `test/fixtures/vfuae_wod_sample.html` — keep them deterministic.

## Lint

`analysis_options.yaml` extends `very_good_analysis` with `strict-casts`,
`strict-inference`, `strict-raw-types`, and enforces: `avoid_print`,
`prefer_const_constructors`, `prefer_final_locals`,
`require_trailing_commas`, `unawaited_futures`, `directives_ordering`.
Generated files (`*.g.dart`, `*.freezed.dart`) are excluded.

`flutter analyze` must print `No issues found!` before every commit.

## Secrets and sensitive content

The repo is **public**. Nothing in a tracked file or commit message
should be something you would not write on a postcard.

**Never commit:**

- **Android signing material** — `android/app/upload-keystore.jks`,
  `android/key.properties`, any other `*.jks` / `*.keystore`.
- **iOS signing material** — `*.p12`, `*.mobileprovision`, any
  exported development or distribution certificate.
- **Environment files** — `.env`, `.env.*`, anything containing
  credentials, API keys, or tokens.
- **Symbols** — `build/symbols/`. They are emitted at release time and
  must be backed up out-of-band (alongside the keystore), never to git.
- **Personal data** — real user emails, real names other than what is
  already in commit metadata, support tickets, payment screenshots, etc.

The repo `.gitignore` covers these paths. Do not add exceptions; if a
build needs a secret value, source it from a file the `.gitignore`
lists (locally) or from a CI secret store (in CI).

**Before pushing**, run:

```bash
bash tool/lint/no_committed_secrets.sh
```

It is part of `tool/dev/check.sh` and looks for the common shapes
(plaintext keystore passwords, AWS / Google / OpenAI key prefixes,
inline PEM private keys, etc.). A clean run prints `OK`.

**If a secret slips through:**

1. **Rotate the value first** — the moment a credential lands on
   GitHub, treat it as compromised. Generate a new one and update the
   real configuration.
2. **Then purge the history** with `git filter-repo` (or BFG). A new
   commit that just deletes the file does **not** remove it from the
   history that GitHub already has.
3. Force-push the cleaned history and notify anyone with a local clone
   to re-clone. (This is the only situation in which force-pushing
   `main` is justified.)

## Testing

**What we test:**
- The HTML parser — exhaustively, against the fixture (highest value).
- The repository — cache-first behaviour, offline fallback, failure mapping.
- Cubits — state sequences via `bloc_test`.
- One widget smoke test per primary screen.

**What we do not test:** pixel layout, the live network in unit tests
(an opt-in test may probe the live site to detect upstream drift).

Practise TDD on the parser, cache, repository, and cubits: failing test
first, then the minimal implementation.

## Workflow

1. **Brainstorm → spec.** Non-trivial work gets a design spec in
   `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.
2. **Plan.** A bite-sized implementation plan in
   `docs/superpowers/plans/YYYY-MM-DD-<topic>-plan.md`.
3. **Execute.** TDD, small commits.
4. **Verify.** `bash tool/dev/check.sh` must print `ALL GREEN` (format,
   analyze, test) before a PR.

### Commits

Conventional commits: `feat(scope): …`, `fix(scope): …`, `test(scope): …`,
`docs: …`, `chore: …`. One logical change per commit. Keep the build green
at every commit.

## Recipe — adding a screen

1. Create `lib/presentation/<feature>/<feature>_cubit.dart` — a `Cubit`
   with a `freezed` state union; depend on `WodRepository` (the port).
2. Write `test/presentation/<feature>_cubit_test.dart` first (`bloc_test`).
3. Create `lib/presentation/<feature>/<feature>_screen.dart` — wrap in
   `BlocProvider`, render per state, build only from theme tokens and
   shared widgets.
4. Add the route in `lib/router.dart`.
5. `bash tool/dev/check.sh` → green → commit.
