/// Design tokens for the Vogue WOD app.
///
/// Vogue Fitness is a CrossFit box — the visual language is bold, energetic,
/// high-contrast and dark-first. Every value here is the single source of
/// truth; feature code must reference these tokens rather than raw literals.
///
/// The token vocabulary is documented in `DESIGN.md` at the repo root.
library;

import 'package:flutter/widgets.dart';

/// Color tokens: a dark surface ramp, a neutral ink ramp, the high-energy
/// volt accent, on-colors and semantic colors.
///
/// Contrast: every text on-color below clears WCAG AA (>= 4.5:1) on its
/// intended background. The dark surface ramp is faintly cool-neutral so it
/// reads as deliberate athletic black, not a flat console grey.
abstract final class VogueColors {
  // --- Dark surface ramp (background -> raised) -----------------------------

  /// App backdrop. The deepest surface, behind everything.
  static const Color surface = Color(0xFF0C0E11);

  /// Default container surface (cards, sheets) one step above [surface].
  static const Color surfaceRaised = Color(0xFF15181D);

  /// A further-raised surface for nested or hovered containers.
  static const Color surfaceHigh = Color(0xFF1E222A);

  /// Hairline borders and dividers on dark surfaces.
  static const Color outline = Color(0xFF2C313B);

  // --- Neutral ink ramp (text on dark) -------------------------------------

  /// Primary text on dark surfaces. Near-white, ~17.8:1 on [surface].
  static const Color ink = Color(0xFFF4F6F8);

  /// Secondary / supporting text. ~9.2:1 on [surface] — clears AA.
  static const Color inkMuted = Color(0xFFAEB6C2);

  /// Tertiary text: timestamps, captions, disabled-ish copy.
  /// ~4.7:1 on [surface] — clears AA for normal text.
  static const Color inkFaint = Color(0xFF7C8593);

  // --- High-energy brand accent --------------------------------------------

  /// The Vogue volt accent — a vivid electric lime. Primary CTA / brand mark.
  static const Color primary = Color(0xFFC8FA4B);

  /// A pressed / darker variant of [primary] for active states.
  static const Color primaryDim = Color(0xFFA6D62F);

  /// Faint volt wash for selected-row tints and subtle accent fills.
  static const Color primarySoft = Color(0xFF1F2A12);

  /// Text / icons drawn on top of [primary]. Near-black, ~14.6:1 on primary.
  static const Color onPrimary = Color(0xFF0C0E11);

  // --- Semantic colors -----------------------------------------------------

  /// Success — confirmations, "fresh data" indicators.
  static const Color success = Color(0xFF36D399);

  /// Warning — stale cache, "last updated a while ago".
  static const Color warning = Color(0xFFFFC247);

  /// Error — failed fetch, parse failure.
  static const Color error = Color(0xFFFF5A5F);

  /// Info — neutral informational accents.
  static const Color info = Color(0xFF4FA8FF);

  /// Text / icons drawn on top of any saturated semantic color.
  static const Color onSemantic = Color(0xFF0C0E11);
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
