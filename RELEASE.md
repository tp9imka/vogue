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

1. Play Console → create the app → upload the `.aab`.
2. Complete the store listing: title, short & full description, screenshots
   (phone, and optionally tablet), feature graphic (1024×500), app icon.
3. Fill the **Data Safety** form — this app collects no data (see
   `PRIVACY.md`).
4. Complete the content-rating questionnaire.
5. Provide the **Privacy Policy URL** (host `PRIVACY.md` somewhere public).
6. Roll out to a testing track first, then production.

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
