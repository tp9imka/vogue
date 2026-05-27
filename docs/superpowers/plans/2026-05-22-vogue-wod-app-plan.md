# Vogue WOD App — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a runnable Flutter (Android + iOS) app that shows the daily
workout (WOD) for Vogue Fitness UAE branches, defaulting on launch to today's
WOD for the user's favorite branch.

**Architecture:** Single Flutter app package, folder-layered into
`domain / data / presentation`. Data is fetched on-device from
`vfuae.com/wod/` and parsed from GravityView HTML — no backend. A cache-first
repository serves cached data instantly and refreshes in the background.
Cubits own UI state; widgets render only.

**Tech Stack:** Flutter 3.41 / Dart 3.11, `flutter_bloc` (Cubit), `freezed` +
`json_serializable`, `http`, `html`, `shared_preferences`, `path_provider`,
`intl`, `very_good_analysis`. Tests: `flutter_test`, `bloc_test`, `mocktail`.

---

## File Structure

```
pubspec.yaml                         deps + flutter config
analysis_options.yaml                very_good_analysis + key lint rules
AGENTS.md                            contribution guidelines (adapted from x4)
DESIGN.md                            design-token vocabulary
README.md                            quickstart + run instructions
tool/dev/check.sh                    local check (format/analyze/test)

lib/
  main.dart                          entrypoint: build deps graph, runApp
  app.dart                           VogueApp: MaterialApp.router + theme
  router.dart                        GoRouter routes

  core/
    failure.dart                     sealed AppFailure (freezed union)
    result.dart                      Result<T> = ({T? data, AppFailure? failure})
    logger.dart                      Log.d/i/w/e wrapper over dart:developer

  domain/
    models/
      branch.dart                    Branch enum-like (id, displayName)
      program.dart                   Program enum (VogueFit/Metcon/WOD/Speciality/Stamina)
      wod_section.dart               WodSection { title?, lines<String> } (freezed)
      wod.dart                       Wod { date, branch, program, sections, note } (freezed+json)
    wod_repository.dart              abstract WodRepository

  data/
    wod_html_parser.dart             parseWods(String html) -> List<Wod>
    wod_remote_source.dart           WodRemoteSource.fetchHtml()
    wod_local_cache.dart             read/write List<Wod> + timestamp (JSON file)
    wod_repository_impl.dart         cache-first WodRepository
    favorite_branch_store.dart       read/write favorite Branch (shared_preferences)

  presentation/
    theme/
      vogue_tokens.dart              color/space/radius/elevation/duration tokens
      vogue_typography.dart          text style scale
      vogue_theme.dart               ThemeData builder from tokens
      program_palette.dart           per-program accent colors
    onboarding/
      location_picker_screen.dart    first-run favorite picker
    today/
      today_cubit.dart               TodayCubit + TodayState (freezed union)
      today_screen.dart              launch destination
    browse/
      browse_cubit.dart              BrowseCubit + BrowseState
      browse_screen.dart             all branches for a date
    detail/
      wod_detail_screen.dart         full WOD view
    widgets/
      wod_card.dart                  WodCard
      program_badge.dart             ProgramBadge
      date_strip.dart                horizontal day selector
      branch_switcher_sheet.dart     bottom sheet to change branch
      section_block.dart             renders one WodSection
      app_states.dart               LoadingView / EmptyView / ErrorView

test/
  fixtures/vfuae_wod_sample.html     committed HTML snapshot
  data/wod_html_parser_test.dart
  data/wod_local_cache_test.dart
  data/wod_repository_impl_test.dart
  domain/wod_test.dart
  presentation/today_cubit_test.dart
  presentation/today_screen_test.dart
```

---

## Phase 0 — Scaffold & Tooling

### Task 0.1: Create the Flutter project

**Files:** whole project tree.

- [ ] **Step 1: Scaffold into the existing repo**

The `vogue` repo already exists with `.git` and `README.md`. Scaffold in place:

```bash
cd <repo-root>
flutter create --org com.vfuae --project-name vogue_wod \
  --platforms ios,android --empty .
```

- [ ] **Step 2: Verify it builds**

Run: `flutter pub get && flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add -A && git commit -m "chore: scaffold Flutter app (ios+android)"
```

### Task 0.2: Dependencies

**Files:** Modify `pubspec.yaml`.

- [ ] **Step 1: Set dependencies**

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.0.0
  freezed_annotation: ^3.0.0
  json_annotation: ^4.9.0
  http: ^1.2.2
  html: ^0.15.4
  shared_preferences: ^2.3.2
  path_provider: ^2.1.4
  intl: ^0.20.0
  go_router: ^16.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  very_good_analysis: ^9.0.0
  build_runner: ^2.4.13
  freezed: ^3.0.0
  json_serializable: ^6.8.0
  bloc_test: ^10.0.0
  mocktail: ^1.0.4
```

- [ ] **Step 2: Resolve**

Run: `flutter pub get`
Expected: success. If a version is yanked/unavailable, take the latest
compatible stable and note it.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock && git commit -m "chore: add dependencies"
```

