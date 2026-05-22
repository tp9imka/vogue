import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vogue_wod/core/failure.dart';
import 'package:vogue_wod/core/result.dart';
import 'package:vogue_wod/data/wod_local_cache.dart';
import 'package:vogue_wod/data/wod_remote_source.dart';
import 'package:vogue_wod/data/wod_repository_impl.dart';
import 'package:vogue_wod/domain/wod_repository.dart';

class _MockRemote extends Mock implements WodRemoteSource {}

void main() {
  late _MockRemote remote;
  late WodLocalCache cache;
  setUp(() {
    remote = _MockRemote();
    cache = WodLocalCache.inMemory();
  });

  test('refresh fetches, parses, caches and returns fresh feed', () async {
    const html = '''
<div class="gv-list-view">
  <h4 class="gv-field-30-5">22/05/2026</h4>
  <h4 class="gv-field-30-2">Vogue Fitness | JLT</h4>
  <h4 class="gv-field-30-3">Metcon</h4>
  <div class="gv-field-30-4"><p>100 cal row</p></div></div>''';
    when(remote.fetchHtml).thenAnswer((_) async => const Ok(html));
    final repo = WodRepositoryImpl(remote: remote, cache: cache);

    final res = await repo.refresh();
    expect(res, isA<Ok<WodFeed>>());
    expect((res as Ok<WodFeed>).value.wods, hasLength(1));
    expect(res.value.stale, isFalse);
    expect((await repo.cached())!.wods, hasLength(1));
  });

  test('refresh falls back to stale cache on network failure', () async {
    const html = '''
<div class="gv-list-view">
  <h4 class="gv-field-30-5">22/05/2026</h4>
  <h4 class="gv-field-30-2">Vogue Fitness | JLT</h4>
  <h4 class="gv-field-30-3">Metcon</h4>
  <div class="gv-field-30-4"><p>row</p></div></div>''';
    when(remote.fetchHtml).thenAnswer((_) async => const Ok(html));
    final repo = WodRepositoryImpl(remote: remote, cache: cache);
    await repo.refresh(); // seed cache

    when(remote.fetchHtml).thenAnswer((_) async => const Err(NetworkFailure()));
    final res = await repo.refresh();
    expect(res, isA<Ok<WodFeed>>());
    expect((res as Ok<WodFeed>).value.stale, isTrue);
  });

  test('refresh returns Err when network fails and cache empty', () async {
    when(remote.fetchHtml).thenAnswer((_) async => const Err(NetworkFailure()));
    final repo = WodRepositoryImpl(remote: remote, cache: cache);
    expect(await repo.refresh(), isA<Err<WodFeed>>());
  });
}
