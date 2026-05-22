import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vogue_wod/data/wod_html_parser.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/domain/models/program.dart';

void main() {
  late String html;
  setUpAll(() {
    html = File('test/fixtures/vfuae_wod_sample.html').readAsStringSync();
  });

  test('parses many WOD entries', () {
    final wods = parseWods(html);
    expect(wods.length, greaterThan(100));
  });

  test('every parsed WOD has a known branch and non-empty sections', () {
    for (final w in parseWods(html)) {
      expect(Branch.values, contains(w.branch));
      expect(w.sections, isNotEmpty);
    }
  });

  test('dates are parsed as DD/MM/YYYY', () {
    final wods = parseWods(html);
    expect(wods.every((w) => w.date.year == 2026), isTrue);
    expect(wods.any((w) => w.date.month == 5), isTrue);
  });

  test('boilerplate is moved out of sections into note', () {
    final withNote = parseWods(html).where((w) => w.note != null);
    expect(withNote, isNotEmpty);
    for (final w in withNote) {
      expect(w.note!.toUpperCase(), contains('NO RESERVATION'));
      for (final s in w.sections) {
        for (final l in s.lines) {
          expect(l.toUpperCase().contains('NO RESERVATION'), isFalse);
        }
      }
    }
  });

  test('all five program types appear', () {
    final progs = parseWods(html).map((w) => w.program).toSet();
    expect(progs, containsAll(Program.values));
  });

  test('returns empty list for junk input without throwing', () {
    expect(parseWods('<html><body>nothing</body></html>'), isEmpty);
  });
}