### Task 0.3: Lint config + local check script

**Files:** Modify `analysis_options.yaml`; Create `tool/dev/check.sh`.

- [ ] **Step 1: Write `analysis_options.yaml`**

```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    avoid_print: true
    prefer_const_constructors: true
    prefer_final_locals: true
    require_trailing_commas: true
    unawaited_futures: true
    directives_ordering: true
    public_member_api_docs: false
    always_use_package_imports: false
    sort_pub_dependencies: false
```

- [ ] **Step 2: Write `tool/dev/check.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
echo "== format =="; dart format --set-exit-if-changed lib test
echo "== analyze =="; flutter analyze
echo "== test ==";    flutter test
echo "ALL GREEN"
```

Then `chmod +x tool/dev/check.sh`.

- [ ] **Step 3: Verify + commit**

Run: `flutter analyze` → `No issues found!`
```bash
git add analysis_options.yaml tool/dev/check.sh
git commit -m "chore: lint config + local check script"
```

---

## Phase 1A — Data Layer (TDD)

### Task 1A.1: Save the HTML fixture

**Files:** Create `test/fixtures/vfuae_wod_sample.html`.

- [ ] **Step 1: Fetch and save a real snapshot**

```bash
mkdir -p test/fixtures
curl -sL -A "Mozilla/5.0" "https://vfuae.com/wod/" -o test/fixtures/vfuae_wod_sample.html
```

Add to `pubspec.yaml` under `flutter:` only if needed by tests — tests read
it from disk via `File`, so no asset entry required.

- [ ] **Step 2: Commit**

```bash
git add test/fixtures/vfuae_wod_sample.html
git commit -m "test: add vfuae WOD HTML fixture"
```

### Task 1A.2: Core — failures, result, logger

**Files:** Create `lib/core/failure.dart`, `lib/core/result.dart`, `lib/core/logger.dart`.

- [ ] **Step 1: `failure.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'failure.freezed.dart';

@freezed
sealed class AppFailure with _$AppFailure {
  const factory AppFailure.network({String? detail}) = NetworkFailure;
  const factory AppFailure.parse({String? detail}) = ParseFailure;
  const factory AppFailure.cache({String? detail}) = CacheFailure;
}
```

- [ ] **Step 2: `result.dart`**

```dart
import 'failure.dart';

sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

class Err<T> extends Result<T> {
  const Err(this.failure);
  final AppFailure failure;
}
```

- [ ] **Step 3: `logger.dart`**

```dart
import 'dart:developer' as dev;

class Log {
  const Log._();
  static void d(String m) => dev.log(m, level: 500, name: 'vogue');
  static void i(String m) => dev.log(m, level: 800, name: 'vogue');
  static void w(String m) => dev.log(m, level: 900, name: 'vogue');
  static void e(String m, [Object? err, StackTrace? st]) =>
      dev.log(m, level: 1000, name: 'vogue', error: err, stackTrace: st);
}
```

- [ ] **Step 4: Codegen + analyze + commit**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
git add lib/core && git commit -m "feat(core): failures, result, logger"
```

### Task 1A.3: Domain models — Branch & Program

**Files:** Create `lib/domain/models/branch.dart`, `lib/domain/models/program.dart`.

- [ ] **Step 1: `program.dart`**

```dart
enum Program {
  vogueFit('VogueFit'),
  metcon('Metcon'),
  wod('WOD'),
  speciality('Speciality'),
  stamina('Stamina');

  const Program(this.label);
  final String label;

  /// Matches the raw GravityView program string (case-insensitive).
  static Program fromRaw(String raw) {
    final v = raw.trim().toLowerCase();
    return Program.values.firstWhere(
      (p) => p.label.toLowerCase() == v,
      orElse: () => Program.wod,
    );
  }
}
```

- [ ] **Step 2: `branch.dart`**

```dart
enum Branch {
  yasMarina('Yas Marina'),
  yasLadies('Yas Ladies'),
  marinaMall('Marina Mall Mixed'),
  alRaha('Al Raha'),
  jlt('JLT'),
  alGhadeer('Al Ghadeer'),
  alAinMixed('Al Ain Mixed'),
  alAinLadies('Al Ain Ladies'),
  saadiyat('Saadiyat'),
  stamina('Stamina');

  const Branch(this.displayName);
  final String displayName;

  /// Parses a raw GravityView location like "Vogue Fitness | Yas Marina".
  static Branch? fromRaw(String raw) {
    final name = raw.split('|').last.trim().toLowerCase();
    for (final b in Branch.values) {
      if (b.displayName.toLowerCase() == name) return b;
    }
    return null;
  }
}
```

- [ ] **Step 3: Test `test/domain/wod_test.dart` (branch/program parsing portion)**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/domain/models/program.dart';

void main() {
  test('Branch.fromRaw strips the "Vogue Fitness |" prefix', () {
    expect(Branch.fromRaw('Vogue Fitness | Yas Marina'), Branch.yasMarina);
    expect(Branch.fromRaw('Vogue Fitness | Al Ain Mixed'), Branch.alAinMixed);
    expect(Branch.fromRaw('Unknown Place'), isNull);
  });

  test('Program.fromRaw is case-insensitive, defaults to wod', () {
    expect(Program.fromRaw('metcon'), Program.metcon);
    expect(Program.fromRaw('VogueFit'), Program.vogueFit);
    expect(Program.fromRaw('???'), Program.wod);
  });
}
```

