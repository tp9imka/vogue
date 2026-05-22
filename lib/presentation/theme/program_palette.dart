/// Per-program color coding for the Vogue WOD app.
///
/// Each of the five [Program] types carries its own accent so a member can
/// identify a workout at a glance. The five hues are mutually distinct and
/// distinct from the volt-lime brand accent in `VogueColors`.
///
/// Two roles per program:
/// - [programAccent] — a saturated, high-energy hue for badges, headings and
///   left-edge bars. Pair with near-black text/icons on top of a filled chip.
/// - [programSurface] — a soft, dark-tinted background that sits cleanly on
///   the dark surface ramp; used for badge fills and card wash.
library;

import 'package:flutter/widgets.dart';
import 'package:vogue_wod/domain/models/program.dart';

/// The saturated accent color for [program].
///
/// VogueFit → orange, Metcon → red, WOD → blue, Speciality → violet,
/// Stamina → green.
Color programAccent(Program program) {
  switch (program) {
    case Program.vogueFit:
      return const Color(0xFFFF6A2B);
    case Program.metcon:
      return const Color(0xFFF4364C);
    case Program.wod:
      return const Color(0xFF2E8BFF);
    case Program.speciality:
      return const Color(0xFF9B5CF6);
    case Program.stamina:
      return const Color(0xFF27C281);
  }
}

/// A soft, dark-tinted background tuned to [program]'s accent.
///
/// These sit on the dark surface ramp without glare — use them for badge
/// fills, card washes and selected-state tints.
Color programSurface(Program program) {
  switch (program) {
    case Program.vogueFit:
      return const Color(0xFF2A1810);
    case Program.metcon:
      return const Color(0xFF2C1216);
    case Program.wod:
      return const Color(0xFF111E2E);
    case Program.speciality:
      return const Color(0xFF1C162C);
    case Program.stamina:
      return const Color(0xFF0F2419);
  }
}
