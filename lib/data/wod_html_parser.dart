import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

import '../core/logger.dart';
import '../domain/models/branch.dart';
import '../domain/models/program.dart';
import '../domain/models/wod.dart';
import '../domain/models/wod_section.dart';

const _noteMarker = 'NO RESERVATION';

/// Parses the GravityView `/wod/` HTML into typed [Wod] entries.
///
/// Each `.gv-list-view` block carries a date, location, program and an HTML
/// description. Malformed blocks (missing fields, unknown branch, unparseable
/// date, empty description) are skipped rather than failing the whole parse.
List<Wod> parseWods(String html) {
  final doc = html_parser.parse(html);
  final out = <Wod>[];
  for (final el in doc.querySelectorAll('.gv-list-view')) {
    final wod = _parseEntry(el);
    if (wod != null) out.add(wod);
  }
  return out;
}

Wod? _parseEntry(Element el) {
  final dateRaw = el.querySelector('.gv-field-30-5')?.text.trim();
  final locRaw = el.querySelector('.gv-field-30-2')?.text.trim();
  final progRaw = el.querySelector('.gv-field-30-3')?.text.trim();
  final descEl = el.querySelector('.gv-field-30-4');
  if (dateRaw == null || locRaw == null || progRaw == null) return null;

  final branch = Branch.fromRaw(locRaw);
  final date = _parseDate(dateRaw);
  if (branch == null || date == null) {
    Log.w('skipped WOD block: loc="$locRaw" date="$dateRaw"');
    return null;
  }
  final parsed = _parseDescription(descEl);
  if (parsed.sections.isEmpty) return null;

  return Wod(
    date: date,
    branch: branch,
    program: Program.fromRaw(progRaw),
    sections: parsed.sections,
    note: parsed.note,
  );
}

DateTime? _parseDate(String raw) {
  final m = RegExp(r'(\d{1,2})/(\d{1,2})/(\d{4})').firstMatch(raw);
  if (m == null) return null;
  return DateTime(
    int.parse(m.group(3)!),
    int.parse(m.group(2)!),
    int.parse(m.group(1)!),
  );
}

class _Desc {
  const _Desc(this.sections, this.note);

  final List<WodSection> sections;
  final String? note;
}

_Desc _parseDescription(Element? descEl) {
  if (descEl == null) return const _Desc([], null);
  // Each <p> -> a paragraph; split inner text on <br> into lines.
  final paragraphs = <List<String>>[];
  final ps = descEl.querySelectorAll('p');
  final elements = ps.isNotEmpty ? ps : [descEl];
  for (final p in elements) {
    final lines = _lines(p);
    if (lines.isNotEmpty) paragraphs.add(lines);
  }

  String? note;
  final sections = <WodSection>[];
  for (final para in paragraphs) {
    final kept = <String>[];
    for (final line in para) {
      if (line.toUpperCase().contains(_noteMarker)) {
        note = line;
      } else {
        kept.add(line);
      }
    }
    if (kept.isEmpty) continue;
    if (kept.length == 1 && _looksLikeHeading(kept.first)) {
      sections.add(WodSection(title: kept.first, lines: const []));
    } else if (sections.isNotEmpty && sections.last.lines.isEmpty) {
      sections[sections.length - 1] =
          WodSection(title: sections.last.title, lines: kept);
    } else {
      sections.add(WodSection(lines: kept));
    }
  }
  return _Desc(
    sections.where((s) => s.lines.isNotEmpty || s.title != null).toList(),
    note,
  );
}

List<String> _lines(Element p) {
  // innerHtml split on <br> tags, each chunk stripped of tags + decoded.
  final raw = p.innerHtml.split(RegExp(r'<br\s*/?>', caseSensitive: false));
  return raw
      .map((chunk) => html_parser.parseFragment(chunk).text?.trim() ?? '')
      .where((s) => s.isNotEmpty)
      .toList();
}

bool _looksLikeHeading(String line) {
  if (line.length > 32) return false;
  final digits = RegExp(r'\d').allMatches(line).length;
  return digits <= 2 && !line.contains(RegExp(r'[.:]\s'));
}