- [ ] **Step 4: Run + commit**

Run: `flutter test test/domain/wod_test.dart` → PASS
```bash
git add lib/domain/models test/domain
git commit -m "feat(domain): Branch and Program models"
```

### Task 1A.4: Domain models — WodSection & Wod

**Files:** Create `lib/domain/models/wod_section.dart`, `lib/domain/models/wod.dart`.

- [ ] **Step 1: `wod_section.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'wod_section.freezed.dart';
part 'wod_section.g.dart';

@freezed
abstract class WodSection with _$WodSection {
  const factory WodSection({
    String? title,
    required List<String> lines,
  }) = _WodSection;

  factory WodSection.fromJson(Map<String, dynamic> json) =>
      _$WodSectionFromJson(json);
}
```

- [ ] **Step 2: `wod.dart`**

`branch`/`program` serialize via their enum index for the cache.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'branch.dart';
import 'program.dart';
import 'wod_section.dart';
part 'wod.freezed.dart';
part 'wod.g.dart';

@freezed
abstract class Wod with _$Wod {
  const factory Wod({
    required DateTime date,
    required Branch branch,
    required Program program,
    required List<WodSection> sections,
    String? note,
  }) = _Wod;

  factory Wod.fromJson(Map<String, dynamic> json) => _$WodFromJson(json);
}
```

- [ ] **Step 3: Codegen + analyze**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

- [ ] **Step 4: Append round-trip test to `test/domain/wod_test.dart`**

```dart
  test('Wod survives a JSON round-trip', () {
    final wod = Wod(
      date: DateTime(2026, 5, 22),
      branch: Branch.jlt,
      program: Program.metcon,
      sections: const [WodSection(title: 'Metcon', lines: ['100 cal row'])],
      note: 'NO RESERVATION...',
    );
    expect(Wod.fromJson(wod.toJson()), wod);
  });
```

- [ ] **Step 5: Run + commit**

Run: `flutter test test/domain/wod_test.dart` → PASS
```bash
git add lib/domain/models test/domain
git commit -m "feat(domain): Wod and WodSection models"
```

### Task 1A.5: HTML parser (TDD — the critical component)

**Files:** Create `lib/data/wod_html_parser.dart`, `test/data/wod_html_parser_test.dart`.

- [ ] **Step 1: Write failing tests against the fixture**

```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:vogue_wod/data/wod_html_parser.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/domain/models/program.dart';

void main() {
  late String html;
  setUpAll(() {
    html = File('test/fixtures/vfuae_wod_sample.html').readAsStringSync();
  });

  test('parses many WOD entries', () {
    final wods = parseWods(html);
    expect(wods.length, greaterThan(100));
  });

  test('every parsed WOD has a known branch and non-empty sections', () {
    for (final w in parseWods(html)) {
      expect(Branch.values, contains(w.branch));
      expect(w.sections, isNotEmpty);
    }
  });

  test('dates are parsed as DD/MM/YYYY', () {
    final wods = parseWods(html);
    expect(wods.every((w) => w.date.year == 2026), isTrue);
    expect(wods.any((w) => w.date.month == 5), isTrue);
  });

  test('boilerplate is moved out of sections into note', () {
    final withNote = parseWods(html).where((w) => w.note != null);
    expect(withNote, isNotEmpty);
    for (final w in withNote) {
      expect(w.note!.toUpperCase(), contains('NO RESERVATION'));
      for (final s in w.sections) {
        for (final l in s.lines) {
          expect(l.toUpperCase().contains('NO RESERVATION'), isFalse);
        }
      }
    }
  });

  test('all five program types appear', () {
    final progs = parseWods(html).map((w) => w.program).toSet();
    expect(progs, containsAll(Program.values));
  });

  test('returns empty list for junk input without throwing', () {
    expect(parseWods('<html><body>nothing</body></html>'), isEmpty);
  });
}
```

- [ ] **Step 2: Run to confirm failure**

Run: `flutter test test/data/wod_html_parser_test.dart`
Expected: FAIL — `parseWods` undefined.

- [ ] **Step 3: Implement the parser**

Algorithm: query every `.gv-list-view`. For each, read the three
`.gv-field-30-5/-2/-3` h4s (date / location / program). If branch is
unknown, skip the block. Parse `.gv-field-30-4` into sections: split on
`<p>` elements; within a paragraph split on `<br>` into lines; a paragraph
whose single line looks like a heading (short, no digits-heavy) becomes the
next section's `title`. Strip the `NO RESERVATION` line into `note`.

```dart
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import '../core/logger.dart';
import '../domain/models/branch.dart';
import '../domain/models/program.dart';
import '../domain/models/wod.dart';
import '../domain/models/wod_section.dart';

const _noteMarker = 'NO RESERVATION';

