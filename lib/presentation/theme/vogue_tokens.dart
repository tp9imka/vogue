/// Design tokens for the app.
///
/// The brand is editorial / "publication" — warm paper-and-ink rather than
/// the previous neon-energy. The dark surface ramp goes from `jet` (deepest)
/// through `soot` and `char`; the ink ramp is a warm cream (`bone`). The
/// single brand accent is `cinnabar`. Every value here is the single source
/// of truth; feature code must reference these tokens rather than raw
/// literals.
///
/// The token vocabulary is documented in `DESIGN.md` at the repo root.
library;

import 'package:flutter/widgets.dart';

/// Color tokens.
///
/// The class is dark-first — the app currently runs in dark mode. Light
/// surfaces are exposed for future light-theme support; widgets that
/// hard-code `surface` / `ink` / `surfaceRaised` will continue to read
/// "dark" until they migrate to `Theme.of(context).colorScheme.*`.
abstract final class VogueColors {
  // --- Dark surface ramp (background -> floating) --------------------------

  /// App backdrop. The deepest surface, behind everything.
  static const Color surface = Color(0xFF0A0908); // jet

  /// Default container surface (cards, sheets) one step above [surface].
  static const Color surfaceRaised = Color(0xFF1E1B17); // soot

  /// A further-raised surface for sheets and floating panels.
  static const Color surfaceHigh = Color(0xFF2A2620); // char

  /// Hairline borders and dividers on dark surfaces.
  static const Color outline = Color(0xFF3A342C); // char-2

  // --- Ink ramp (text on dark) ---------------------------------------------

  /// Primary text on dark surfaces — warm near-white.
  static const Color ink = Color(0xFFF1E9D8); // bone

  /// Secondary / supporting text. Roughly bone @ 62% opacity.
  static const Color inkMuted = Color(0x9EF1E9D8);

  /// Tertiary text: timestamps, captions, hint copy. Roughly bone @ 38%.
  static const Color inkFaint = Color(0x61F1E9D8);

  // --- Light surface + ink (reference values for future light theme) -------

  /// Light surface backdrop — warm off-white.
  static const Color paper = Color(0xFFFBF8F3);

  /// Slightly tinted paper for raised surfaces.
  static const Color paperRaised = Color(0xFFEFE9DC);

  /// Primary text on light surfaces.
  static const Color inkOnLight = Color(0xFF181410);

  /// Secondary text on light surfaces — ink @ 62%.
  static const Color inkMutedOnLight = Color(0x9E181410);

  // --- Brand accent --------------------------------------------------------

  /// Cinnabar — the single brand accent, used sparingly. Primary CTAs,
  /// brand marks, and program "Metcon" reuse this hue.
  static const Color primary = Color(0xFFD85F3C);

  /// A darker variant of [primary] for pressed / active states.
  static const Color primaryDim = Color(0xFFB84F32);

  /// Faint cinnabar wash for selected-row tints and subtle accent fills.
  static const Color primarySoft = Color(0xFF3A1F18);

  /// Text / icons drawn on top of [primary]. Ink on cinnabar clears
  /// WCAG AA Normal (~5:1).
  static const Color onPrimary = Color(0xFF181410); // ink

  // --- Semantic colors -----------------------------------------------------

  /// Success — confirmations, "fresh data" indicators. A muted sage-green
  /// that lives in the same family as the program sage.
  static const Color success = Color(0xFF6B9F7E);

  /// Warning — stale cache, "last updated a while ago". A deeper bone gold.
  static const Color warning = Color(0xFFC49141);

  /// Error — failed fetch, parse failure. Darker red, distinct from the
  /// brand cinnabar.
  static const Color error = Color(0xFFB84738);

  /// Info — neutral informational accents. Deeper cobalt.
  static const Color info = Color(0xFF587FB8);

  /// Text / icons drawn on top of any saturated semantic / program color.
  /// Ink clears WCAG AA Normal on every program hue in the palette.
  static const Color onSemantic = Color(0xFF181410); // ink
}

/// Spacing tokens — a strict 4-point scale. Use for padding, margins and gaps.
abstract final class VogueSpace {
  /// 4 — hairline gaps, icon-to-label spacing.
  static const double xs = 4;

  /// 8 — tight internal padding.
  static const double sm = 8;

  /// 12 — default control padding.
  static const double md = 12;

  /// 16 — standard screen / card padding.
  static const double lg = 16;

  /// 24 — section separation.
  static const double xl = 24;

  /// 32 — large block separation, screen top/bottom breathing room.
  static const double xxl = 32;
}

/// Corner-radius tokens.
abstract final class VogueRadius {
  /// 8 — chips, small controls, inputs.
  static const double sm = 8;

  /// 14 — cards, sheets, primary containers.
  static const double md = 14;

  /// 20 — hero containers, large surfaces.
  static const double lg = 20;

  /// 999 — fully rounded pills (badges, date chips, buttons).
  static const double pill = 999;
}

/// Elevation tokens — z-depth values handed to `Material` / `Card` widgets.
///
/// Dark UIs lean on surface tint and borders more than drop shadows; the set
/// is deliberately small.
abstract final class VogueElevation {
  /// 0 — flat, flush with its parent surface.
  static const double flat = 0;

  /// 2 — resting cards, gently lifted from the background.
  static const double low = 2;

  /// 6 — app bars, sticky headers.
  static const double medium = 6;

  /// 12 — modal sheets, dialogs, anything floating above the page.
  static const double high = 12;
}

/// Motion duration tokens. Pair with `Curves.easeOutCubic` for most UI.
abstract final class VogueDuration {
  /// 120ms — taps, ripples, micro-feedback.
  static const Duration fast = Duration(milliseconds: 120);

  /// 240ms — standard transitions, expands, fades.
  static const Duration medium = Duration(milliseconds: 240);

  /// 400ms — page-level transitions, larger reveals.
  static const Duration slow = Duration(milliseconds: 400);
}
