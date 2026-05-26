import 'package:flutter_test/flutter_test.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/domain/models/program.dart';
import 'package:vogue_wod/domain/models/wod.dart';
import 'package:vogue_wod/domain/models/wod_section.dart';
import 'package:vogue_wod/presentation/timer/workout_timer.dart';

Wod _wod(List<String> lines, {String? title}) => Wod(
  date: DateTime(2026, 5, 27),
  branch: Branch.jlt,
  program: Program.metcon,
  sections: [WodSection(title: title, lines: lines)],
);

void main() {
  group('detectTimer', () {
    test('AMRAP — "15 min AMRAP"', () {
      final spec = detectTimer(_wod(['15 min AMRAP', '10 burpees']));
      expect(spec, isNotNull);
      expect(spec!.mode, TimerMode.amrap);
      expect(spec.total, const Duration(minutes: 15));
    });

    test('AMRAP — "AMRAP 20"', () {
      final spec = detectTimer(_wod(['AMRAP 20', 'pull-ups']));
      expect(spec!.mode, TimerMode.amrap);
      expect(spec.total, const Duration(minutes: 20));
    });

    test('EMOM — "EMOM 12"', () {
      final spec = detectTimer(_wod(['EMOM 12', 'odd: 5 thrusters']));
      expect(spec!.mode, TimerMode.emom);
      expect(spec.total, const Duration(minutes: 12));
      expect(spec.rounds, 12);
    });

    test('EMOM — "Every minute on the minute for 10"', () {
      final spec = detectTimer(
        _wod(['Every minute on the minute for 10', '5 push-ups']),
      );
      expect(spec!.mode, TimerMode.emom);
      expect(spec.total, const Duration(minutes: 10));
    });

    test('Tabata — default 8 rounds', () {
      final spec = detectTimer(_wod(['Tabata burpees']));
      expect(spec!.mode, TimerMode.tabata);
      expect(spec.rounds, 8);
      expect(spec.work, const Duration(seconds: 20));
      expect(spec.rest, const Duration(seconds: 10));
      expect(spec.total, const Duration(seconds: 240));
    });

    test('Tabata — explicit rounds wins', () {
      final spec = detectTimer(_wod(['Tabata burpees, 6 rounds']));
      expect(spec!.rounds, 6);
      expect(spec.total, const Duration(seconds: 180));
    });

    test('For Time', () {
      final spec = detectTimer(_wod(['21-15-9 reps for time']));
      expect(spec!.mode, TimerMode.forTime);
      expect(spec.total, Duration.zero);
    });

    test('returns null when no domain is declared', () {
      final spec = detectTimer(_wod(['Strength: 5x5 back squat']));
      expect(spec, isNull);
    });

    test('Tabata wins over For Time when both mentioned', () {
      final spec = detectTimer(_wod(['Tabata sit-ups for time']));
      expect(spec!.mode, TimerMode.tabata);
    });
  });
}
