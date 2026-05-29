# Release & Publishing Runbook

How to build and publish Vogue WOD Schedule to the App Store and
Google Play.

## Before any release

1. Bump the version in `pubspec.yaml` — `version: <name>+<build>`
   (e.g. `1.0.1+2`). The build number must increase every upload.
2. `bash tool/dev/check.sh` → must print `ALL GREEN`.
3. If the app icon changed: re-run
   `flutter test tool/generate_brand_assets.dart`, then
   `dart run flutter_launcher_icons` and `dart run flutter_native_splash:create`.

## Android — Google Play

### One-time setup

- A **Google Play Console** account ($25, one-time).
- The **upload keystore** already exists at
  `android/app/upload-keystore.jks`, and its credentials are in
  `android/key.properties`.
  - ⚠️ **Both files are git-ignored. Back them up somewhere safe and
    permanent.** If you lose the keystore you can never update the
    published app. Store a copy in a password manager or secure vault.
  - On a fresh machine, restore both files into `android/` and
    `android/app/` before building a release.

### Build

```bash
flutter build appbundle --release \
  --obfuscate --split-debug-info=build/symbols/android
```

Output: `build/app/outputs/bundle/release/app-release.aab` — this is what
you upload to Play.

`--obfuscate` strips Dart symbol names from the binary; the matching
symbols are written to `build/symbols/android/` so you can decode
production stack traces later. **Back the `build/symbols/android/` folder
up alongside the keystore — it is per-build and you cannot regenerate it.**

### Publish

1. Play Console → create the app → upload the `.aab` to **Internal
   Testing** first (no review, instant distribution to up to 100
   testers).
2. Complete the store listing using the assets below.
3. Fill every left-sidebar section (data safety, content rating,
   target audience, etc.) using the pre-canned answers below.
4. **The 14-day rule.** As of 2024, new Personal developer accounts
   must run **Closed Testing with 20+ testers for ≥ 14 days** before
   applying for production access. Recruit testers via the Closed
   Testing opt-in URL early.
5. After the 14-day window: **Setup → App access → Apply for
   production access**. Google reviews ~1-3 days. After approval, the
   Production track unlocks and you can roll out.

### Feature graphic

Required by Play; not by Apple. 1024×500 PNG, brand-styled. Regenerate
after any text / icon change:

```bash
bash tool/generate_feature_graphic.sh
# -> assets/brand/feature_graphic.png
```

Editable in `tool/feature_graphic.html` (HTML + real Google Fonts,
rendered headless Chrome).

### Screenshots — Play-ready

Play rejects screenshots taller than **2:1** (longest ÷ shortest).
Modern iPhone shots at 1284×2778 are 2.16:1, just over. Pad them with
jet `#0A0908` to 1389×2778 (exactly 2:1):

```bash
for f in screens/1284x2778/IMG_*.PNG; do
  sips --padToHeightWidth 2778 1389 --padColor 0A0908 "$f" \
    --out "screens/play/$(basename "$f")"
done
```

The padded `.PNG`s under `screens/play/` are the ones you drag into
Play Console.

### Pre-canned answers for the policy questionnaires

| Section | Answer |
|---|---|
| **App information → Category** | Health & Fitness |
| **Data safety → Data collection / sharing** | None — answer "No" to every category |
| **Content rating** | Answer "No" / "None" to every question → result **Everyone / PEGI 3** |
| **Target audience and content → Age group** | 18+ (or 13+ if you want broader reach); tick "App not designed for children" |
| **Ads** | No |
| **News apps** | No |
| **Government apps** | No |
| **COVID-19 contact tracing** | No |
| **Financial features** | None |
| **Health features** | None — the app is a schedule reader, not a health-data collector |
| **Privacy Policy URL** | `https://tp9imka.github.io/vogue/privacy/` |
| **Contact website (optional)** | `https://tp9imka.github.io/vogue/` |

### App access (if Play asks for credentials)

Same as the iOS App Review notes: no sign-in required, the app opens
on first launch and asks you to pick a branch. Tick **"All
functionality in our app is available without any special access"**.

## iOS — App Store

### One-time setup

- An **Apple Developer Program** membership ($99/year).
- **Install the iOS platform in Xcode**: Xcode → Settings → Components →
  install the iOS platform/SDK. (Until this is done, no iOS build will
  succeed on this machine.)
- In Xcode, open `ios/Runner.xcworkspace` → select the `Runner` target →
  **Signing & Capabilities** → set your **Team**. Automatic signing will
  create the certificate and provisioning profile.
- The bundle identifier is **`com.tp9imka.wod`** — register it in the
  Apple Developer portal (or let Xcode register it on first build).

### Build

```bash
flutter build ipa --release \
  --obfuscate --split-debug-info=build/symbols/ios
```

Output: `build/ios/ipa/*.ipa`. Back up `build/symbols/ios/` per release
to decode production crash reports.

### Publish

1. Upload the `.ipa` with **Transporter** (Mac App Store) or via Xcode
   Organizer.
2. In **App Store Connect**: create the app record, add screenshots
   (6.7" and 6.5" iPhone sizes required), description, keywords.
3. Fill **App Privacy** — choose "Data Not Collected" (see `PRIVACY.md`).
4. Provide the **Privacy Policy URL**.
5. Export compliance is pre-answered in `Info.plist`
   (`ITSAppUsesNonExemptEncryption = false`).
6. Submit for review.

## Store listing copy (starting point)

- **Name:** Vogue WOD Schedule
- **Subtitle / short description:** Unofficial daily-workout reader for
  Vogue Fitness UAE.
- **Description:** Vogue WOD Schedule is an unofficial reader for the
  daily workouts (WODs) posted by Vogue Fitness UAE. Pick your home
  branch once and the app opens straight to today's workout. Swipe
  through the days, switch branches, browse every location, and read
  each workout full-screen with a built-in timer (AMRAP / EMOM / Tabata
  / For Time) and a personal training log. Works offline. Not affiliated
  with, or endorsed by, Vogue Fitness — the brand name is used
  descriptively to identify whose schedule is shown.

## Important note on rights

The app displays content and uses the branding of **Vogue Fitness**.
Confirm you are authorized to publish an app using their name and schedule
data before submitting to either store — both stores can reject or remove
apps that use a third party's brand or content without permission.
