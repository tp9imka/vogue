import 'package:flutter_test/flutter_test.dart';
import 'package:vogue_wod/data/wod_local_cache.dart';
import 'package:vogue_wod/domain/models/branch.dart';
import 'package:vogue_wod/domain/models/program.dart';
import 'package:vogue_wod/domain/models/wod.dart';
import 'package:vogue_wod/domain/models/wod_section.dart';

void main() {
  test('write then read returns the same wods', () async {
    final cache = WodLocalCache.inMemory();
    final wods = [
      Wod(
        date: DateTime(2026, 5, 22),
        branch: Branch.jlt,
        program: Program.metcon,
        sections: const [WodSection(lines: ['row'])],
      ),
    ];
    await cache.write(wods);
    final snapshot = await cache.read();
    expect(snapshot!.wods, wods);
    expect(snapshot.fetchedAt, isNotNull);
  });

  test('read returns null when nothing was cached', () async {
    expect(await WodLocalCache.inMemory().read(), isNull);
  });
}
