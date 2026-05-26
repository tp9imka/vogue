import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/wod_log_entry.dart';

/// Persists the user's training log — which WODs they have marked done,
/// plus their optional score / notes. Local only, no backend.
abstract class WodLogStore {
  /// A store backed by `shared_preferences`.
  factory WodLogStore.prefs() = _PrefsWodLogStore;

  /// An in-memory store — test seam.
  factory WodLogStore.inMemory() = _MemoryWodLogStore;

  /// Reads every entry keyed by [WodLogEntry.wodKey].
  Future<Map<String, WodLogEntry>> readAll();

  /// Creates or updates [entry].
  Future<void> upsert(WodLogEntry entry);

  /// Removes the entry for [wodKey], if any.
  Future<void> remove(String wodKey);
}

String _encode(Map<String, WodLogEntry> entries) => jsonEncode(
  entries.map((key, entry) => MapEntry(key, entry.toJson())),
);

Map<String, WodLogEntry> _decode(String? raw) {
  if (raw == null || raw.isEmpty) return const {};
  final map = jsonDecode(raw) as Map<String, dynamic>;
  return map.map(
    (k, v) => MapEntry(k, WodLogEntry.fromJson(v as Map<String, dynamic>)),
  );
}

class _PrefsWodLogStore implements WodLogStore {
  static const _key = 'wod_log_entries_v1';

  @override
  Future<Map<String, WodLogEntry>> readAll() async {
    final prefs = await SharedPreferences.getInstance();
    return _decode(prefs.getString(_key));
  }

  @override
  Future<void> upsert(WodLogEntry entry) async {
    final all = await readAll();
    final next = {...all, entry.wodKey: entry};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _encode(next));
  }

  @override
  Future<void> remove(String wodKey) async {
    final all = await readAll();
    if (!all.containsKey(wodKey)) return;
    final next = Map.of(all)..remove(wodKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _encode(next));
  }
}

class _MemoryWodLogStore implements WodLogStore {
  String? _raw;

  @override
  Future<Map<String, WodLogEntry>> readAll() async => _decode(_raw);

  @override
  Future<void> upsert(WodLogEntry entry) async {
    final all = await readAll();
    _raw = _encode({...all, entry.wodKey: entry});
  }

  @override
  Future<void> remove(String wodKey) async {
    final all = await readAll();
    if (!all.containsKey(wodKey)) return;
    _raw = _encode(Map.of(all)..remove(wodKey));
  }
}
