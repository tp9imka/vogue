/// Per-program color coding.
///
/// Each of the five [Program] types carries its own accent so a workout is
/// identifiable at a glance. The hues are pulled from the brand palette —
/// blush rose, cinnabar, bone gold, sage, cobalt — and read clearly next to
/// the brand's primary cinnabar accent.
///
/// Two roles per program:
/// - [programAccent] — the saturated hue for badges, left-edge bars and
///   headings. Pair with ink (`VogueColors.onSemantic`) on top of a filled
///   chip — ink clears WCAG AA on every program hue.
/// - [programSurface] — a faint dark-tinted wash that sits cleanly on the
///   dark surface ramp; used for card washes and selected-state tints.
library;

import 'package:flutter/widgets.dart';

import '../../domain/models/program.dart';

/// The saturated accent color for [program].
///
/// VogueFit → blush rose, Metcon → cinnabar, WOD → bone gold,
/// Speciality → sage, Stamina → cobalt.
Color programAccent(Program program) {
  switch (program) {
    case Program.vogueFit:
      return const Color(0xFFE5A9A0); // blush rose
    case Program.metcon:
      return const Color(0xFFD85F3C); // cinnabar
    case Program.wod:
      return const Color(0xFFE8C77A); // bone gold
    case Program.speciality:
      return const Color(0xFFA8B89F); // sage
    case Program.stamina:
      return const Color(0xFF6B8CC4); // cobalt
  }
}

/// A faint, dark-tinted wash tuned to [program]'s accent.
///
/// Use for card washes, badge fills on dark surfaces, and selected-state
/// tints — these sit cleanly on the dark surface ramp without glare.
Color programSurface(Program program) {
  switch (program) {
    case Program.vogueFit:
      return const Color(0xFF281C18);
    case Program.metcon:
      return const Color(0xFF2C1A16);
    case Program.wod:
      return const Color(0xFF2A2118);
    case Program.speciality:
      return const Color(0xFF1C231E);
    case Program.stamina:
      return const Color(0xFF16202C);
  }
}
