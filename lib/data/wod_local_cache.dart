import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../domain/models/wod.dart';

/// A decoded cache entry: the stored WODs plus when they were fetched.
class CacheSnapshot {
  /// Creates a [CacheSnapshot].
  const CacheSnapshot(this.wods, this.fetchedAt);

  /// The cached WOD entries.
  final List<Wod> wods;

  /// When the cached data was originally fetched.
  final DateTime fetchedAt;
}

/// Persists the parsed WOD schedule between app launches.
///
/// Use [WodLocalCache.file] in the app and [WodLocalCache.inMemory] in tests.
abstract class WodLocalCache {
  /// A cache backed by a JSON file under the app documents directory.
  factory WodLocalCache.file() = _FileCache;

  /// A cache backed by an in-memory string — a test seam.
  factory WodLocalCache.inMemory() = _MemoryCache;

  /// Replaces the cached schedule with [wods] and stamps it now.
  Future<void> write(List<Wod> wods);

  /// Reads the cached snapshot, or `null` if nothing is stored.
  Future<CacheSnapshot?> read();
}

String _encode(List<Wod> wods) => jsonEncode({
      'fetchedAt': DateTime.now().toIso8601String(),
      'wods': wods.map((w) => w.toJson()).toList(),
    });

CacheSnapshot? _decode(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final map = jsonDecode(raw) as Map<String, dynamic>;
  final wods = (map['wods'] as List)
      .map((e) => Wod.fromJson(e as Map<String, dynamic>))
      .toList();
  return CacheSnapshot(wods, DateTime.parse(map['fetchedAt'] as String));
}

class _MemoryCache implements WodLocalCache {
  String? _raw;

  @override
  Future<void> write(List<Wod> wods) async => _raw = _encode(wods);

  @override
  Future<CacheSnapshot?> read() async => _decode(_raw);
}

class _FileCache implements WodLocalCache {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/wod_cache.json');
  }

  @override
  Future<void> write(List<Wod> wods) async =>
      (await _file()).writeAsString(_encode(wods));

  @override
  Future<CacheSnapshot?> read() async {
    final f = await _file();
    if (!f.existsSync()) return null;
    return _decode(await f.readAsString());
  }
}
