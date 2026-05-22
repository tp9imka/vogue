/// Typography scale for the Vogue WOD app.
///
/// No custom font package is used — the app relies on Flutter's bundled
/// platform font. The athletic, bold character comes from heavy weights,
/// tight tracking on headings and generous line-height on workout copy,
/// not from a bespoke typeface.
///
/// Colors are intentionally omitted from these styles. `vogue_theme.dart`
/// applies the ink ramp via the `ColorScheme` / `TextTheme`, so the same
/// scale can be reused on any surface.
library;

import 'package:flutter/widgets.dart';

/// The Vogue type scale.
///
/// Six roles, each a `static const TextStyle`:
/// `display` > `headline` > `title` > `body` > `label`, plus `workout` — a
/// large, loosely-leaded style purpose-built for reading the workout itself
/// mid-session, at arm's length.
abstract final class VogueTypography {
  /// Big, confident screen-defining text — the date header, hero numbers.
  /// Heavy weight and negative tracking give it an athletic, compressed feel.
  static const TextStyle display = TextStyle(
    fontSize: 34,
    height: 1.1,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  /// Section-level headings within a screen.
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  );

  /// Card titles, app-bar titles, prominent list rows.
  static const TextStyle title = TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w700,
  );

  /// Default running text for details and descriptions.
  static const TextStyle body = TextStyle(
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  /// Small UI text — badges, captions, timestamps, button labels.
  /// All-caps usage is encouraged via `copyWith` at the call site; the wide
  /// tracking here is tuned for that.
  static const TextStyle label = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  /// The workout-content style. Large and loosely leaded so a member can
  /// glance down at their phone mid-session and read a movement instantly.
  /// This is the single most important style in the app.
  static const TextStyle workout = TextStyle(
    fontSize: 20,
    height: 1.55,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
}
