import '../core/failure.dart';
import '../core/result.dart';
import '../domain/wod_repository.dart';
import 'wod_html_parser.dart';
import 'wod_local_cache.dart';
import 'wod_remote_source.dart';

/// Cache-first [WodRepository]: serves the local snapshot instantly and
/// refreshes from the network, falling back to a stale cache when offline.
class WodRepositoryImpl implements WodRepository {
  /// Creates a [WodRepositoryImpl] from its [remote] and [cache] adapters.
  WodRepositoryImpl({
    required WodRemoteSource remote,
    required WodLocalCache cache,
  })  : _remote = remote,
        _cache = cache;

  final WodRemoteSource _remote;
  final WodLocalCache _cache;

  @override
  Future<WodFeed?> cached() async {
    final snap = await _cache.read();
    if (snap == null) return null;
    return WodFeed(wods: snap.wods, fetchedAt: snap.fetchedAt, stale: true);
  }

  @override
  Future<Result<WodFeed>> refresh() async {
    final res = await _remote.fetchHtml();
    switch (res) {
      case Ok<String>(:final value):
        final wods = parseWods(value);
        if (wods.isEmpty) {
          final fallback = await cached();
          return fallback != null
              ? Ok(fallback)
              : const Err(ParseFailure(detail: 'no entries parsed'));
        }
        await _cache.write(wods);
        return Ok(
          WodFeed(wods: wods, fetchedAt: DateTime.now(), stale: false),
        );
      case Err<String>(:final failure):
        final fallback = await cached();
        return fallback != null ? Ok(fallback) : Err(failure);
    }
  }
}