List<Wod> parseWods(String html) {
  final doc = html_parser.parse(html);
  final out = <Wod>[];
  for (final el in doc.querySelectorAll('.gv-list-view')) {
    final wod = _parseEntry(el);
    if (wod != null) out.add(wod);
  }
  return out;
}

Wod? _parseEntry(Element el) {
  final dateRaw = el.querySelector('.gv-field-30-5')?.text.trim();
  final locRaw = el.querySelector('.gv-field-30-2')?.text.trim();
  final progRaw = el.querySelector('.gv-field-30-3')?.text.trim();
  final descEl = el.querySelector('.gv-field-30-4');
  if (dateRaw == null || locRaw == null || progRaw == null) return null;

  final branch = Branch.fromRaw(locRaw);
  final date = _parseDate(dateRaw);
  if (branch == null || date == null) {
    Log.w('skipped WOD block: loc="$locRaw" date="$dateRaw"');
    return null;
  }
  final parsed = _parseDescription(descEl);
  if (parsed.sections.isEmpty) return null;

  return Wod(
    date: date,
    branch: branch,
    program: Program.fromRaw(progRaw),
    sections: parsed.sections,
    note: parsed.note,
  );
}

DateTime? _parseDate(String raw) {
  final m = RegExp(r'(\d{1,2})/(\d{1,2})/(\d{4})').firstMatch(raw);
  if (m == null) return null;
  return DateTime(
    int.parse(m.group(3)!),
    int.parse(m.group(2)!),
    int.parse(m.group(1)!),
  );
}

class _Desc {
  const _Desc(this.sections, this.note);
  final List<WodSection> sections;
  final String? note;
}

_Desc _parseDescription(Element? descEl) {
  if (descEl == null) return const _Desc([], null);
  // Each <p> -> a paragraph; split inner text on <br> into lines.
  final paragraphs = <List<String>>[];
  final ps = descEl.querySelectorAll('p');
  final elements = ps.isNotEmpty ? ps : [descEl];
  for (final p in elements) {
    final lines = _lines(p);
    if (lines.isNotEmpty) paragraphs.add(lines);
  }

  String? note;
  final sections = <WodSection>[];
  for (final para in paragraphs) {
    final kept = <String>[];
    for (final line in para) {
      if (line.toUpperCase().contains(_noteMarker)) {
        note = line;
      } else {
        kept.add(line);
      }
    }
    if (kept.isEmpty) continue;
    if (kept.length == 1 && _looksLikeHeading(kept.first)) {
      sections.add(WodSection(title: kept.first, lines: const []));
    } else if (sections.isNotEmpty && sections.last.lines.isEmpty) {
      sections[sections.length - 1] =
          WodSection(title: sections.last.title, lines: kept);
    } else {
      sections.add(WodSection(lines: kept));
    }
  }
  return _Desc(sections.where((s) => s.lines.isNotEmpty || s.title != null)
      .toList(), note);
}

List<String> _lines(Element p) {
  // innerHtml split on <br> tags, each chunk stripped of tags + decoded.
  final raw = p.innerHtml.split(RegExp(r'<br\s*/?>', caseSensitive: false));
  return raw
      .map((chunk) => html_parser.parseFragment(chunk).text?.trim() ?? '')
      .where((s) => s.isNotEmpty)
      .toList();
}

