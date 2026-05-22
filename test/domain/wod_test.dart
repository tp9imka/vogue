import 'package:flutter_test/flutter_test.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/domain/models/program.dart';
import 'package:vogue_wod/domain/models/wod.dart';
import 'package:vogue_wod/domain/models/wod_section.dart';

void main() {
  group('Branch', () {
    test('fromRaw strips the "Vogue Fitness |" prefix', () {
      expect(Branch.fromRaw('Vogue Fitness | Yas Marina'), Branch.yasMarina);
      expect(Branch.fromRaw('Vogue Fitness | Al Ain Mixed'), Branch.alAinMixed);
      expect(Branch.fromRaw('Vogue Fitness | JLT'), Branch.jlt);
    });

    test('fromRaw returns null for an unknown location', () {
      expect(Branch.fromRaw('Some Other Gym'), isNull);
    });
  });

  group('Program', () {
    test('fromRaw is case-insensitive', () {
      expect(Program.fromRaw('metcon'), Program.metcon);
      expect(Program.fromRaw('  VogueFit '), Program.vogueFit);
      expect(Program.fromRaw('SPECIALITY'), Program.speciality);
    });

    test('fromRaw defaults unknown values to wod', () {
      expect(Program.fromRaw('???'), Program.wod);
    });
  });

  group('Wod', () {
    test('survives a JSON round-trip', () {
      final wod = Wod(
        date: DateTime(2026, 5, 22),
        branch: Branch.jlt,
        program: Program.metcon,
        sections: const [
          WodSection(title: 'Metcon', lines: ['100 cal row', '80 deadlift']),
        ],
        note: 'NO RESERVATION, NO CLASS.',
      );

      expect(Wod.fromJson(wod.toJson()), wod);
    });
  });
}
