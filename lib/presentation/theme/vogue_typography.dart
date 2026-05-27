/// Typography scale.
///
/// Three families, each with one job:
/// - **Bodoni Moda** (italic, heavy): editorial display + headlines. Carries
///   the brand's publication voice.
/// - **Inter**: the rest of the interface. Body, titles, labels, workout
///   content.
/// - **JetBrains Mono**: tabular numerals — the workout timer and any
///   columnar data.
///
/// Fonts are lazy-loaded via the `google_fonts` package on first launch and
/// cached locally afterwards. Colors are intentionally omitted from these
/// styles — `vogue_theme.dart` applies the ink / on-surface mapping via the
/// `ColorScheme` and `TextTheme`, so the same scale reuses across surfaces.
library;

import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

/// The type scale. Six roles, each a `TextStyle`:
/// `display` > `headline` > `title` > `body` > `label`, plus `workout` (a
/// large, generously-leaded reading style for the workout itself) and
/// `timer` (tabular monospace for the big timer numerals).
abstract final class VogueTypography {
  /// Big editorial display — italic Bodoni Moda. The date header, hero
  /// numbers, the cover-page title treatment.
  static final TextStyle display = GoogleFonts.bodoniModa(
    fontSize: 44,
    height: 0.95,
    fontWeight: FontWeight.w900,
    fontStyle: FontStyle.italic,
    letterSpacing: -1,
  );

  /// Section headings — italic Bodoni Moda, smaller than display.
  static final TextStyle headline = GoogleFonts.bodoniModa(
    fontSize: 26,
    height: 1.1,
    fontWeight: FontWeight.w900,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.5,
  );

  /// Card / app-bar titles — Inter, semibold. Clean and unfussy next to the
  /// italic display type.
  static final TextStyle title = GoogleFonts.inter(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );

  /// Default running text for details and descriptions.
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 15,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  /// Small UI text — badges, captions, timestamps, button labels. Wide
  /// tracking; pair with `.toUpperCase()` at the call site.
  static final TextStyle label = GoogleFonts.inter(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.8,
  );

  /// Workout content. Large, with generous leading so a member can glance
  /// down at their phone mid-session and read a movement instantly. The
  /// single most important style in the app.
  static final TextStyle workout = GoogleFonts.inter(
    fontSize: 20,
    height: 1.55,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  /// Tabular monospace for the workout timer. Naturally tabular, so digits
  /// don't jitter when the seconds tick over.
  static final TextStyle timer = GoogleFonts.jetBrainsMono(
    fontSize: 96,
    height: 1,
    fontWeight: FontWeight.w800,
    letterSpacing: -2,
  );
}