bool _looksLikeHeading(String line) {
  if (line.length > 32) return false;
  final digits = RegExp(r'\d').allMatches(line).length;
  return digits <= 2 && !line.contains(RegExp(r'[.:]\s'));
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/data/wod_html_parser_test.dart`
Expected: all PASS. If a heading-detection assertion fails, tune
`_looksLikeHeading` thresholds against the fixture — do not weaken the
`note`/`branch` assertions.

- [ ] **Step 5: Commit**

```bash
git add lib/data/wod_html_parser.dart test/data/wod_html_parser_test.dart
git commit -m "feat(data): WOD HTML parser"
```

### Task 1A.6: Remote source

**Files:** Create `lib/data/wod_remote_source.dart`.

- [ ] **Step 1: Implement**

```dart
import 'package:http/http.dart' as http;
import '../core/failure.dart';
import '../core/result.dart';

const wodUrl = 'https://vfuae.com/wod/';

class WodRemoteSource {
  WodRemoteSource({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<Result<String>> fetchHtml() async {
    try {
      final res = await _client
          .get(Uri.parse(wodUrl), headers: const {'User-Agent': 'VogueWOD/1.0'})
          .timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) {
        return Err(AppFailure.network(detail: 'HTTP ${res.statusCode}'));
      }
      return Ok(res.body);
    } on Object catch (e) {
      return Err(AppFailure.network(detail: '$e'));
    }
  }
}
```

- [ ] **Step 2: Analyze + commit**

```bash
flutter analyze
git add lib/data/wod_remote_source.dart
git commit -m "feat(data): WOD remote source"
```

### Task 1A.7: Local cache (TDD)

**Files:** Create `lib/data/wod_local_cache.dart`, `test/data/wod_local_cache_test.dart`.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vogue_wod/data/wod_local_cache.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/domain/models/program.dart';
import 'package:vogue_wod/domain/models/wod.dart';
import 'package:vogue_wod/domain/models/wod_section.dart';

void main() {
  test('write then read returns the same wods', () async {
    final cache = WodLocalCache.inMemory();
    final wods = [
      Wod(
        date: DateTime(2026, 5, 22),
        branch: Branch.jlt,
        program: Program.metcon,
        sections: const [WodSection(lines: ['row'])],
      ),
    ];
    await cache.write(wods);
    final snapshot = await cache.read();
    expect(snapshot!.wods, wods);
    expect(snapshot.fetchedAt, isNotNull);
  });

  test('read returns null when nothing was cached', () async {
    expect(await WodLocalCache.inMemory().read(), isNull);
  });
}
```

- [ ] **Step 2: Run → FAIL (`WodLocalCache` undefined)**

Run: `flutter test test/data/wod_local_cache_test.dart`

- [ ] **Step 3: Implement**

`WodLocalCache` writes a JSON file (`wod_cache.json`) under the app
documents dir; `inMemory()` is a test seam backed by a `String?`.

```dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../domain/models/wod.dart';

class CacheSnapshot {
  const CacheSnapshot(this.wods, this.fetchedAt);
  final List<Wod> wods;
  final DateTime fetchedAt;
}

abstract class WodLocalCache {
  factory WodLocalCache.file() = _FileCache;
  factory WodLocalCache.inMemory() = _MemoryCache;
  Future<void> write(List<Wod> wods);
  Future<CacheSnapshot?> read();
}

String _encode(List<Wod> wods) => jsonEncode({
      'fetchedAt': DateTime.now().toIso8601String(),
      'wods': wods.map((w) => w.toJson()).toList(),
    });

CacheSnapshot? _decode(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final map = jsonDecode(raw) as Map<String, dynamic>;
  final wods = (map['wods'] as List)
      .map((e) => Wod.fromJson(e as Map<String, dynamic>))
      .toList();
  return CacheSnapshot(wods, DateTime.parse(map['fetchedAt'] as String));
}

class _MemoryCache implements WodLocalCache {
  String? _raw;
  @override
  Future<void> write(List<Wod> wods) async => _raw = _encode(wods);
  @override
  Future<CacheSnapshot?> read() async => _decode(_raw);
}

class _FileCache implements WodLocalCache {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/wod_cache.json');
  }

  @override
  Future<void> write(List<Wod> wods) async =>
      (await _file()).writeAsString(_encode(wods));

  @override
  Future<CacheSnapshot?> read() async {
    final f = await _file();
    if (!f.existsSync()) return null;
    return _decode(await f.readAsString());
  }
}
```

- [ ] **Step 4: Run → PASS; commit**

```bash
flutter test test/data/wod_local_cache_test.dart
git add lib/data/wod_local_cache.dart test/data/wod_local_cache_test.dart
git commit -m "feat(data): WOD local cache"
```

### Task 1A.8: Favorite branch store

**Files:** Create `lib/data/favorite_branch_store.dart`.

- [ ] **Step 1: Implement**

```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/branch.dart';

class FavoriteBranchStore {
  static const _key = 'favorite_branch';

  Future<Branch?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    if (name == null) return null;
    return Branch.values.where((b) => b.name == name).firstOrNull;
  }

  Future<void> write(Branch branch) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, branch.name);
  }
}
```

- [ ] **Step 2: Analyze + commit**

```bash
flutter analyze
git add lib/data/favorite_branch_store.dart
git commit -m "feat(data): favorite branch store"
```

### Task 1A.9: Repository (TDD)

**Files:** Create `lib/domain/wod_repository.dart`, `lib/data/wod_repository_impl.dart`,
`test/data/wod_repository_impl_test.dart`.

- [ ] **Step 1: `wod_repository.dart` (port)**

```dart
import '../core/result.dart';
import 'models/wod.dart';

class WodFeed {
  const WodFeed({required this.wods, required this.fetchedAt, required this.stale});
  final List<Wod> wods;
  final DateTime? fetchedAt;
  final bool stale; // true => served from cache, network failed
}

abstract class WodRepository {
  /// Cached snapshot if present (instant), else null.
  Future<WodFeed?> cached();

  /// Fetches fresh data; on network failure returns cached as stale.
  Future<Result<WodFeed>> refresh();
}
```

- [ ] **Step 2: Failing repository test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vogue_wod/core/failure.dart';
import 'package:vogue_wod/core/result.dart';
import 'package:vogue_wod/data/wod_local_cache.dart';
import 'package:vogue_wod/data/wod_remote_source.dart';
import 'package:vogue_wod/data/wod_repository_impl.dart';

class _MockRemote extends Mock implements WodRemoteSource {}

void main() {
  late _MockRemote remote;
  late WodLocalCache cache;
  setUp(() {
    remote = _MockRemote();
    cache = WodLocalCache.inMemory();
  });

  test('refresh fetches, parses, caches and returns fresh feed', () async {
    final html = '''<div class="gv-list-view">
      <h4 class="gv-field-30-5">22/05/2026</h4>
      <h4 class="gv-field-30-2">Vogue Fitness | JLT</h4>
      <h4 class="gv-field-30-3">Metcon</h4>
      <div class="gv-field-30-4"><p>100 cal row</p></div></div>''';
    when(remote.fetchHtml).thenAnswer((_) async => Ok(html));
    final repo = WodRepositoryImpl(remote: remote, cache: cache);

    final res = await repo.refresh();
    expect(res, isA<Ok<WodFeed>>());
    expect((res as Ok<WodFeed>).value.wods, hasLength(1));
    expect(res.value.stale, isFalse);
    expect((await repo.cached())!.wods, hasLength(1));
  });

  test('refresh falls back to stale cache on network failure', () async {
    final html = '''<div class="gv-list-view">
      <h4 class="gv-field-30-5">22/05/2026</h4>
      <h4 class="gv-field-30-2">Vogue Fitness | JLT</h4>
      <h4 class="gv-field-30-3">Metcon</h4>
      <div class="gv-field-30-4"><p>row</p></div></div>''';
    when(remote.fetchHtml).thenAnswer((_) async => Ok(html));
    final repo = WodRepositoryImpl(remote: remote, cache: cache);
    await repo.refresh(); // seed cache

    when(remote.fetchHtml)
        .thenAnswer((_) async => const Err(NetworkFailure()));
    final res = await repo.refresh();
    expect(res, isA<Ok<WodFeed>>());
    expect((res as Ok<WodFeed>).value.stale, isTrue);
  });

  test('refresh returns Err when network fails and cache empty', () async {
    when(remote.fetchHtml)
        .thenAnswer((_) async => const Err(NetworkFailure()));
    final repo = WodRepositoryImpl(remote: remote, cache: cache);
    expect(await repo.refresh(), isA<Err<WodFeed>>());
  });
}
```

- [ ] **Step 3: Run → FAIL; implement `wod_repository_impl.dart`**

```dart
import '../core/failure.dart';
import '../core/result.dart';
import '../domain/models/wod.dart';
import '../domain/wod_repository.dart';
import 'wod_html_parser.dart';
import 'wod_local_cache.dart';
import 'wod_remote_source.dart';

class WodRepositoryImpl implements WodRepository {
  WodRepositoryImpl({required WodRemoteSource remote, required WodLocalCache cache})
      : _remote = remote,
        _cache = cache;

  final WodRemoteSource _remote;
  final WodLocalCache _cache;

  @override
  Future<WodFeed?> cached() async {
    final snap = await _cache.read();
    if (snap == null) return null;
    return WodFeed(wods: snap.wods, fetchedAt: snap.fetchedAt, stale: true);
  }

  @override
  Future<Result<WodFeed>> refresh() async {
    final res = await _remote.fetchHtml();
    switch (res) {
      case Ok<String>(:final value):
        final List<Wod> wods = parseWods(value);
        if (wods.isEmpty) {
          final fallback = await cached();
          return fallback != null
              ? Ok(fallback)
              : const Err(ParseFailure(detail: 'no entries parsed'));
        }
        await _cache.write(wods);
        return Ok(WodFeed(wods: wods, fetchedAt: DateTime.now(), stale: false));
      case Err<String>(:final failure):
        final fallback = await cached();
        return fallback != null ? Ok(fallback) : Err(failure);
    }
  }
}
```

- [ ] **Step 4: Run → PASS; commit**

```bash
flutter test test/data
git add lib/domain/wod_repository.dart lib/data/wod_repository_impl.dart \
        test/data/wod_repository_impl_test.dart
git commit -m "feat(data): cache-first WOD repository"
```

---

## Phase 1B — Design System ("claude design")

> Built with the `design-system` skill. Vogue Fitness is a CrossFit box:
> **bold, energetic, high-contrast, dark-first.** All tokens; no raw colors
> or ad-hoc text styles in feature code.

### Task 1B.1: Tokens

**Files:** Create `lib/presentation/theme/vogue_tokens.dart`.

- [ ] **Step 1: Define color, spacing, radius, elevation, duration tokens**

A `VogueColors` class (dark surface ramp, one high-energy accent, neutral
ramp, semantic success/warning/error, on-colors), a `VogueSpace` 4-pt scale
(`xs 4, sm 8, md 12, lg 16, xl 24, xxl 32`), `VogueRadius` (`sm 8, md 14,
lg 20, pill 999`), `VogueElevation`, and `VogueDuration`. Exact values
chosen by the design-system skill run; all `static const`.

- [ ] **Step 2: Analyze + commit**

```bash
flutter analyze
git add lib/presentation/theme/vogue_tokens.dart
git commit -m "feat(theme): design tokens"
```

### Task 1B.2: Typography

**Files:** Create `lib/presentation/theme/vogue_typography.dart`.

- [ ] **Step 1: Type scale** — `display`, `headline`, `title`, `body`,
  `label`, plus a `workout` style (large, high line-height, readable at
  arm's length). Bold display face for headings, clean face for body.

- [ ] **Step 2: Analyze + commit**

```bash
git add lib/presentation/theme/vogue_typography.dart
git commit -m "feat(theme): typography scale"
```

### Task 1B.3: Program palette + theme

**Files:** Create `lib/presentation/theme/program_palette.dart`,
`lib/presentation/theme/vogue_theme.dart`.

- [ ] **Step 1: `program_palette.dart`** — `Color accentFor(Program)` and a
  matching soft background for each of the 5 program types.

- [ ] **Step 2: `vogue_theme.dart`** — `ThemeData buildVogueTheme()` wiring
  tokens + typography into `ColorScheme`, `cardTheme`, `appBarTheme`,
  `bottomSheetTheme`, etc. Dark theme is primary; a light variant optional.

- [ ] **Step 3: Analyze + commit**

```bash
flutter analyze
git add lib/presentation/theme/program_palette.dart \
        lib/presentation/theme/vogue_theme.dart
git commit -m "feat(theme): program palette + ThemeData"
```

### Task 1B.4: DESIGN.md

**Files:** Create `DESIGN.md`.

- [ ] **Step 1:** Document the token vocabulary, palette, type scale, program
  colors, spacing/radius, and do's/don'ts — a slim adaptation of x4's
  `DESIGN.md`.

- [ ] **Step 2: Commit**

```bash
git add DESIGN.md && git commit -m "docs: design system reference"
```

---

## Phase 2 — Presentation

### Task 2.1: Shared widgets

**Files:** Create `lib/presentation/widgets/program_badge.dart`,
`section_block.dart`, `wod_card.dart`, `date_strip.dart`,
`branch_switcher_sheet.dart`, `app_states.dart`.

- [ ] **Step 1: `program_badge.dart`** — pill showing `program.label`,
  colored via `program_palette`.

- [ ] **Step 2: `section_block.dart`** — renders one `WodSection`: optional
  title with `SectionHeading` style, then `lines` as a readable list.

- [ ] **Step 3: `wod_card.dart`** — card with header (branch + `ProgramBadge`),
  the first 1-2 sections preview, tap → `WodDetailScreen`.

- [ ] **Step 4: `date_strip.dart`** — horizontal scrollable day chips
  (`-3 … +N` around selected); `onSelected(DateTime)`.

- [ ] **Step 5: `branch_switcher_sheet.dart`** — modal bottom sheet listing
  the 10 branches with the current one marked; `onSelected(Branch)`.

- [ ] **Step 6: `app_states.dart`** — `LoadingView`, `EmptyView(message)`,
  `ErrorView(message, onRetry)`.

- [ ] **Step 7: Analyze + commit**

```bash
flutter analyze
git add lib/presentation/widgets
git commit -m "feat(ui): shared widgets"
```

### Task 2.2: TodayCubit (TDD)

**Files:** Create `lib/presentation/today/today_cubit.dart`,
`test/presentation/today_cubit_test.dart`.

- [ ] **Step 1: Define `TodayState` (freezed union)** — `loading`,
  `data(branch, selectedDate, wods, fetchedAt, stale)`, `error(message)`.
  `wods` is the list for `(branch, selectedDate)`.

- [ ] **Step 2: Write `bloc_test` cases**

Cover: `load()` emits `loading` then `data` with the favorite branch and
today's wods filtered from the feed; `selectDate(d)` re-filters; `selectBranch(b)`
re-filters and persists via `FavoriteBranchStore`; repository `Err` →
`error`. Use a fake `WodRepository` + fake `FavoriteBranchStore`.

- [ ] **Step 3: Run → FAIL; implement `TodayCubit`**

`TodayCubit(repository, favoriteStore)`: `load()` reads favorite (default
`Branch.yasMarina` if null), reads `cached()` for instant paint, then
`refresh()`; filtering helper `wodsFor(branch, date)` compares `date`
day-precision. `selectDate`/`selectBranch` mutate state from the held feed.

- [ ] **Step 4: Run → PASS; commit**

```bash
flutter test test/presentation/today_cubit_test.dart
git add lib/presentation/today test/presentation/today_cubit_test.dart
git commit -m "feat(today): TodayCubit"
```

### Task 2.3: TodayScreen

**Files:** Create `lib/presentation/today/today_screen.dart`;
Create `test/presentation/today_screen_test.dart`.

- [ ] **Step 1: Build the screen** — `BlocProvider<TodayCubit>`; app bar with
  branch name + switcher action; friendly date header; `DateStrip`;
  body switches on `TodayState` (`LoadingView` / list of `WodCard` /
  `EmptyView` "No WOD posted — try another day" / `ErrorView`);
  `RefreshIndicator` → `cubit.refresh()`; a "stale / last updated" line.

- [ ] **Step 2: Widget smoke test** — pump `TodayScreen` with a fake cubit
  seeded in `data` state; expect a `WodCard` and the branch name render.

- [ ] **Step 3: Analyze + test + commit**

```bash
flutter analyze && flutter test test/presentation/today_screen_test.dart
git add lib/presentation/today test/presentation/today_screen_test.dart
git commit -m "feat(today): TodayScreen"
```

### Task 2.4: WodDetailScreen

**Files:** Create `lib/presentation/detail/wod_detail_screen.dart`.

- [ ] **Step 1: Build** — full-screen WOD: branch + date + `ProgramBadge`
  header, all `WodSection`s via `SectionBlock`, `note` as a muted footer.

- [ ] **Step 2: Analyze + commit**

```bash
flutter analyze
git add lib/presentation/detail
git commit -m "feat(detail): WOD detail screen"
```

### Task 2.5: BrowseCubit + BrowseScreen

**Files:** Create `lib/presentation/browse/browse_cubit.dart`,
`browse_screen.dart`.

- [ ] **Step 1: `BrowseCubit`** — holds the feed; `selectDate(d)`; exposes,
  for the selected date, the WODs grouped by branch.

- [ ] **Step 2: `BrowseScreen`** — `DateStrip` + a scrollable list of every
  branch's WOD for that date (branch header + `WodCard`s, or a muted
  "no WOD" row). Tap → detail.

- [ ] **Step 3: Analyze + commit**

```bash
flutter analyze
git add lib/presentation/browse
git commit -m "feat(browse): all-branches browse screen"
```

### Task 2.6: LocationPickerScreen (onboarding)

**Files:** Create `lib/presentation/onboarding/location_picker_screen.dart`.

- [ ] **Step 1: Build** — branded intro + a grid of the 10 `Branch`es;
  selecting one calls `FavoriteBranchStore.write` and routes to Today.

- [ ] **Step 2: Analyze + commit**

```bash
flutter analyze
git add lib/presentation/onboarding
git commit -m "feat(onboarding): first-run location picker"
```

---

## Phase 3 — Integration, Verification, Docs

### Task 3.1: Router + app shell

**Files:** Create `lib/router.dart`, `lib/app.dart`.

- [ ] **Step 1: `router.dart`** — `GoRouter` with a bottom nav (Today,
  Browse). Initial route decided in `main`: location picker if no favorite,
  else Today. Routes: `/onboarding`, `/` (Today), `/browse`, `/wod` (detail
  via `extra: Wod`).

- [ ] **Step 2: `app.dart`** — `VogueApp` → `MaterialApp.router` with
  `buildVogueTheme()` and the router.

- [ ] **Step 3: Analyze + commit**

```bash
flutter analyze
git add lib/router.dart lib/app.dart
git commit -m "feat(app): router + app shell"
```

### Task 3.2: Composition root

**Files:** Modify `lib/main.dart`.

- [ ] **Step 1: Wire `main()`** — `WidgetsFlutterBinding.ensureInitialized()`;
  construct `WodRemoteSource`, `WodLocalCache.file()`, `WodRepositoryImpl`,
  `FavoriteBranchStore`; read favorite to choose the initial route;
  `runApp(VogueApp(...))` passing the dependencies down.

- [ ] **Step 2: Analyze + commit**

```bash
flutter analyze
git add lib/main.dart
git commit -m "feat(app): composition root"
```

### Task 3.3: Full green gate

- [ ] **Step 1: Run the local check**

Run: `bash tool/dev/check.sh`
Expected: `ALL GREEN` (format clean, `No issues found!`, all tests pass).
Fix anything red before proceeding.

- [ ] **Step 2: Build both platforms**

Run: `flutter build apk --debug` and `flutter build ios --debug --no-codesign`
Expected: both succeed.

- [ ] **Step 3: Run on a device**

Run: `flutter run` against the connected iPhone (or `-d macos` / Chrome as a
fallback). Confirm: first launch shows the location picker; after picking,
Today shows today's WOD for that branch; date strip and branch switcher
work; pull-to-refresh works.

- [ ] **Step 4: Commit any fixes**

```bash
git add -A && git commit -m "fix: integration fixes from device run"
```

### Task 3.4: Contribution guidelines + README

**Files:** Create `AGENTS.md`; Modify `README.md`.

- [ ] **Step 1: `AGENTS.md`** — adapted from x4 per the spec §7: layering,
  Cubit state-owner pattern, sealed `AppFailure`, no bare `print`, the lint
  rule set, tokens-only styling, `freezed` models, spec→plan→execute flow,
  `tool/dev/check.sh`, conventional commits. Drop the enterprise machinery.

- [ ] **Step 2: `README.md`** — what the app is, the data-source caveat,
  quickstart (`flutter pub get` → `build_runner` → `flutter run`), project
  layout table, link to spec/plan/AGENTS/DESIGN.

- [ ] **Step 3: Commit**

```bash
git add AGENTS.md README.md
git commit -m "docs: contribution guidelines + README"
```

---

## Definition of Done

- `bash tool/dev/check.sh` prints `ALL GREEN`.
- `flutter build apk --debug` and `flutter build ios --debug --no-codesign`
  both succeed.
- App launches on a device: first run → location picker; thereafter →
  Today screen showing today's WOD for the favorite branch.
- Date strip, branch switcher, browse, detail, pull-to-refresh, offline
  cache all work.
- `AGENTS.md`, `DESIGN.md`, `README.md`, spec and plan committed.
