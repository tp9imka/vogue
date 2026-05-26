import 'package:flutter_test/flutter_test.dart';
import 'package:vogue_wod/data/wod_log_store.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/domain/models/program.dart';
import 'package:vogue_wod/domain/models/wod_log_entry.dart';

WodLogEntry _entry(String key, {String? score, String? note}) => WodLogEntry(
  wodKey: key,
  doneAt: DateTime(2026, 5, 27, 7, 30),
  wodDate: DateTime(2026, 5, 27),
  branch: Branch.jlt,
  program: Program.metcon,
  score: score,
  note: note,
);

void main() {
  group('WodLogStore.inMemory', () {
    test('readAll on a fresh store returns empty', () async {
      final store = WodLogStore.inMemory();
      expect(await store.readAll(), isEmpty);
    });

    test('upsert then readAll round-trips the entry', () async {
      final store = WodLogStore.inMemory();
      final entry = _entry('k1', score: '12+3', note: 'felt good');
      await store.upsert(entry);
      final all = await store.readAll();
      expect(all, hasLength(1));
      expect(all['k1'], entry);
    });

    test('upsert overwrites the existing entry for the same key', () async {
      final store = WodLogStore.inMemory();
      await store.upsert(_entry('k1', score: 'first'));
      await store.upsert(_entry('k1', score: 'second'));
      final all = await store.readAll();
      expect(all['k1']!.score, 'second');
    });

    test('remove deletes the entry', () async {
      final store = WodLogStore.inMemory();
      await store.upsert(_entry('k1'));
      await store.remove('k1');
      expect(await store.readAll(), isEmpty);
    });
  });
}
